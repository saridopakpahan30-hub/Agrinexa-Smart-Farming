import 'dart:math' as math;

import '../core/i18n.dart';
import '../models/commodity.dart';
import 'lp.dart';
import 'market_service.dart';

class Reco {
  final Commodity c;
  final double effArea; // luas yang mampu dibiayai (m2)
  final double omzet, cost, margin, roi, score, price, suit, fullCost;
  final bool capitalLimited;

  const Reco({
    required this.c,
    required this.effArea,
    required this.omzet,
    required this.cost,
    required this.margin,
    required this.roi,
    required this.score,
    required this.price,
    required this.suit,
    required this.fullCost,
    required this.capitalLimited,
  });

  double get marginPerM2 => effArea > 0 ? margin / effArea : 0;

  // Tanaman tahunan menggunakan hasil per tahun produktif, bukan umur hingga
  // panen pertama.
  double get siklusSetahun => c.growDays >= 365 ? 1 : 365 / c.growDays;
  double get omzetSetahun => omzet * siklusSetahun;
  double get biayaSetahun => cost * siklusSetahun;
  double get marginSetahun => omzetSetahun - biayaSetahun;
}

/// Satu baris rencana tanam: komoditas beserta luas yang diinginkan (m²).
class PlanLine {
  final String commodityId;
  final double area;
  const PlanLine(this.commodityId, this.area);

  Commodity get c => commodityById(commodityId);
}

/// Gabungan beberapa tanaman; modal yang sama digunakan bersama.
class PlanResult {
  final List<Reco> items;
  final double omzet, cost, margin, roi;
  final double requestedArea; // luas yang direncanakan
  final double usedArea; // luas yang benar-benar terbiayai
  final bool capitalLimited;
  final bool landOver; // rencana melebihi luas lahan yang tercatat

  const PlanResult({
    required this.items,
    required this.omzet,
    required this.cost,
    required this.margin,
    required this.roi,
    required this.requestedArea,
    required this.usedArea,
    required this.capitalLimited,
    required this.landOver,
  });

  bool get kosong => items.isEmpty;
  int get jumlahTanaman => items.length;
  double get omzetSetahun => items.fold(0, (t, r) => t + r.omzetSetahun);
  double get biayaSetahun => items.fold(0, (t, r) => t + r.biayaSetahun);
  double get marginSetahun => omzetSetahun - biayaSetahun;
  double get roiSetahun =>
      biayaSetahun > 0 ? marginSetahun / biayaSetahun * 100 : 0;
}

/// Kombinasi hasil optimasi program linear.
class Saran {
  final PlanResult hasil;

  /// Sumber daya yang lebih dahulu habis — penjelasan mengapa bentuk hasilnya
  /// demikian.
  final String pembatas;

  /// Nilai fungsi tujuan pada solusi optimum.
  final double nilai;

  /// Batas porsi satu tanaman yang digunakan saat optimasi (fraksi dari lahan).
  final double maxShare;

  const Saran(
      {required this.hasil,
      required this.pembatas,
      required this.nilai,
      this.maxShare = 0.35});
}

class Pro {
  final bool ok;
  final String text;
  const Pro(this.ok, this.text);
}

class Engine {
  /// Rumus tunggal untuk satu tanaman pada satu luas. [evaluate] dan [mix]
  /// menggunakan fungsi ini agar angka satu tanaman dan angka gabungan tidak
  /// berbeda.
  static Reco _project(
    Commodity c,
    double eff,
    double requested, {
    required String landType,
    required double priceFactor,
    required String goal,
    required bool limited,
  }) {
    final price = MarketService.current(c) * priceFactor;
    final suit = c.suitability[landType] ?? 0.9;
    final omzet = eff * c.yieldPerM2 * suit * price;
    final cost = eff * c.costPerM2;
    final margin = omzet - cost;
    final roi = cost == 0 ? 0.0 : margin / cost * 100;
    final stability = 1 - c.volatility;
    final score = goal == 'Kestabilan'
        ? margin * math.pow(stability, 2).toDouble()
        : margin;
    return Reco(
      c: c,
      effArea: eff,
      omzet: omzet,
      cost: cost,
      margin: margin,
      roi: roi,
      score: score,
      price: price,
      suit: suit,
      fullCost: requested * c.costPerM2,
      capitalLimited: limited,
    );
  }

  /// Hitung proyeksi untuk satu komoditas.
  /// Luas efektif dibatasi modal: min(luas lahan, modal / biaya per m²).
  static Reco evaluate(
    Commodity c, {
    required int area,
    required int capital,
    required String landType,
    String goal = 'Keuntungan',
    double priceFactor = 1.0,
  }) {
    final maxArea = capital / c.costPerM2;
    return _project(c, math.min(area.toDouble(), maxArea), area.toDouble(),
        landType: landType,
        priceFactor: priceFactor,
        goal: goal,
        limited: maxArea < area);
  }

