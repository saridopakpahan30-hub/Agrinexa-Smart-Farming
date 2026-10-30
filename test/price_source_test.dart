import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/screens/market_screen.dart';
import 'package:agrinexa/services/market_service.dart';
import 'package:agrinexa/state/app_state.dart';

void main() {
  tearDown(() {
    MarketService.live = {};
    MarketService.liveAsal = {};
    MarketService.liveSeri = {};
    MarketService.manual = {};
    MarketService.liveError = null;
  });

  test('hanya sumber pasar nyata yang dianggap nyata', () {
    final tgl = DateTime(2026, 10, 25);
    expect(HargaAsal('Pasar Induk Kediri', tgl).nyata, isTrue);
    expect(HargaAsal('contoh', tgl).nyata, isFalse);
    expect(HargaAsal('Basis-Simulasi', tgl).nyata, isFalse);
    expect(HargaAsal('', tgl).nyata, isFalse);
  });

  test('HPP pemerintah: resmi, tapi bukan harga pasar', () {
    final a = HargaAsal('HPP pemerintah (acuan)', DateTime(2025, 1, 15));
    expect(a.kebijakan, isTrue);
    expect(a.nyata, isFalse);
    expect(a.harian, isFalse);
  });

  testWidgets('layar Pasar menyebut asal tiap angka harga', (tester) async {
    tester.view.physicalSize = const Size(520, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();

    // Di tes Supabase tidak siap, jadi segarkan() gagal dan harga catatan
    // maupun live harus dipasang langsung — inilah yang harus dibaca layar.
    MarketService.live = {'kubis': 6000, 'cabai': 32000};
    MarketService.liveAsal = {
      'kubis': HargaAsal('Pasar Induk Kediri', DateTime(2026, 10, 25)),
      'cabai': HargaAsal('basis-simulasi', DateTime(2026, 10, 24)),
    };

    await tester.pumpWidget(
        AppScope(state: state, child: const MaterialApp(home: MarketScreen())));
    await tester.pumpAndSettle();

    final nyata = find.text('Pasar Induk Kediri · 25 Okt');
    await tester.scrollUntilVisible(nyata, 500,
        scrollable: find.byType(Scrollable).first);
    expect(nyata, findsOneWidget);
    expect(find.text('masih simulasi'), findsOneWidget);

    final banner = find.textContaining('harga pasar nyata dari Supabase');
    await tester.scrollUntilVisible(banner, 500,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('1 komoditas memakai harga pasar nyata'),
        findsOneWidget);

    // Simulasi edit di dashboard Supabase: angkanya sudah dimuat ulang dan
    // MarketService.versi naik — layar harus berubah sendiri, tanpa ditutup.
    MarketService.liveAsal['cabai'] =
        HargaAsal('Pasar Induk Kediri', DateTime(2026, 10, 25));
    MarketService.versi.value++;
    await tester.pump();
    expect(find.text('masih simulasi'), findsNothing);
    expect(find.textContaining('2 komoditas memakai harga pasar nyata'),
        findsOneWidget);
  });

  test('mulaiLive tidak melakukan apa-apa tanpa Supabase', () {
    MarketService.mulaiLive();
    expect(MarketService.adaLive, isFalse);
  });

  test('persen tren hanya hilang untuk harga pasar nyata', () {
    final c = commodities.first;
    final simulasi = MarketService.changePct(c);
    expect(simulasi, isNot(0));

    // Baris 'basis-simulasi' bukan observasi pasar: angkanya simulasi yang
    // cuma lewat server, jadi persenya boleh tetap yang lama. Ini yang membuat
    // tabel boleh diisi penuh 69 komoditas tanpa membuat layar jadi datar.
    MarketService.live = {c.id: MarketService.simulatedNow(c)};
    MarketService.liveAsal = {
      c.id: HargaAsal('basis-simulasi', DateTime(2026, 10, 25))
    };
    expect(MarketService.changePct(c), simulasi);

    // Harga pasar nyata tidak punya pembanding "kemarin" di klien: datar,
    // bukan mengarang.
    MarketService.liveAsal[c.id] =
        HargaAsal('Pasar Induk Kediri', DateTime(2026, 10, 25));
    expect(MarketService.changePct(c), 0);
  });

  test('satu perubahan harga di Supabase langsung jadi kurva dua titik', () {
    final c = commodities.first;
    final tgl = DateTime(2026, 10, 25);
    HargaAsal asli(String sumber, int hari) =>
        HargaAsal(sumber, tgl.subtract(Duration(days: hari)));

    // Seed 69 baris: tabel terisi tapi belum ada yang diedit, jadi grafik
    // masih kurva simulasi 30 hari dan persen tetap yang lama.
    MarketService.live = {c.id: 21000};
    MarketService.liveAsal = {c.id: asli('Pasar Induk Kediri', 0)};
    expect(MarketService.history(c, 30).length, 30);
    expect(MarketService.seriCaption(c), contains('belum ada riwayat nyata'));

    // Harga lalu diubah 21000 -> 22000 pada dini hari ini: pemicu menyimpan
    // nilai LAMA, jadi baris arsip pagi ini berisi 21000 dan angka yang
    // berlaku sesudahnya adalah titik berikutnya.
    final now = DateTime.now();
    final kemarin = DateTime(now.year, now.month, now.day - 1, 1, 40);
    final pagiIni = DateTime(now.year, now.month, now.day, 1, 40);
    MarketService.live[c.id] = 22000;
    MarketService.liveSeri = {
      c.id: [
        HargaTitik(20000, kemarin),
        HargaTitik(21000, pagiIni),
        HargaTitik(22000, now),
      ]
    };
    expect(MarketService.seriTercatat(c), isNotNull);
    expect(MarketService.history(c, 30), [21000, 22000]);
    expect(MarketService.changePct(c), closeTo(100 / 21, 0.001));
    expect(MarketService.seriCaption(c), contains('harga tercatat'));
  });

  test('periode grafik memakai tanggal, bukan jumlah catatan', () {
    final c = commodities.first;
    final now = DateTime(2026, 10, 27, 15);
    MarketService.liveSeri = {
      c.id: [
        HargaTitik(19000, DateTime(2026, 10, 19)),
        HargaTitik(20000, DateTime(2026, 10, 21)),
        HargaTitik(21000, DateTime(2026, 10, 26)),
        HargaTitik(22000, DateTime(2026, 10, 27, 12)),
        HargaTitik(23000, now),
      ],
    };
    final week = MarketService.historyPoints(c, 7, now: now);
    expect(week.map((p) => p.harga),
        [21000, 21000, 21000, 21000, 21000, 22000, 23000]);
    // Tidak ada tanggal yang bolong: 21..27 Oktober masing-masing satu titik,
    // walau harga hanya berubah dua kali dalam periode itu.
    expect(week.map((p) => p.waktu.day), [21, 22, 23, 24, 25, 26, 27]);
    expect(MarketService.historyPoints(c, 30, now: now).length, 9);
  });

  test('beberapa edit dalam satu malam tidak mengarang persen harian', () {
    final c = commodities.first;
    final now = DateTime.now();
    final diniHari = DateTime(now.year, now.month, now.day, 1, 40);
    final kemarin = DateTime(now.year, now.month, now.day - 1);
    MarketService.live = {c.id: 51690};
    MarketService.liveAsal = {c.id: HargaAsal('Kemendag — SP2KP', kemarin)};
    // Pekerjaan harian menulis tiga kali berturut-turut pada 01:40; hanya
    // angka terakhir yang berlaku, jadi pembandingnya harga kemarin.
    MarketService.liveSeri = {
      c.id: [
        HargaTitik(52071, kemarin),
        HargaTitik(50550, diniHari),
        HargaTitik(41708, diniHari),
        HargaTitik(36303, diniHari),
        HargaTitik(51690, now),
      ]
    };
    final points = MarketService.historyPoints(c, 7, now: now);
    expect(points.last.harga, 51690);
    expect(points.first.harga, 50550);
    expect(MarketService.changePct(c),
        closeTo((51690 - 50550) / 50550 * 100, 0.001));
  });

  test('harga nyata tanpa arsip tidak mengarang riwayat', () {
    final c = commodities.first;
    MarketService.live = {c.id: 77000};
    final now = DateTime(2026, 10, 27);
    final points = MarketService.historyPoints(c, 7, now: now);
    expect(points.length, 1);
    expect(points.single.harga, 77000);
    expect(points.single.waktu, now);
  });

  test('caption jujur memisahkan catatan contoh dan harga pasar', () {
    final c = commodities.first;
    final tgl = DateTime(2026, 10, 25);
    MarketService.live = {c.id: 22000};
    MarketService.liveSeri = {
      c.id: [
        HargaTitik(20000, tgl.subtract(const Duration(days: 1))),
        HargaTitik(22000, tgl),
      ]
    };

    // Angka yang berlaku masih bawaan simulasi: kurva boleh digambar, tapi
    // keterangan tidak boleh menyamar jadi riwayat pasar.
    MarketService.liveAsal = {c.id: HargaAsal('basis-simulasi', tgl)};
    expect(MarketService.seriCaption(c), contains('masih contoh'));

    MarketService.liveAsal = {c.id: HargaAsal('Pasar Induk Kediri', tgl)};
    expect(MarketService.seriCaption(c), contains('harga tercatat'));
  });
}
