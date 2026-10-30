/// Satu baris alokasi lahan hasil optimasi.
class OptimizationPart {
  final String commodityId;
  final double areaM2;
  final double omzet;
  final double cost;

  const OptimizationPart({
    required this.commodityId,
    required this.areaM2,
    required this.omzet,
    required this.cost,
  });

  double get margin => omzet - cost;

  Map<String, dynamic> toJson() => {
        'commodityId': commodityId,
        'areaM2': areaM2,
        'omzet': omzet,
        'cost': cost,
      };

  factory OptimizationPart.fromJson(Map<String, dynamic> j) => OptimizationPart(
        commodityId: j['commodityId'] as String,
        areaM2: (j['areaM2'] as num?)?.toDouble() ?? 0,
        omzet: (j['omzet'] as num?)?.toDouble() ?? 0,
        cost: (j['cost'] as num?)?.toDouble() ?? 0,
      );
}

/// Arsip rencana optima yang pernah dihitung pengguna, lengkap dengan variabel
/// masuknya, agar angka lama tetap dapat dibaca ulang setelah harga berubah.
class OptimizationRun {
  final String id;
  final int createdMs;
  final int landArea;
  final int capital;
  final String landType;
  final String goal;
  final double priceFactor;
  final double maxShare;
  final List<String> onlyIds;
  final String pembatas;
  final double nilai;
  final double requestedArea;
  final double usedArea;
  final bool capitalLimited;
  final bool landOver;
  final List<OptimizationPart> parts;
  final bool deleted;
  final int updatedMs;

  const OptimizationRun({
    required this.id,
    required this.createdMs,
    required this.landArea,
    required this.capital,
    required this.landType,
    required this.goal,
    this.priceFactor = 1.0,
    this.maxShare = 0.35,
    this.onlyIds = const [],
    this.pembatas = '',
    this.nilai = 0,
    this.requestedArea = 0,
    this.usedArea = 0,
    this.capitalLimited = false,
    this.landOver = false,
    this.parts = const [],
    this.deleted = false,
    this.updatedMs = 0,
  });

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdMs);

  double get omzet => parts.fold(0.0, (t, p) => t + p.omzet);
  double get cost => parts.fold(0.0, (t, p) => t + p.cost);
  double get margin => omzet - cost;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdMs': createdMs,
        'landArea': landArea,
        'capital': capital,
        'landType': landType,
        'goal': goal,
        'priceFactor': priceFactor,
        'maxShare': maxShare,
        'onlyIds': onlyIds,
        'pembatas': pembatas,
        'nilai': nilai,
        'requestedArea': requestedArea,
        'usedArea': usedArea,
        'capitalLimited': capitalLimited,
        'landOver': landOver,
        'parts': [for (final p in parts) p.toJson()],
        'deleted': deleted,
        'updatedMs': updatedMs,
      };

  factory OptimizationRun.fromJson(Map<String, dynamic> j) => OptimizationRun(
        id: j['id'] as String,
        createdMs: (j['createdMs'] as num?)?.toInt() ?? 0,
        landArea: (j['landArea'] as num?)?.toInt() ?? 0,
        capital: (j['capital'] as num?)?.toInt() ?? 0,
        landType: (j['landType'] as String?) ?? '',
        goal: (j['goal'] as String?) ?? 'Keuntungan',
        priceFactor: (j['priceFactor'] as num?)?.toDouble() ?? 1.0,
        maxShare: (j['maxShare'] as num?)?.toDouble() ?? 0.35,
        onlyIds: [for (final s in (j['onlyIds'] as List? ?? [])) s as String],
        pembatas: (j['pembatas'] as String?) ?? '',
        nilai: (j['nilai'] as num?)?.toDouble() ?? 0,
        requestedArea: (j['requestedArea'] as num?)?.toDouble() ?? 0,
        usedArea: (j['usedArea'] as num?)?.toDouble() ?? 0,
        capitalLimited: (j['capitalLimited'] as bool?) ?? false,
        landOver: (j['landOver'] as bool?) ?? false,
        parts: [
          for (final p in (j['parts'] as List? ?? []))
            OptimizationPart.fromJson(Map<String, dynamic>.from(p as Map))
        ],
        deleted: (j['deleted'] as bool?) ?? false,
        updatedMs: (j['updatedMs'] as num?)?.toInt() ?? 0,
      );
}
