import 'dart:convert';

import 'package:agrinexa/core/format.dart';
import 'package:agrinexa/core/password.dart';
import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/services/recommendation.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('format', () {
    test('thousands memakai titik sebagai pemisah ribuan', () {
      expect(thousands(5000000), '5.000.000');
      expect(thousands(999), '999');
      expect(thousands(-1234567), '-1.234.567');
    });

    test('rp membuang pecahan dan menandai nilai negatif', () {
      expect(rp(1500.4), 'Rp 1.500');
      expect(rp(-2000), '-Rp 2.000');
    });

    test('parseInt toleratif terhadap format ribuan', () {
      expect(parseInt('5.000.000'), 5000000);
      expect(parseInt('abc'), 0);
    });

    test('pct dengan tanda plus untuk nilai positif', () {
      expect(pct(5, sign: true), '+5.0%');
      expect(pct(-5, sign: true), '-5.0%');
    });
  });

  group('Engine.evaluate', () {
    final cabai = commodityById('cabai');

    test('luas efektif dibatasi modal saat modal kecil', () {
      final r = Engine.evaluate(cabai,
          area: 100000, capital: 1000000, landType: 'Lahan Kering');
      expect(r.capitalLimited, isTrue);
      expect(r.effArea, lessThanOrEqualTo(100000));
      expect(r.effArea, closeTo(1000000 / cabai.costPerM2, 0.001));
    });

    test('margin = omzet - biaya dan konsisten dengan ROI', () {
      final r = Engine.evaluate(cabai,
          area: 1000, capital: 5000000, landType: 'Lahan Kering');
      expect(r.margin, closeTo(r.omzet - r.cost, 0.001));
      expect(r.roi, closeTo(r.margin / r.cost * 100, 0.001));
    });

    test('skenario harga naik menaikkan margin', () {
      final base = Engine.evaluate(cabai,
          area: 1000, capital: 5000000, landType: 'Lahan Kering');
      final naik = Engine.evaluate(cabai,
          area: 1000,
          capital: 5000000,
          landType: 'Lahan Kering',
          priceFactor: 1.2);
      expect(naik.margin, greaterThan(base.margin));
    });

    test('kecocokan lahan memengaruhi omzet', () {
      final padi = commodityById('padi');
      final sawah = Engine.evaluate(padi,
          area: 1000, capital: 100000000, landType: 'Lahan Sawah');
      final halaman = Engine.evaluate(padi,
          area: 1000, capital: 100000000, landType: 'Pekarangan');
      expect(sawah.suit, greaterThanOrEqualTo(halaman.suit));
    });
  });

  group('Engine.rank', () {
    test('mengurutkan skor dari tertinggi dan lengkap 69 komoditas', () {
      final list = Engine.rank(
          area: 1000,
          capital: 5000000,
          landType: 'Lahan Kering',
          goal: 'Keuntungan');
      expect(list.length, commodities.length);
      for (var i = 1; i < list.length; i++) {
        expect(list[i - 1].score, greaterThanOrEqualTo(list[i].score));
      }
    });

    test('goal Kestabilan memberi penalti berdasarkan volatilitas', () {
      final stabil = Engine.rank(
          area: 1000,
          capital: 5000000,
          landType: 'Lahan Kering',
          goal: 'Kestabilan');
      for (final r in stabil) {
        final expected =
            r.margin * (1 - r.c.volatility) * (1 - r.c.volatility);
        expect(r.score, closeTo(expected, 0.001));
      }
      // komoditas bergejolak (volatilitas tertinggi) skornya terdiskon
      final fluktuatif = stabil.firstWhere((r) => r.c.volatility >= 0.3);
      expect(fluktuatif.score, lessThan(fluktuatif.margin.abs()));
    });
  });

  group('kata sandi', () {
    test('hash baru cocok dengan dirinya sendiri, bukan dengan sandi lain', () {
      final simpan = Password.hash('rahasia123');
      expect(Password.verify('rahasia123', simpan), isTrue);
      expect(Password.verify('rahasia124', simpan), isFalse);
      expect(Password.perluUpgrade(simpan), isFalse);
    });

    test('salt membuat dua hash dari sandi sama berbeda', () {
      expect(Password.hash('x'), isNot(Password.hash('x')));
    });

    test('format lama SHA-256 tanpa salt masih bisa masuk lalu ditandai', () {
      final lama = sha256.convert(utf8.encode('rahasia123')).toString();
      expect(Password.verify('rahasia123', lama), isTrue);
      expect(Password.verify('salah', lama), isFalse);
      expect(Password.perluUpgrade(lama), isTrue);
    });
  });
}
