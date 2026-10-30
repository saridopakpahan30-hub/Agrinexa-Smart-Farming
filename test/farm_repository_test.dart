import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrinexa/data/farm_repository.dart';
import 'package:agrinexa/data/local_farm_repository.dart';
import 'package:agrinexa/models/farm_activity.dart';
import 'package:agrinexa/models/farm_settings.dart';
import 'package:agrinexa/models/ledger.dart';
import 'package:agrinexa/models/optimization_run.dart';
import 'package:agrinexa/models/planting.dart';
import 'package:agrinexa/models/plot.dart';
import 'package:agrinexa/state/app_state.dart';

/// Blob persis seperti yang ditulis aplikasi sebelum ada lapisan repository.
const blobLama = '''
{
  "area": 2500,
  "capital": 7500000,
  "landType": "Pekarangan",
  "goal": "Risiko rendah",
  "active": "kubis",
  "hasInput": true,
  "notifOn": false,
  "priceAlert": false,
  "history": [
    {"c":"kubis","d":"2026-01-05","a":300.0,"k":1000000,"o":2000000.0,
     "b":900000.0,"m":1100000.0,"r":122.2,"p":1.0}
  ],
  "ledger": [
    {"id":"l1","t":1767225600000,"i":false,"c":"Pupuk","a":250000,
     "n":"Urea 1 sak","k":"kubis"}
  ],
  "plantings": [
    {"id":"p1","c":"kubis","t":1767225600000,"d":[0,1]}
  ],
  "lat": -6.9,
  "lon": 107.6,
  "city": "Bandung",
  "locSet": true,
  "manualPrices": {"kubis": 6500.0},
  "manualPricesPrev": {"kubis": 6000.0}
}
''';

