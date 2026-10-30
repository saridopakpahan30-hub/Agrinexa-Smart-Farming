import 'commodity.dart';

/// Satu rencana tanam: komoditas, tanggal tanam, dan tahap yang telah selesai.
class Planting {
  final String id;
  final String commodityId;
  final int startMs; // tanggal tanam
  final List<int> done; // indeks tahap yang ditandai selesai

  const Planting({
    required this.id,
    required this.commodityId,
    required this.startMs,
    this.done = const [],
  });

  DateTime get start => DateTime.fromMillisecondsSinceEpoch(startMs);
  Commodity get commodity => commodityById(commodityId);

  Map<String, dynamic> toJson() =>
      {'id': id, 'c': commodityId, 't': startMs, 'd': done};

  factory Planting.fromJson(Map<String, dynamic> j) => Planting(
        id: j['id'] as String,
        commodityId: j['c'] as String,
        startMs: (j['t'] as num).toInt(),
        done: [for (final d in (j['d'] as List? ?? [])) (d as num).toInt()],
      );
}

class PlantStage {
  final String label;
  final int dayOffset; // hari sejak tanggal tanam (bisa negatif = pra-tanam)
  const PlantStage(this.label, this.dayOffset);
}

/// Tahapan kerja yang diturunkan dari umur panen komoditas.
List<PlantStage> stagesFor(Commodity c) {
  final g = c.growDays;
  // tanaman tahunan: tahap perawatan lebih panjang
  if (g > 365) {
    return [
      const PlantStage('Pengolahan lahan & lubang tanam', -14),
      const PlantStage('Penanaman bibit', 0),
      PlantStage('Pemupukan awal', (g * 0.05).round().clamp(15, 90)),
      PlantStage('Pemangkasan & sanitasi kebun', (g * 0.35).round()),
      PlantStage('Pemupukan lanjutan', (g * 0.6).round()),
      PlantStage('Awal panen (selektif)', g),
    ];
  }
  return [
    const PlantStage('Pengolahan lahan & bedengan', -7),
    const PlantStage('Penanaman', 0),
    PlantStage('Penyulaman & pemupukan awal', (g * 0.2).round().clamp(7, 30)),
    PlantStage('Pemupukan kedua', (g * 0.45).round()),
    PlantStage('Pemeliharaan & pengawasan hama', (g * 0.7).round()),
    PlantStage('Perkiraan panen', g),
  ];
}
