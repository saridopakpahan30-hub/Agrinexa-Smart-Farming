import 'package:agrinexa/data/fertilizers.dart';
import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/models/crop_guide.dart';
import 'package:agrinexa/services/fert_calc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('jumlah tanaman dari jarak tanam', () {
    test('jarak cm, m, dan biji per lubang', () {
      expect(plantsFromSpacing('60 × 50 cm', 1000), 3333);
      expect(plantsFromSpacing('2 × 2 m', 1000), 250);
      expect(plantsFromSpacing('40 × 30 cm (2 biji per lubang)', 1000), 16666);
      expect(plantsFromSpacing('100 × 25 cm (guludan)', 400), 1600);
    });

    test('pola yang tidak bisa dipercaya mengembalikan null', () {
      expect(plantsFromSpacing('20 × 15 cm atau sebar rata', 1000), isNull);
      expect(plantsFromSpacing('tanpa jarak tertentu', 1000), isNull);
      expect(plantsFromSpacing('60 cm', 1000), isNull);
      expect(plantsFromSpacing('60 × 50 cm', 0), isNull);
    });

    test('tanaman keras memakai kerapatan panduan', () {
      final kopi = commodityById('kopi');
      final g = guideFor('kopi')!;
      expect(g.trees, greaterThan(0));
      expect(plantCount(kopi, g, 10000), g.trees);
    });
  });

  group('dosis per batang', () {
    test('kilogram total dibagi ke jumlah tanaman', () {
      expect(gramsPerPlant(5, 1000), closeTo(5, 0.001));
      expect(gramsPerPlant(0.25, 500), closeTo(0.5, 0.001));
      expect(gramsPerPlant(5, 0), 0);
    });
  });

  group('pencocokan jenis pupuk', () {
    test('nama bebas pada panduan jatuh ke satu jenis', () {
      expect(kindFor('Urea')?.id, 'urea');
      expect(kindFor('NPK 16-16-16')?.id, 'npk');
      expect(kindFor('SP-36')?.id, 'sp36');
      expect(kindFor('KCl (MOP)')?.id, 'kcl');
      expect(kindFor('Dolomit')?.id, 'kapur');
      expect(kindFor('Boraks (boron)')?.id, 'boraks');
      expect(kindFor('cahaya bintang'), isNull);
    });

    test('setiap jenis punya gejala dua arah dan cara aplikasi', () {
      for (final k in fertKinds) {
        expect(k.deficiency.length, greaterThan(30), reason: k.id);
        expect(k.excess.length, greaterThan(30), reason: k.id);
        expect(k.method.length, greaterThan(30), reason: k.id);
        expect(k.phases, isNotEmpty, reason: k.id);
      }
    });
  });

  group('jadwal fase', () {
    test('umur 90 hari memberi rentang minggu yang naik', () {
      final g = guideFor('cabai')!;
      final w = fertSchedule(g, kindFor('Urea')!, 90);
      expect(w.length, 2);
      expect(w.first.fromWeek, greaterThanOrEqualTo(0));
      expect(w.last.toWeek, lessThanOrEqualTo(13));
      expect(w.last.toWeek, greaterThan(w.first.fromWeek));
    });

    test('pupuk dasar jatuh sebelum tanam', () {
      final g = guideFor('padi') ?? guideFor('cabai')!;
      final w = fertSchedule(g, kindFor('Kapur / dolomit')!, 90);
      expect(w.single.beforePlanting, isTrue);
    });
  });

  group('alasan kecocokan', () {
    test('menyebut hara, pH, dan panen tanaman itu', () {
      final c = commodityById('cabai');
      final g = guideFor('cabai')!;
      final alasan = fertAlasan(c: c, g: g, k: kindFor('Urea')!);
      final teks = alasan.map((a) => a.text).join(' ');
      expect(alasan.first.title, 'Hara yang Anda beli');
      expect(teks, contains('Nitrogen'));
      expect(teks, contains('pH'));
      expect(teks, contains(c.name));
    });

    test('kapur pada tanaman ber-pH netral diberi peringatan', () {
      final g = guideFor('cabai')!;
      expect(g.phMin, greaterThanOrEqualTo(5.5));
      final alasan =
          fertAlasan(c: commodityById('cabai'), g: g, k: kindFor('Dolomit')!);
      final ph = alasan.firstWhere((a) => a.title.contains('pH'));
      expect(ph.caution, isTrue);
    });

    test('bagian panen mengikuti kategori komoditas', () {
      expect(harvestedPart(commodityById('jahe')), contains('rimpang'));
      expect(harvestedPart(commodityById('padi')), contains('biji'));
    });
  });
}
