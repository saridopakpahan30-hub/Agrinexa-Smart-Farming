/// Satu pekerjaan atau pengamatan lapangan. Entitas ini menjadi dasar
/// pencatatan waktu untuk `Planting.done`, catatan hama, serta riwayat yang
/// dapat disinkronkan antar perangkat.
class FarmActivity {
  static const kinds = [
    'tanam',
    'pemupukan',
    'penyiraman',
    'panen',
    'hama',
    'pengamatan',
    'lain',
  ];

  final String id;
  final String kind;
  final String? plotId;
  final String? plantingId;
  final String? commodityId;
  final String title;
  final String detail;
  final int severity;
  final int occurredMs;
  final bool deleted;
  final int updatedMs;

  const FarmActivity({
    required this.id,
    required this.kind,
    required this.title,
    this.plotId,
    this.plantingId,
    this.commodityId,
    this.detail = '',
    this.severity = 0,
    required this.occurredMs,
    this.deleted = false,
    this.updatedMs = 0,
  });

  DateTime get occurredAt => DateTime.fromMillisecondsSinceEpoch(occurredMs);

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'plotId': plotId,
        'plantingId': plantingId,
        'commodityId': commodityId,
        'title': title,
        'detail': detail,
        'severity': severity,
        'occurredMs': occurredMs,
        'deleted': deleted,
        'updatedMs': updatedMs,
      };

  factory FarmActivity.fromJson(Map<String, dynamic> j) => FarmActivity(
        id: j['id'] as String,
        kind: (j['kind'] as String?) ?? 'lain',
        plotId: j['plotId'] as String?,
        plantingId: j['plantingId'] as String?,
        commodityId: j['commodityId'] as String?,
        title: (j['title'] as String?) ?? '',
        detail: (j['detail'] as String?) ?? '',
        severity: (j['severity'] as num?)?.toInt() ?? 0,
        occurredMs: (j['occurredMs'] as num?)?.toInt() ?? 0,
        deleted: (j['deleted'] as bool?) ?? false,
        updatedMs: (j['updatedMs'] as num?)?.toInt() ?? 0,
      );
}
