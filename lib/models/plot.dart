/// Satu petak lahan. Widget `PlotMap` sebelumnya hanya menerima zona turunan
/// dari hasil rencana; entitas ini memungkinkan data lahan disimpan dan
/// disinkronkan.
class Plot {
  final String id;
  final String name;
  final int areaM2;
  final String landType;
  final String? commodityId;
  final int order;
  final String note;
  final bool deleted;
  final int updatedMs;

  const Plot({
    required this.id,
    required this.name,
    required this.areaM2,
    this.landType = '',
    this.commodityId,
    this.order = 0,
    this.note = '',
    this.deleted = false,
    this.updatedMs = 0,
  });

  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedMs);

  Plot copyWith({String? commodityId, int? areaM2, int? updatedMs}) => Plot(
        id: id,
        name: name,
        areaM2: areaM2 ?? this.areaM2,
        landType: landType,
        commodityId: commodityId ?? this.commodityId,
        order: order,
        note: note,
        deleted: deleted,
        updatedMs: updatedMs ?? this.updatedMs,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'areaM2': areaM2,
        'landType': landType,
        'commodityId': commodityId,
        'order': order,
        'note': note,
        'deleted': deleted,
        'updatedMs': updatedMs,
      };

  factory Plot.fromJson(Map<String, dynamic> j) => Plot(
        id: j['id'] as String,
        name: (j['name'] as String?) ?? '',
        areaM2: (j['areaM2'] as num?)?.toInt() ?? 0,
        landType: (j['landType'] as String?) ?? '',
        commodityId: j['commodityId'] as String?,
        order: (j['order'] as num?)?.toInt() ?? 0,
        note: (j['note'] as String?) ?? '',
        deleted: (j['deleted'] as bool?) ?? false,
        updatedMs: (j['updatedMs'] as num?)?.toInt() ?? 0,
      );
}