  /// Simulasi gabungan dengan jumlah tanaman bebas. Modal dihitung untuk seluruh
  /// rencana sekaligus; bila tidak mencukupi, luas setiap tanaman dipangkas
  /// dengan porsi yang sama agar rencana tetap menggambarkan satu modal.
  static PlanResult mix(
    List<PlanLine> lines, {
    required int capital,
    required String landType,
    String goal = 'Keuntungan',
    double priceFactor = 1.0,
    int? landArea,
  }) {
    final diminta = [
      for (final l in lines)
        if (l.area >= 1) l
    ];
    if (diminta.isEmpty) {
      return const PlanResult(
        items: [],
        omzet: 0,
        cost: 0,
        margin: 0,
        roi: 0,
        requestedArea: 0,
        usedArea: 0,
        capitalLimited: false,
        landOver: false,
      );
    }
    final butuh = diminta.fold<double>(0, (t, l) => t + l.area * l.c.costPerM2);
    final skala = (capital > 0 && butuh > capital) ? capital / butuh : 1.0;
    final items = [
      for (final l in diminta)
        _project(l.c, l.area * skala, l.area,
            landType: landType,
            priceFactor: priceFactor,
            goal: goal,
            limited: skala < 1)
    ];
    final omzet = items.fold<double>(0, (t, r) => t + r.omzet);
    final cost = items.fold<double>(0, (t, r) => t + r.cost);
    final requested = diminta.fold<double>(0, (t, l) => t + l.area);
    final used = items.fold<double>(0, (t, r) => t + r.effArea);
    final margin = omzet - cost;
    return PlanResult(
      items: items,
      omzet: omzet,
      cost: cost,
      margin: margin,
      roi: cost == 0 ? 0.0 : margin / cost * 100,
      requestedArea: requested,
      usedArea: used,
      capitalLimited: skala < 1,
      landOver: landArea != null && requested > landArea,
    );
  }

  /// Margin per m² — koefisien tujuan pada optimasi kombinasi.
  static double marginPerM2(
    Commodity c, {
    required String landType,
    double priceFactor = 1.0,
    String goal = 'Keuntungan',
  }) {
    final price = MarketService.current(c) * priceFactor;
    final suit = c.suitability[landType] ?? 0.9;
    final m = c.yieldPerM2 * suit * price - c.costPerM2;
    return goal == 'Kestabilan'
        ? m * math.pow(1 - c.volatility, 2).toDouble()
        : m;
  }