void main() {
  const punya = PemilikData('t@x.id');

  Future<LocalFarmRepository> repo(Map<String, Object> awal) async {
    SharedPreferences.setMockInitialValues(awal);
    return LocalFarmRepository(await SharedPreferences.getInstance());
  }

  test('blob lama terbaca utuh tanpa migrasi', () async {
    final r = await repo({'data_t@x.id': blobLama});
    final s = (await r.muat(punya))!;
    expect(s.settings.landArea, 2500);
    expect(s.settings.capital, 7500000);
    expect(s.settings.landType, 'Pekarangan');
    expect(s.settings.goal, 'Risiko rendah');
    expect(s.settings.activeId, 'kubis');
    expect(s.settings.hasInput, true);
    expect(s.settings.notifOn, false);
    expect(s.settings.priceAlert, false);
    expect(s.settings.farmCity, 'Bandung');
    expect(s.settings.manualPrices['kubis'], 6500);
    expect(s.history.single.commodityId, 'kubis');
    expect(s.ledger.single.amount, 250000);
    expect(s.plantings.single.done, [0, 1]);
    expect(s.plots, isEmpty);
    expect(s.activities, isEmpty);
    expect(s.optimizations, isEmpty);
  });

  test('lokasi yang belum dipilih tidak menyimpan kota', () async {
    final m = jsonDecode(blobLama) as Map<String, dynamic>;
    m['locSet'] = false;
    final r = await repo({'data_t@x.id': jsonEncode(m)});
    final s = (await r.muat(punya))!;
    expect(s.settings.locationChosen, false);
    expect(s.settings.farmCity, '');
  });

  test('blob rusak tidak membuat aplikasi mati', () async {
    final r = await repo({'data_t@x.id': '{"area":'});
    expect(await r.muat(punya), isNull);
  });

  test('akun yang belum pernah menyimpan data menghasilkan null', () async {
    final r = await repo({'accounts': '{}'});
    expect(await r.muat(const PemilikData('baru@x.id')), isNull);
  });

  test('snapshot dengan plot, aktivitas, dan optimasi pulang-pergi utuh',
      () async {
    final r = await repo({});
    final aslinya = FarmSnapshot(
      settings: FarmSettings(
          landArea: 1200, capital: 3000000, landType: 'Lahan Kering'),
      history: [
        const SimRecord(
            commodityId: 'tomat',
            date: '2026-02-01',
            area: 120,
            capital: 3000000,
            omzet: 4000000,
            cost: 1500000,
            margin: 2500000,
            roi: 166.7,
            priceFactor: 1.1)
      ],
      ledger: [
        const LedgerEntry(
            id: 'l1',
            timeMs: 1770000000000,
            income: true,
            category: 'Panen',
            amount: 900000,
            note: 'tomat kali pertama',
            commodityId: 'tomat')
      ],
      plantings: [
        const Planting(
            id: 'p1', commodityId: 'tomat', startMs: 1770000000000, done: [2])
      ],
      plots: [
        const Plot(
            id: 'pt1',
            name: 'Petak A',
            areaM2: 400,
            landType: 'Lahan Kering',
            commodityId: 'tomat',
            order: 1,
            note: 'dekat sumber air',
            updatedMs: 1770000900000)
      ],
      activities: [
        const FarmActivity(
            id: 'a1',
            kind: 'hama',
            title: 'Kutu putih di Petak A',
            detail: 'Serang daun muda',
            plotId: 'pt1',
            commodityId: 'tomat',
            severity: 3,
            occurredMs: 1770001000000,
            updatedMs: 1770001000000)
      ],
      optimizations: [
        const OptimizationRun(
            id: 'o1',
            createdMs: 1770002000000,
            landArea: 1200,
            capital: 3000000,
            landType: 'Lahan Kering',
            goal: 'Keuntungan',
            pembatas: 'Modal',
            nilai: 2400000,
            requestedArea: 1000,
            usedArea: 900,
            capitalLimited: true,
            parts: [
              OptimizationPart(
                  commodityId: 'tomat',
                  areaM2: 900,
                  omzet: 4000000,
                  cost: 1600000)
            ],
            updatedMs: 1770002000000)
      ],
      diubahMs: 1770003000000,
    );
    await r.simpan(punya, aslinya);

    final bacanya = (await r.muat(punya))!;
    expect(bacanya.diubahMs, 1770003000000);
    expect(bacanya.settings.landArea, 1200);
    expect(bacanya.jumlahData, aslinya.jumlahData);
    // kunci riwayat harus sama sebelum dan sesudah disimpan: Firestore
    // memakainya sebagai id dokumen, jadi baris tidak boleh berpindah
    expect(bacanya.history.single.kunci, aslinya.history.single.kunci);
    expect(bacanya.plots.single.name, 'Petak A');
    expect(bacanya.plots.single.note, 'dekat sumber air');
    expect(bacanya.activities.single.severity, 3);
    expect(bacanya.activities.single.plotId, 'pt1');
    expect(bacanya.optimizations.single.pembatas, 'Modal');
    expect(bacanya.optimizations.single.capitalLimited, true);
    expect(bacanya.optimizations.single.parts.single.margin, 2400000);
  });

  test('tulis lalu baca memakai nama kunci warisan yang sama', () async {
    final r = await repo({});
    await r.simpan(
        punya,
        FarmSnapshot(
            settings: FarmSettings(landType: FarmSettings.jenisLahanBawaan)));
    final mentah = jsonDecode(
            (await SharedPreferences.getInstance()).getString('data_t@x.id')!)
        as Map<String, dynamic>;
    for (final kunci in [
      'area',
      'capital',
      'landType',
      'goal',
      'active',
      'hasInput',
      'notifOn',
      'priceAlert',
      'history',
      'ledger',
      'plantings',
      'lat',
      'lon',
      'city',
      'locSet',
      'manualPrices',
      'manualPricesPrev'
    ]) {
      expect(mentah.containsKey(kunci), true, reason: '$kunci harus tetap ada');
    }
    expect(mentah['plots'], isA<List>());
  });

  testWidgets('AppState hanya bicara dengan repository, datanya tetap selamat',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'accounts': '{"t@x.id":{"name":"T","pass":"x","emoji":""}}',
      'session': 't@x.id',
      'data_t@x.id': blobLama,
    });
    final state = AppState();
    await state.load();
    expect(state.loggedIn, true);
    expect(state.landArea, 2500);
    expect(state.landType, 'Pekarangan');
    expect(state.farmCity, 'Bandung');
    expect(state.ledger.single.category, 'Pupuk');
    expect(state.plantings.single.done, [0, 1]);
    expect(state.plots, isEmpty);
    expect(state.activities, isEmpty);
    expect(state.optimizations, isEmpty);

    await state.setManualPrice('kubis', 7000);
    expect(state.manualPrices['kubis'], 7000);
    expect(state.manualPricesPrev['kubis'], 6500);

    final dibukaLagi = AppState();
    await dibukaLagi.load();
    expect(dibukaLagi.landArea, 2500);
    expect(dibukaLagi.manualPrices['kubis'], 7000);
    expect(dibukaLagi.ledger.single.note, 'Urea 1 sak');
    expect(dibukaLagi.history.single.roi, closeTo(122.2, 0.01));
  });
}
