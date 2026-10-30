import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/data/farm_backend.dart';
import 'package:agrinexa/data/farm_repository.dart';
import 'package:agrinexa/data/local_farm_repository.dart';
import 'package:agrinexa/data/syncing_farm_repository.dart';
import 'package:agrinexa/models/farm_settings.dart';

/// Server tiruan di memori: cukup untuk menguji aturan sinkronisasi tanpa
/// proyek Firebase, dan bisa disuruh "tidak ada koneksi" sesuka hati.
class Palsu implements FarmBackend {
  final Map<String, FarmSnapshot> server = {};
  final List<String> konflik = [];
  int jumlahBaca = 0;
  int jumlahTulis = 0;
  bool offline = false;

  /// Sama seperti Firestore: server tetap "tersedia" saat jaringan putus,
  /// yang gagal adalah permintaannya.
  @override
  bool get tersedia => true;

  void _jaring() {
    if (offline) throw Exception('Tidak ada koneksi internet.');
  }

  @override
  Future<FarmSnapshot?> baca(PemilikData pemilik) async {
    _jaring();
    jumlahBaca++;
    return server[pemilik.uid];
  }

  @override
  Future<void> tulis(PemilikData pemilik, FarmSnapshot snapshot) async {
    _jaring();
    jumlahTulis++;
    server[pemilik.uid] = snapshot;
  }

  @override
  Future<void> simpanKonflik(
    PemilikData pemilik,
    FarmSnapshot yangKalah,
    String penyebab,
  ) async {
    _jaring();
    konflik.add('${yangKalah.diubahMs}: $penyebab');
    server['${pemilik.uid}/konflik'] = yangKalah;
  }
}

FarmSnapshot kebun(int diubahMs, {int luas = 1200}) => FarmSnapshot(
      settings: FarmSettings(
        landArea: luas,
        landType: FarmSettings.jenisLahanBawaan,
      ),
      diubahMs: diubahMs,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const jeda = Duration(milliseconds: 10);
  const akun = PemilikData('a@x.id');
  const online = PemilikData('a@x.id', uid: 'u1');

  Future<LocalFarmRepository> bukaLokal(Map<String, Object> awal) async {
    SharedPreferences.setMockInitialValues(awal);
    return LocalFarmRepository(await SharedPreferences.getInstance());
  }

  Future<String?> blobLokal() async =>
      (await SharedPreferences.getInstance()).getString('data_a@x.id');

  /// Repository yang sudah "dibuka" seperti di aplikasi: pemiliknya tercatat.
  Future<(SyncingFarmRepository, Palsu)> pasang({
    Map<String, Object> awal = const {},
    FarmSnapshot? diServer,
    bool offline = false,
  }) async {
    final b = Palsu()..offline = offline;
    if (diServer != null) b.server['u1'] = diServer;
    final r = SyncingFarmRepository(
      lokal: await bukaLokal(awal),
      server: b,
      jeda: jeda,
    );
    return (r, b);
  }

  test('akun tanpa uid tidak pernah menyentuh server', () async {
    final (r, b) = await pasang();
    expect(await r.muat(akun), isNull);
    await r.simpan(akun, kebun(1000));
    expect(b.jumlahBaca, 0);
    expect(b.server, isEmpty);
    expect(r.menungguSinkron.value, false);
    await Future<void>.delayed(jeda * 4);
    expect(b.server, isEmpty);
  });

  test('perangkat baru mengambil kebun dari server dan menyimpannya lokal',
      () async {
    final (r, b) = await pasang(diServer: kebun(1000, luas: 2500));
    final s = (await r.muat(online))!;
    expect(s.settings.landArea, 2500);
    expect(b.jumlahTulis, 0, reason: 'menarik bukan berarti menulis ulang');
    expect(await blobLokal(), contains('"area":2500'));
  });

  test('data lokal yang lebih baru dikirim menimpa server', () async {
    final (r, b) = await pasang(
      awal: {'data_a@x.id': '{"area":900,"diubahMs":2000}'},
      diServer: kebun(1000, luas: 400),
    );
    final s = (await r.muat(online))!;
    expect(s.settings.landArea, 900);
    expect(b.server['u1']!.diubahMs, 2000);
    expect(b.konflik, isEmpty);
  });

  test('server yang lebih baru menang, versi lokal disalin dulu', () async {
    final (r, b) = await pasang(
      awal: {'data_a@x.id': '{"area":900,"diubahMs":1000}'},
      diServer: kebun(2000, luas: 400),
    );
    FarmSnapshot? ditarik;
    r.padaTarikUlang = (v) => ditarik = v;
    final s = (await r.muat(online))!;
    expect(s.settings.landArea, 400);
    expect(b.konflik.single, startsWith('1000:'));
    expect(b.server['u1/konflik']!.settings.landArea, 900);
    expect(await blobLokal(), contains('"area":400'));
    expect(ditarik, isNull, reason: 'muat sudah mengembalikan versinya');
  });

  test('perubahan lokal yang kalah saat dikirim memicu muat ulang', () async {
    final (r, b) = await pasang(diServer: kebun(2000, luas: 400));
    await r.muat(online);
    FarmSnapshot? ditarik;
    r.padaTarikUlang = (v) => ditarik = v;
    await r.simpan(online, kebun(1500, luas: 900));
    await Future<void>.delayed(jeda * 6);
    expect(ditarik?.settings.landArea, 400);
    expect(b.konflik.single, startsWith('1500:'));
    expect(b.server['u1/konflik']!.settings.landArea, 900);
    expect(r.menungguSinkron.value, false);
  });

  test('simpan berkali-kali hanya dikirim sekali', () async {
    final (r, b) = await pasang();
    await r.muat(online);
    for (final ms in [1000, 1100, 1200]) {
      await r.simpan(online, kebun(ms));
    }
    expect(r.menungguSinkron.value, true);
    await Future<void>.delayed(jeda * 6);
    expect(b.jumlahTulis, 1);
    expect(b.server['u1']!.diubahMs, 1200);
    expect(r.menungguSinkron.value, false);
  });

  test('tanpa internet data tetap tersimpan, lalu terkirim saat dicoba lagi',
      () async {
    final (r, b) = await pasang();
    await r.muat(online);
    b.offline = true;
    await r.simpan(online, kebun(1000, luas: 800));
    expect(await blobLokal(), contains('"area":800'));
    expect(r.menungguSinkron.value, true);
    await Future<void>.delayed(jeda * 6);
    expect(b.jumlahTulis, 0);
    expect(r.menungguSinkron.value, true, reason: 'masih mengantre');

    b.offline = false;
    await r.cobaSinkronLagi();
    expect(b.server['u1']!.diubahMs, 1000);
    expect(r.menungguSinkron.value, false);
  });

  test('server yang mati saat membuka aplikasi tidak menghapus data lokal',
      () async {
    final (r, b) = await pasang(
      awal: {'data_a@x.id': '{"area":900,"diubahMs":500}'},
      offline: true,
    );
    final s = (await r.muat(online))!;
    expect(s.settings.landArea, 900);
    expect(r.menungguSinkron.value, true);
    b.offline = false;
    await r.cobaSinkronLagi();
    expect(b.server['u1']!.diubahMs, 500);
  });
}