  /// Cari kombinasi dan luas terbaik dengan program linear: memaksimumkan total
  /// margin dengan batasan luas lahan, modal, dan porsi maksimum satu tanaman.
  /// Batasan terakhir inilah yang membuat hasilnya berupa kombinasi, bukan satu
  /// tanaman saja.
  ///
  /// [hanya] membatasi optimasi pada tanaman yang dipilih pengguna: luas per
  /// tanaman tetap dihitung di sini, hanya daftarnya yang bersumber dari
  /// pengguna.
  static Saran optimize({
    required int landArea,
    required int capital,
    required String landType,
    String goal = 'Keuntungan',
    double priceFactor = 1.0,
    double maxShare = 0.35,
    List<String>? hanya,
  }) {
    double koef(Commodity c) => marginPerM2(c,
        landType: landType, priceFactor: priceFactor, goal: goal);
    final pilihan = hanya == null
        ? null
        : [
            for (final c in commodities)
              if (hanya.contains(c.id)) c
          ];
    final kandidat = [
      for (final c in (pilihan ?? commodities))
        if (koef(c) > 0) c
    ];
    PlanResult hampa() => mix(const [],
        capital: capital,
        landType: landType,
        goal: goal,
        priceFactor: priceFactor,
        landArea: landArea);
    if (kandidat.isEmpty || landArea < 1 || capital < 1) {
      return Saran(
        hasil: hampa(),
        pembatas: pilihan == null
            ? tr('belum ada tanaman yang menguntungkan pada kondisi ini')
            : tr('tanaman pilihan Anda belum menguntungkan pada kondisi ini'),
        nilai: 0,
      );
    }

    final n = kandidat.length;
    // Pilihan pengguna yang sedikit tidak boleh menyisakan lahan kosong: dengan
    // hanya n tanaman, porsi maksimum satu tanaman dilebarkan hingga 1/n.
    final share = pilihan != null && 1 / n > maxShare ? 1 / n : maxShare;
    final batas = (share * landArea).clamp(1.0, landArea.toDouble());
    // Ketika pengguna memilih beberapa tanaman, setiap tanaman harus memperoleh
    // bagian yang berarti, bukan nol. Tanpa batas bawah, simplex akan memusatkan
    // seluruh modal pada tanaman dengan rasio margin terhadap modal terbaik dan
    // mengabaikan pilihan lainnya. Lantai ditetapkan sebesar
    // (1 − share) / (n − 1) bagian lahan: satu tanaman masih dapat mencapai
    // batas penggeser sementara sisanya tetap memperoleh bagian. Lantai sebesar
    // 1/n akan menghabiskan seluruh lahan sehingga penggeser tidak berpengaruh.
    // Lantai ikut diskalakan turun bila modal tidak cukup membiayainya.
    //
    // Karena solver mensyaratkan ruas kanan ≥ 0, lantai tidak dirumuskan sebagai
    // kendala terpisah. Sebagai gantinya, sumber daya dikurangi lebih dulu sebesar
    // kebutuhan lantai, solver membagi sisanya, lalu lantai ditambahkan kembali
    // pada hasil setiap tanaman.
    final avgCost =
        kandidat.fold<double>(0, (t, c) => t + c.costPerM2) / n;
    final floorArea = n > 1 ? landArea * (1 - share) / (n - 1) : batas;
    final totalFloorCost = floorArea * n * avgCost;
    final minA = pilihan != null
        ? (totalFloorCost > capital
            ? floorArea * (capital / totalFloorCost) * 0.6
            : floorArea)
        : 0.0;
    final lahanSisa = (landArea - n * minA).clamp(0.0, landArea.toDouble());
    final modalSisa = (capital - n * minA * avgCost)
        .clamp(0.0, capital.toDouble());
    final batasSisa = (batas - minA).clamp(0.0, landArea.toDouble());
    final a = <List<double>>[
      [for (var i = 0; i < n; i++) 1.0],
      [for (final c in kandidat) c.costPerM2],
      for (var i = 0; i < n; i++)
        [for (var j = 0; j < n; j++) i == j ? 1.0 : 0.0],
    ];
    final b = <double>[
      lahanSisa,
      modalSisa,
      for (var i = 0; i < n; i++) batasSisa,
    ];
    final sol = solveLinearMax([for (final c in kandidat) koef(c)], a, b);
    if (sol == null) {
      return Saran(
          hasil: hampa(), pembatas: tr('optimasi tidak konvergen'), nilai: 0);
    }

    final lines = <PlanLine>[
      for (var i = 0; i < n; i++)
        if (sol.x[i] + minA > 0.5)
          PlanLine(kandidat[i].id, sol.x[i] + minA),
    ];
    final hasil = mix(lines,
        capital: capital,
        landType: landType,
        goal: goal,
        priceFactor: priceFactor,
        landArea: landArea);

    final sisaLahan = landArea - hasil.requestedArea;
    final sisaModal = capital - hasil.cost;
    final pembatas = sisaLahan < 1 && sisaModal < 1
        ? tr('lahan dan modal habis lebih dulu')
        : sisaLahan < 1
            ? tr('lahan habis lebih dulu')
            : sisaModal < 1
                ? tr('modal habis lebih dulu')
                : tpl('batas {0}% lahan per tanaman yang menahan',
                    [(share * 100).round().toString()]);
    return Saran(
        hasil: hasil, pembatas: pembatas, nilai: sol.value, maxShare: share);
  }

  /// Urutan rekomendasi dari yang terbaik.
  static List<Reco> rank({
    required int area,
    required int capital,
    required String landType,
    required String goal,
  }) {
    final list = [
      for (final c in commodities)
        evaluate(c,
            area: area, capital: capital, landType: landType, goal: goal)
    ];
    list.sort((a, b) => b.score.compareTo(a.score));
    return list;
  }

  static List<Pro> strengths(Reco r, int area) {
    final dem = MarketService.demand(r.c).last;
    return [
      Pro(
          dem >= 60,
          dem >= 60
              ? tr('Permintaan pasar tinggi')
              : tr('Permintaan pasar sedang')),
      Pro(
          r.c.volatility <= 0.25,
          r.c.volatility <= 0.25
              ? tr('Harga relatif stabil')
              : tr('Harga fluktuatif, siapkan dana cadangan')),
      Pro(
          r.suit >= 0.95,
          r.suit >= 0.95
              ? tpl('Cocok untuk lahan {0} m²', [_n(area)])
              : tr('Kecocokan lahan sedang')),
      Pro(
          !r.capitalLimited,
          !r.capitalLimited
              ? tr('Modal mencukupi untuk seluruh lahan')
              : tpl('Modal hanya cukup untuk {0} m²', [_n(r.effArea.floor())])),
    ];
  }

  static String _n(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
