import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrinexa/models/commodity.dart';
import 'package:agrinexa/services/lp.dart';
import 'package:agrinexa/services/recommendation.dart';
import 'package:agrinexa/widgets/plot_map.dart';

/// Cari DecoratedBox berwarna tertentu pada peta lahan.
Finder blok(Color warna) => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).color == warna);

void main() {
  group('solver program linear', () {
    test('menemukan optimum yang bisa dihitung tangan', () {
      // maks 3x + 5y, x+y<=10, x<=4, y<=6  ->  x=4, y=6, nilai 42
      final s = solveLinearMax(
        [3, 5],
        [
          [1, 1],
          [1, 0],
          [0, 1],
        ],
        [10, 4, 6],
      );
      expect(s, isNotNull);
      expect(s!.x[0], closeTo(4, 1e-6));
      expect(s.x[1], closeTo(6, 1e-6));
      expect(s.value, closeTo(42, 1e-6));
    });

    test('solusi tak terbatas dilaporkan, bukan angka palsu', () {
      // maks x tanpa batas atas: baris -x <= 0
      final s = solveLinearMax([1], [
        [-1]
      ], [0]);
      expect(s, isNull);
    });

    test('variabel bernilai nol tetap muncul di solusi', () {
      final s = solveLinearMax(
        [10, 1],
        [
          [1, 1],
          [1, 0],
        ],
        [5, 5],
      );
      expect(s!.x[1], closeTo(0, 1e-9));
      expect(s.x[0], closeTo(5, 1e-6));
    });
  });

  group('Engine.optimize', () {
    test('lahan luas + modal besar: lahan habis, hasilnya kombinasi', () {
      final sa = Engine.optimize(
          landArea: 1000, capital: 1 << 30, landType: 'Lahan Kering');
      expect(sa.hasil.kosong, isFalse);
      // 35% per tanaman berarti minimal 3 tanaman untuk mengisi 1.000 m².
      expect(sa.hasil.jumlahTanaman, greaterThanOrEqualTo(3));
      expect(sa.hasil.requestedArea, lessThanOrEqualTo(1001));
      expect(sa.hasil.requestedArea, greaterThan(990));
      expect(sa.pembatas, contains('lahan habis'));
      expect(sa.hasil.capitalLimited, isFalse);
    });

    test('margin saran tidak pernah kalah dari satu tanaman saja', () {
      final sa = Engine.optimize(
          landArea: 1000, capital: 1 << 30, landType: 'Lahan Kering');
      // Bandingkan dengan rencana terbaik yang memakai satu tanaman sebanyak
      // batas maksimumnya: optimasi harus setidaknya sama baik.
      var terbaik = 0.0;
      for (final c in commodities) {
        final satu = Engine.mix([PlanLine(c.id, 350)],
            capital: 1 << 30, landType: 'Lahan Kering', landArea: 1000);
        if (satu.margin > terbaik) terbaik = satu.margin;
      }
      expect(sa.hasil.margin, greaterThanOrEqualTo(terbaik));
    });

    test('nilai fungsi tujuan sesuai margin yang dihitung ulang', () {
      final sa = Engine.optimize(
          landArea: 1200, capital: 1 << 30, landType: 'Lahan Kering');
      // Selisih hanya berasal dari potongan <1 m² yang dibuang, jadi kecil.
      expect(sa.hasil.margin, greaterThan(sa.nilai * 0.95));
      expect(sa.hasil.margin, lessThanOrEqualTo(sa.nilai + 1));
    });

    test('modal kecil membatasi luas, bukan lahannya', () {
      final sa = Engine.optimize(
          landArea: 100000, capital: 2000000, landType: 'Lahan Kering');
      expect(sa.hasil.cost, lessThanOrEqualTo(2000001));
      expect(sa.hasil.requestedArea, lessThan(100000));
      expect(sa.pembatas, contains('modal habis'));
    });

    test('harga jatuh 30 persen tetap menghasilkan rencana sah', () {
      final sa = Engine.optimize(
          landArea: 800,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          priceFactor: 0.7);
      expect(sa.hasil.requestedArea, lessThanOrEqualTo(801));
      for (final r in sa.hasil.items) {
        expect(r.margin, greaterThan(0));
      }
    });

    test('goal Kestabilan menimbang harga yang fluktuatif', () {
      final untung = Engine.optimize(
          landArea: 1000, capital: 1 << 30, landType: 'Lahan Kering');
      final stabil = Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          goal: 'Kestabilan');
      final volUntung = untung.hasil.items.fold<double>(
          0, (t, r) => t + r.c.volatility * r.effArea);
      final volStabil = stabil.hasil.items.fold<double>(
          0, (t, r) => t + r.c.volatility * r.effArea);
      expect(stabil.hasil.jumlahTanaman, greaterThanOrEqualTo(2));
      // Kombinasi "kestabilan" boleh sama atau lebih tenang, tetapi tidak
      // boleh lebih berisiko daripada kombinasi "keuntungan".
      expect(volStabil, lessThanOrEqualTo(volUntung));

      // Bobot kestabilan harus benar-benar memihak tanaman yang tenang:
      // nilai cabai (vol 0,35) turun, dan kangkung (vol 0,15) menyalipnya.
      const lt = 'Lahan Kering';
      final cabai = commodityById('cabai');
      final kangkung = commodityById('kangkung');
      expect(
          Engine.marginPerM2(cabai, landType: lt, goal: 'Kestabilan'),
          lessThan(Engine.marginPerM2(cabai, landType: lt)));
      expect(
          Engine.marginPerM2(kangkung, landType: lt, goal: 'Kestabilan'),
          greaterThan(
              Engine.marginPerM2(cabai, landType: lt, goal: 'Kestabilan')));
    });

    test('lahan nol tidak bikin solver error', () {
      final sa =
          Engine.optimize(landArea: 0, capital: 5000000, landType: 'Lahan Kering');
      expect(sa.hasil.kosong, isTrue);
    });

    test('sakelar diversifikasi: batas ketat = banyak tanaman, margin tidak turun',
        () {
      PlanResult cari(double share) => Engine.optimize(
              landArea: 1000,
              capital: 1 << 30,
              landType: 'Lahan Kering',
              maxShare: share)
          .hasil;
      final ketat = cari(0.15);
      final longgar = cari(0.6);
      expect(ketat.jumlahTanaman, greaterThan(longgar.jumlahTanaman));
      for (final r in ketat.items) {
        // 15% dari 1.000 m² = 150 m², tidak ada yang boleh lewat.
        expect(r.effArea, lessThanOrEqualTo(151));
      }
      // Melonggarkan batas memperluas daerah yang boleh dipilih, jadi optimum
      // tidak mungkin turun.
      expect(longgar.margin, greaterThanOrEqualTo(ketat.margin - 1));
      expect(ketat.margin, greaterThan(0));
    });

    test('hanya tanaman pilihan user yang dibagi, luasnya tetap dari LP', () {
      final untung = [
        for (final c in commodities)
          if (Engine.marginPerM2(c, landType: 'Lahan Kering') > 0) c.id
      ];
      final tiga = untung.take(3).toList();
      final sa = Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          hanya: tiga);
      expect(sa.hasil.jumlahTanaman, lessThanOrEqualTo(3));
      for (final r in sa.hasil.items) {
        expect(tiga, contains(r.c.id));
        // Tiga tanaman = 33% per tanaman, jadi sakelar 35% yang berlaku.
        expect(r.effArea, lessThanOrEqualTo(351));
      }
      expect(sa.maxShare, closeTo(0.35, 1e-9));
      expect(sa.hasil.requestedArea, greaterThan(990));
    });

    test('pilihan sedikit melebarkan batas porsi, lahan tetap penuh', () {
      final untung = [
        for (final c in commodities)
          if (Engine.marginPerM2(c, landType: 'Lahan Kering') > 0) c.id
      ];
      final dua = Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          hanya: untung.take(2).toList());
      // Dua tanaman: 35% tidak cukup untuk mengisi lahan, batasnya jadi 50%.
      expect(dua.maxShare, closeTo(0.5, 1e-9));
      expect(dua.hasil.jumlahTanaman, 2);
      expect(dua.hasil.requestedArea, closeTo(1000, 1));

      final satu = Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          hanya: [untung.first]);
      expect(satu.maxShare, closeTo(1.0, 1e-9));
      expect(satu.hasil.items.single.c.id, untung.first);
      expect(satu.hasil.requestedArea, closeTo(1000, 1));
    });

    test('slider batas porsi mengubah pembagian tanaman pilihan', () {
      final untung = [
        for (final c in commodities)
          if (Engine.marginPerM2(c, landType: 'Lahan Kering') > 0) c.id
      ];
      final empat = untung.take(4).toList();
      Saran jalan(double share) => Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          maxShare: share,
          hanya: empat);
      double terbesar(Saran s) =>
          s.hasil.items.map((r) => r.effArea).reduce((a, b) => a > b ? a : b);

      final rata = jalan(0.25);
      final lebar = jalan(0.6);
      expect(terbesar(rata), closeTo(250, 1));
      expect(terbesar(lebar), closeTo(600, 1));
      expect(lebar.hasil.jumlahTanaman, 4);
      for (final r in lebar.hasil.items) {
        expect(r.effArea, greaterThan(130));
      }
      expect(lebar.hasil.requestedArea, closeTo(1000, 1));
      expect(lebar.hasil.margin, greaterThan(rata.hasil.margin));
    });

    test('pilihan yang tidak menguntungkan menghasilkan rencana kosong', () {
      final sa = Engine.optimize(
          landArea: 1000,
          capital: 1 << 30,
          landType: 'Lahan Kering',
          hanya: ['tidak-ada']);
      expect(sa.hasil.kosong, isTrue);
      expect(sa.pembatas, contains('tanaman pilihan Anda'));
    });
  });

  group('peta lahan', () {
    testWidgets('luas satu warna mewakili luas tanamannya', (tester) async {
      const hijau = Color(0xFF2E7D32);
      const merah = Color(0xFFD64545);
      const kuning = Color(0xFFFFB300);
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: PlotMap(zones: [
                PlotZone(name: 'Jagung', area: 400, color: kuning, emoji: '🌽'),
                PlotZone(name: 'Terong', area: 200, color: hijau, emoji: '🍆'),
                PlotZone(name: 'Cabai', area: 200, color: merah, emoji: '🌶️'),
              ], height: 200, radius: 0),
            ),
          ),
        ),
      ));

      final besar = tester.getSize(blok(kuning));
      final a = tester.getSize(blok(hijau));
      final b = tester.getSize(blok(merah));
      // 400 : 200 : 200 harus terlihat sebagai 2 : 1 : 1.
      expect(besar.width * besar.height / (a.width * a.height),
          closeTo(2, 0.25));
      expect(a.width * a.height, closeTo(b.width * b.height, 1));
    });

    testWidgets('teks nama memakai warna yang kontras', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 200,
            child: PlotMap(
                zones: [
                  PlotZone(
                      name: 'Kentang', area: 320, color: Color(0xFFF3E9C6)),
                ],
                height: 200,
                radius: 0),
          ),
        ),
      ));
      final teks = tester.widget<Text>(find.textContaining('Kentang').first);
      expect(teks.style!.color, const Color(0xFF16281C));
    });

    testWidgets('zona berluas nol tidak digambar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 180,
            child: PlotMap(zones: [
              PlotZone(name: 'Kosong', area: 0, color: Colors.red),
            ], height: 180),
          ),
        ),
      ));
      expect(find.byType(PlotMap), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.text('Kosong 0%'), findsNothing);
    });

    testWidgets('legenda menampilkan porsi tiap tanaman', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 120,
            child: PlotLegend(zones: [
              PlotZone(name: 'Jagung', area: 300, color: Colors.orange),
              PlotZone(name: 'Terong', area: 200, color: Colors.green),
              PlotZone(name: 'Cabai', area: 100, color: Colors.red),
            ]),
          ),
        ),
      ));
      expect(find.text('Jagung 50%'), findsOneWidget);
      expect(find.text('Terong 33%'), findsOneWidget);
      expect(find.text('Cabai 17%'), findsOneWidget);
    });
  });
}
