import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/screens/simulation_screen.dart';
import 'package:agrinexa/services/recommendation.dart';
import 'package:agrinexa/state/app_state.dart';

final _cabai = commodityById('cabai');
final _terong = commodityById('terong');

/// Modal besar supaya luas tidak dipotong — tes bisa fokus ke penjumlahan.
PlanResult _mixBebas(String id1, double a1, {String? id2, double a2 = 0}) =>
    Engine.mix([
      PlanLine(id1, a1),
      if (id2 != null) PlanLine(id2, a2),
    ], capital: 1 << 40, landType: 'Lahan Kering');

/// Urutan kolom angka pada layar Simulasi: 0 = luas lahan, 1 = modal,
/// selanjutnya luas tiap tanaman dalam rencana.
Finder kolom(int i) => find.byType(TextField).at(i);

void main() {
  test('satu tanaman memberi angka yang sama dengan evaluate lama', () {
    final lama = Engine.evaluate(_cabai,
        area: 300, capital: 1 << 40, landType: 'Lahan Kering');
    final baru = _mixBebas('cabai', 300);
    expect(baru.jumlahTanaman, 1);
    expect(baru.omzet, closeTo(lama.omzet, 1));
    expect(baru.cost, closeTo(lama.cost, 1));
    expect(baru.margin, closeTo(lama.margin, 1));
    expect(baru.requestedArea, 300);
  });

  test('banyak tanaman dijumlahkan, bukan dirata-ratakan', () {
    final r = _mixBebas('cabai', 300, id2: 'terong', a2: 200);
    expect(r.jumlahTanaman, 2);
    expect(
        r.cost, closeTo(300 * _cabai.costPerM2 + 200 * _terong.costPerM2, 1));
    expect(r.omzet, greaterThan(0));
    expect(r.margin, closeTo(r.omzet - r.cost, 1));
    expect(r.roi, closeTo(r.margin / r.cost * 100, 0.01));
    expect(r.requestedArea, 500);
    expect(r.usedArea, closeTo(500, 1));
    expect(r.capitalLimited, isFalse);
  });

  test('modal kurang memotong luas tiap tanaman dengan porsi yang sama', () {
    final butuh = 300 * _cabai.costPerM2 + 100 * _terong.costPerM2;
    final r = Engine.mix(
      [const PlanLine('cabai', 300), const PlanLine('terong', 100)],
      capital: (butuh / 2).round(),
      landType: 'Lahan Kering',
      landArea: 200,
    );
    expect(r.capitalLimited, isTrue);
    expect(r.landOver, isTrue);
    final cabai = r.items.firstWhere((e) => e.c.id == 'cabai');
    final terong = r.items.firstWhere((e) => e.c.id == 'terong');
    expect(cabai.effArea, closeTo(150, 1));
    expect(terong.effArea, closeTo(50, 1));
    expect(r.usedArea, closeTo(200, 1));
    // Porsi antar tanaman tidak berubah: 150 vs 50 tetap 3 : 1.
    expect(cabai.effArea / terong.effArea, closeTo(3, 0.05));
    expect(cabai.capitalLimited, isTrue);
  });

  test('baris berluas nol diabaikan, rencana kosong tidak bikin error', () {
    final r = Engine.mix(
      [const PlanLine('cabai', 0), const PlanLine('terong', 50)],
      capital: 5000000,
      landType: 'Lahan Kering',
    );
    expect(r.jumlahTanaman, 1);
    expect(r.requestedArea, 50);

    final kosong = Engine.mix([const PlanLine('cabai', 0)],
        capital: 5000000, landType: 'Lahan Kering');
    expect(kosong.kosong, isTrue);
    expect(kosong.margin, 0);
    expect(kosong.roi, 0);
    expect(kosong.capitalLimited, isFalse);
  });

  test('estimasi tahunan menjumlahkan siklus setiap tanaman', () {
    final res = _mixBebas('cabai', 300, id2: 'terong', a2: 200);
    final omzet =
        res.items.fold<double>(0, (t, r) => t + r.omzet * 365 / r.c.growDays);
    final cost =
        res.items.fold<double>(0, (t, r) => t + r.cost * 365 / r.c.growDays);
    expect(res.omzetSetahun, closeTo(omzet, 0.01));
    expect(res.biayaSetahun, closeTo(cost, 0.01));
    expect(res.marginSetahun, closeTo(omzet - cost, 0.01));
    expect(res.roiSetahun, closeTo((omzet - cost) / cost * 100, 0.01));
    final tree = Engine.evaluate(commodityById('durian'),
        area: 300, capital: 1 << 40, landType: 'Lahan Kering');
    expect(tree.siklusSetahun, 1);
    expect(tree.omzetSetahun, tree.omzet);
  });

  test('skenario harga berlaku untuk semua tanaman', () {
    final murah = Engine.mix(
      [const PlanLine('cabai', 300), const PlanLine('terong', 200)],
      capital: 1 << 40,
      landType: 'Lahan Kering',
      priceFactor: 0.7,
    );
    final penuh = Engine.mix(
      [const PlanLine('cabai', 300), const PlanLine('terong', 200)],
      capital: 1 << 40,
      landType: 'Lahan Kering',
    );
    expect(murah.omzet, closeTo(penuh.omzet * 0.7, 1));
    expect(murah.cost, closeTo(penuh.cost, 1));
    expect(murah.margin, lessThan(penuh.margin));
  });

  testWidgets('menjalankan simulasi tiga tanaman sekaligus', (tester) async {
    // Layar dibuat jauh lebih tinggi dari HP supaya SELURUH isi Simulasi
    // ter-build: ListView hanya membangun viewport + 250 px, dan tombol
    // Jalankan Simulasi + panel hasil ada di paling bawah. Kalau menambah
    // bagian baru di layar ini, angkanya ikut naik.
    tester.view.physicalSize = const Size(360, 4200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: SimulationScreen())));
    await tester.pumpAndSettle();

    // Dua tanaman dari chip paling kiri (pasti terlihat), selain baris awal.
    final tambahan = [
      for (final c in commodities.take(3))
        if (c.id != state.active.id) c
    ].take(2).toList();
    expect(tambahan.length, 2);
    for (final c in tambahan) {
      await tester.tap(find.text(c.name));
      await tester.pump();
    }
    expect(find.text('3 tanaman'), findsOneWidget);

    await tester.enterText(kolom(1), '500000000');
    for (var i = 0; i < tambahan.length; i++) {
      await tester.enterText(kolom(i + 2), '300');
    }
    await tester.tap(find.text('Jalankan Simulasi'));
    await tester.pumpAndSettle();

    expect(find.text('3 tanaman gabungan'), findsOneWidget);
    expect(find.text('Rincian per Tanaman'), findsOneWidget);
    expect(find.text('Peta Lahan'), findsOneWidget);
    expect(find.text('Rencana Anda'), findsOneWidget);
    expect(find.text('Luas direncanakan'), findsOneWidget);
    // Riwayat menyimpan satu catatan per tanaman.
    expect(state.history.length, 3);
    expect(find.text('Tiap tanaman tercatat otomatis di Riwayat Simulasi.'),
        findsOneWidget);
  });

  testWidgets('hasil tiga tanaman muat dengan teks diperbesar 1,3x',
      (tester) async {
    tester.view.physicalSize = const Size(360, 5200);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: SimulationScreen())));
    await tester.pumpAndSettle();

    final tambahan = [
      for (final c in commodities.take(3))
        if (c.id != state.active.id) c
    ].take(2).toList();
    for (final c in tambahan) {
      await tester.tap(find.text(c.name));
      await tester.pump();
    }
    await tester.enterText(kolom(1), '20000000');
    await tester.tap(find.text('Jalankan Simulasi'));
    await tester.pumpAndSettle();

    expect(find.text('3 tanaman gabungan'), findsOneWidget);
    expect(find.text('Perbandingan Margin Kotor'), findsOneWidget);
  });

  testWidgets('menghitung kombinasi terbaik lalu memakainya sebagai rencana',
      (tester) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: SimulationScreen())));
    await tester.pumpAndSettle();

    await tester.enterText(kolom(1), '500000000');
    await tester.pumpAndSettle();

    final optimal =
        tester.widget<Text>(find.textContaining('tanaman optimal')).data!;
    final jumlah = optimal.split(' ').first;
    expect(find.text('Pakai Rencana Ini'), findsOneWidget);
    expect(find.text('Batas yang paling menekan: lahan habis lebih dulu.'),
        findsOneWidget);
    // Luas lahan tercatat 1.000 m², jadi satu tanaman tak boleh mengambil
    // lebih dari batas porsinya.
    expect(int.parse(jumlah) >= 3, isTrue);

    await tester.ensureVisible(find.text('Pakai Rencana Ini'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pakai Rencana Ini'));
    await tester.pump();
    expect(find.text('$jumlah tanaman'), findsOneWidget);
    expect(state.history, isEmpty);
  });

  testWidgets('geser sakelar diversifikasi menghitung ulang kombinasi',
      (tester) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: SimulationScreen())));
    await tester.pumpAndSettle();

    int jumlahTanamanOptimal() => int.parse(tester
        .widget<Text>(find.textContaining('tanaman optimal'))
        .data!
        .split(' ')
        .first);

    await tester.enterText(kolom(1), '500000000');
    await tester.pumpAndSettle();
    final awal = jumlahTanamanOptimal();
    expect(find.text('35% lahan'), findsOneWidget);

    // Tarik sakelar pertama (diversifikasi) ke kiri sampai mentok 15%.
    final tengah = tester.getCenter(find.byType(Slider).first);
    await tester.dragFrom(tengah, const Offset(-160, 0));
    await tester.pumpAndSettle();

    expect(find.text('15% lahan'), findsOneWidget);
    // Tanpa menekan tombol apa pun, sarannya ikut berubah jadi lebih beragam.
    expect(jumlahTanamanOptimal(), greaterThan(awal));
  });

  testWidgets('mode kombinasi terbaik: user pilih tanaman, LP bagi luasnya',
      (tester) async {
    tester.view.physicalSize = const Size(360, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x"}}',
      'session': 't@x.id',
    });
    final state = AppState();
    await state.load();
    await tester.pumpWidget(AppScope(
        state: state, child: const MaterialApp(home: SimulationScreen())));
    await tester.pumpAndSettle();

    await tester.enterText(kolom(1), '500000000');
    await tester.pumpAndSettle();

    // Mode kustom: chip, kolom luas per tanaman, dan peta rencana manual.
    expect(find.text('Total direncanakan 1.000 m²'), findsOneWidget);
    expect(find.text('1 tanaman'), findsOneWidget);

    await tester.tap(find.text('Kombinasi terbaik'));
    await tester.pumpAndSettle();

    // Kolom luasnya hilang — user hanya memilih tanaman, sisanya LP.
    expect(find.text('Total direncanakan 1.000 m²'), findsNothing);
    expect(find.text('1 dipilih'), findsOneWidget);
    expect(find.text('Pilih semua'), findsOneWidget);
    expect(find.text('Kombinasi Terbaik — rencana Anda'), findsOneWidget);
    // Tidak ada tombol "Pakai Rencana Ini": rencana yang tampil memang LP-nya.
    expect(find.text('Pakai Rencana Ini'), findsNothing);

    // Satu tanaman dipilih: porsinya dilebarkan sampai 100% supaya tidak ada
    // lahan yang menganggur.
    expect(find.text('1 tanaman optimal'), findsOneWidget);
    expect(find.text('100% lahan'), findsOneWidget);
    expect(find.textContaining('Melebar jadi 100%'), findsOneWidget);

    // Chip yang sama juga dipakai mode ini, jadi bisa menambah tanaman.
    final tambahan = [
      for (final c in commodities.take(4))
        if (c.id != state.active.id) c
    ].take(2).toList();
    for (final c in tambahan) {
      await tester.tap(find.byKey(ValueKey('chip:${c.id}')));
      await tester.pumpAndSettle();
    }
    expect(find.text('3 dipilih'), findsOneWidget);
    // Tiga tanaman: 35% dari sakelar sudah cukup longgar (1/3 = 33%).
    expect(find.text('35% lahan'), findsOneWidget);
    expect(find.textContaining('Melebar jadi'), findsNothing);

    int jumlahOptimal() => int.parse(tester
        .widget<Text>(find.textContaining('tanaman optimal'))
        .data!
        .split(' ')
        .first);
    final jumlah = jumlahOptimal();
    expect(jumlah, inInclusiveRange(1, 3));
    // Tanaman di luar pilihan tidak boleh muncul di rencana.
    final ids = {state.active.id, ...tambahan.map((c) => c.id)};
    expect(find.textContaining('Rencana ini yang dihitung'), findsOneWidget);

    await tester.tap(find.text('Jalankan Simulasi'));
    await tester.pumpAndSettle();

    expect(find.text('$jumlah tanaman gabungan'), findsOneWidget);
    expect(find.text('Peta Lahan'), findsOneWidget);
    expect(state.history.every((r) => ids.contains(r.commodityId)), isTrue);
    // Riwayat tetap satu catatan per tanaman, meski bagiannya dihitung LP.
    expect(state.history.length, jumlah);

    // "Pilih semua" menyerahkan pemilihan tanaman kembali ke aplikasi.
    await tester.tap(find.text('Pilih semua'));
    await tester.pumpAndSettle();
    expect(find.text('${commodities.length} dipilih'), findsOneWidget);
    expect(jumlahOptimal(), greaterThanOrEqualTo(3));
    expect(ids.contains(state.active.id), isTrue);
  });
}
