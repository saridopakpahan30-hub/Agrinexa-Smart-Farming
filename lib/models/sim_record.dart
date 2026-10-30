/// Satu hasil simulasi yang pernah dihitung dan disimpan pengguna.
class SimRecord {
  final String id, commodityId, date;
  final double area, omzet, cost, margin, roi, priceFactor;
  final int capital;

  const SimRecord({
    this.id = '',
    required this.commodityId,
    required this.date,
    required this.area,
    required this.capital,
    required this.omzet,
    required this.cost,
    required this.margin,
    required this.roi,
    required this.priceFactor,
  });

  /// Rekaman lama tidak memiliki id, sehingga angka hasilnya ikut menjadi
  /// identitas agar id yang sama selalu muncul saat dibaca ulang. Bila id
  /// dibuat acak, riwayat lama akan tertulis ulang sebagai baris baru di
  /// server setiap kali aplikasi dibuka.
  String get kunci => id.isNotEmpty
      ? id
      : '${date}_${commodityId}_${omzet.round()}_${roi.round()}';

  Map<String, dynamic> toJson() => {
        'id': kunci,
        'c': commodityId,
        'd': date,
        'a': area,
        'k': capital,
        'o': omzet,
        'b': cost,
        'm': margin,
        'r': roi,
        'p': priceFactor,
      };

  factory SimRecord.fromJson(Map<String, dynamic> j) => SimRecord(
        id: j['id'] as String? ?? '',
        commodityId: j['c'] as String,
        date: j['d'] as String,
        area: (j['a'] as num).toDouble(),
        capital: (j['k'] as num).toInt(),
        omzet: (j['o'] as num).toDouble(),
        cost: (j['b'] as num).toDouble(),
        margin: (j['m'] as num).toDouble(),
        roi: (j['r'] as num).toDouble(),
        priceFactor: (j['p'] as num).toDouble(),
      );
}
