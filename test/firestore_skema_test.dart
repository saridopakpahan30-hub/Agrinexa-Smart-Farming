import 'package:flutter_test/flutter_test.dart';

import 'package:agrinexa/data/farm_repository.dart';
import 'package:agrinexa/data/firestore_skema.dart';
import 'package:agrinexa/models/farm_activity.dart';
import 'package:agrinexa/models/farm_settings.dart';
import 'package:agrinexa/models/ledger.dart';
import 'package:agrinexa/models/optimization_run.dart';
import 'package:agrinexa/models/planting.dart';
import 'package:agrinexa/models/plot.dart';
import 'package:agrinexa/models/sim_record.dart';

/// Snapshot berisi satu baris di setiap koleksi.
FarmSnapshot lengkap() => FarmSnapshot(
      settings: FarmSettings(
        landArea: 1200,
        capital: 3000000,
        landType: 'Lahan Kering',
        goal: 'Risiko rendah',
        activeId: 'tomat',
        hasInput: true,
        notifOn: false,
        farmLat: -6.9,
        farmLon: 107.6,
        farmCity: 'Bandung',
        locationChosen: true,
        manualPrices: const {'tomat': 9000},
        manualPricesPrev: const {'tomat': 8000},
      ),
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

void main() {
  test('dokumen inti dan semua koleksi pulang-pergi utuh', () {
    final s = lengkap();
    final balik = snapshotDariDokumen(petaInti(s), petaKoleksi(s));
    expect(balik.diubahMs, 1770003000000);
    expect(balik.settings.landArea, 1200);
    expect(balik.settings.capital, 3000000);
    expect(balik.settings.landType, 'Lahan Kering');
    expect(balik.settings.goal, 'Risiko rendah');
    expect(balik.settings.activeId, 'tomat');
    expect(balik.settings.notifOn, false);
    expect(balik.settings.farmCity, 'Bandung');
    expect(balik.settings.manualPrices['tomat'], 9000);
    expect(balik.settings.manualPricesPrev['tomat'], 8000);
    expect(balik.jumlahData, s.jumlahData);
    expect(balik.history.single.priceFactor, 1.1);
    expect(balik.ledger.single.income, true);
    expect(balik.plantings.single.done, [2]);
    expect(balik.plots.single.note, 'dekat sumber air');
    expect(balik.activities.single.severity, 3);
    expect(balik.optimizations.single.parts.single.margin, 2400000);
  });

  test('nama kolom memakai bahasa Indonesia, sesuai struktur di konsol', () {
    final inti = petaInti(lengkap());
    expect(inti['pengaturan'], isA<Map>());
    expect((inti['pengaturan'] as Map)['luasLahanM2'], 1200);
    expect((inti['lokasi'] as Map)['kota'], 'Bandung');
    expect(inti['hargaCatatan'], {'tomat': 9000});
  });

  test('id dokumen diambil dari id baris, bukan dibuat baru', () {
    final k = petaKoleksi(lengkap());
    expect(k[SkemaKebun.kebun]!.keys.single, 'pt1');
    expect(k[SkemaKebun.penanaman]!.keys.single, 'p1');
    expect(k[SkemaKebun.keuangan]!.keys.single, 'l1');
    expect(k[SkemaKebun.aktivitas]!.keys.single, 'a1');
    expect(k[SkemaKebun.riwayatOptimasi]!.keys.single, 'o1');
    expect(k[SkemaKebun.riwayatSimulasi]!.keys.single,
        lengkap().history.single.kunci);
    expect(k.keys.toList(), SkemaKebun.daftarKoleksi);
  });

  test('dokumen dari versi lama tanpa koleksi lain tetap terbaca', () {
    final balik = snapshotDariDokumen({
      'pengaturan': {'luasLahanM2': 800}
    }, {});
    expect(balik.settings.landArea, 800);
    expect(balik.settings.capital, 5000000);
    expect(balik.settings.notifOn, true);
    expect(balik.settings.farmCity, '');
    expect(balik.jumlahData, 0);
    expect(balik.diubahMs, 0);
  });

  test('versi yang kalah disimpan lengkap beserta barisnya', () {
    final c = petaKonflik(lengkap(), 'perangkat lain lebih baru');
    expect(c['penyebab'], 'perangkat lain lebih baru');
    expect(c['jumlahData'], lengkap().jumlahData);
    final isi = c['isi'] as Map;
    expect(isi.length, SkemaKebun.daftarKoleksi.length);
    expect((isi[SkemaKebun.kebun] as List).single, isA<Map>());
    expect((isi[SkemaKebun.riwayatSimulasi] as List).single,
        isA<Map<String, Object?>>());
  });
}
