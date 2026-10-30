import '../core/i18n.dart';
import '../models/commodity.dart';
import '../models/planting.dart';
import 'weather_service.dart';

/// Satu kerja ladang yang harus dikerjakan hari ini, atau sudah terlewat.
/// Digunakan oleh Mode Ladang: judul ditampilkan sebagai teks besar dan
/// [detail] dibacakan melalui suara.
class FieldTask {
  final Commodity crop;
  final String title;
  final String detail;

  /// Peringatan cuaca yang menyertai kerja ini, bila ada.
  final String? caution;

  /// Rujukan ke tahap kalender tanam. Null berarti tugas umum (tidak ditandai
  /// pada kalender), misalnya kerja yang muncul dari kondisi cuaca.
  final String? plantingId;
  final int? stage;

  /// Label jatuh tempo, misalnya "Terlewat 3 hari", "Jatuh tempo hari ini",
  /// atau "2 hari lagi".
  final String dueLabel;
  final bool overdue;

  /// Hari ke-N sejak tanggal tanam; -1 untuk tugas umum tanpa rencana tanam.
  final int dayOfSeason;

  const FieldTask({
    required this.crop,
    required this.title,
    required this.detail,
    required this.dueLabel,
    this.caution,
    this.plantingId,
    this.stage,
    this.overdue = false,
    this.dayOfSeason = -1,
  });

  bool get linkable => plantingId != null && stage != null;

  String get spoken {
    final hari = dayOfSeason >= 0 ? tpl(', hari ke {0}', ['$dayOfSeason']) : '';
    final b = StringBuffer(
        tpl('{0}, untuk {1}{2}.', [tr(title), tr(crop.name), hari]))
      ..write(tr(detail));
    if (caution != null) {
      b.write(' ${tpl('Perhatian: {0}', [tr(caution!)])}');
    }
    return b.toString();
  }
}

DateTime _clean(DateTime d) => DateTime(d.year, d.month, d.day);

/// Daftar kerja yang jatuh tempo, terurut dari yang paling mendesak.
///
/// [leadDays] menentukan berapa hari ke depan ikut ditampilkan agar pengguna
/// dapat menyiapkan pekerjaan; [graceDays] menentukan batas hari keterlambatan
/// yang masih diingat — setelah itu tugas dianggap terlewat tanpa dilaporkan.
List<FieldTask> buildFieldTasks({
  required List<Planting> plantings,
  required WeatherDay? today,
  required Commodity activeCrop,
  DateTime? now,
  int leadDays = 2,
  int graceDays = 21,
  int max = 6,
}) {
  final hariIni = _clean(now ?? DateTime.now());
  final denganWaktu = <(int, DateTime, FieldTask)>[];

  for (final p in plantings) {
    final c = p.commodity;
    final stages = stagesFor(c);
    final mulai = _clean(p.start);
    for (var i = 0; i < stages.length; i++) {
      if (p.done.contains(i)) continue;
      final st = stages[i];
      final jatuhTempo = mulai.add(Duration(days: st.dayOffset));
      final selisih = hariIni.difference(jatuhTempo).inDays;
      if (selisih < -leadDays || selisih > graceDays) continue;
      denganWaktu.add((
        selisih,
        jatuhTempo,
        FieldTask(
          crop: c,
          title: st.label,
          detail: guidance(c, st),
          caution: weatherCaution(st, today),
          plantingId: p.id,
          stage: i,
          dueLabel: dueLabel(selisih),
          overdue: selisih > 0,
          dayOfSeason: hariIni.difference(mulai).inDays,
        ),
      ));
    }
  }

  // Tugas paling lama terlewat tampil lebih dulu, disusul yang paling dekat
  // jatuh temponya.
  denganWaktu.sort((a, b) {
    final bySelisih = b.$1.compareTo(a.$1);
    return bySelisih != 0 ? bySelisih : a.$2.compareTo(b.$2);
  });

  final out = [for (final e in denganWaktu.take(max)) e.$3];
  if (out.isNotEmpty) return out;
  return _generalTasks(activeCrop: activeCrop, today: today, now: hariIni);
}

String dueLabel(int selisih) => switch (selisih) {
      < 0 =>
        selisih == -1 ? tr('Besok') : tpl('{0} hari lagi', ['${-selisih}']),
      0 => tr('Jatuh tempo hari ini'),
      1 => tr('Terlewat 1 hari'),
      _ => tpl('Terlewat {0} hari', ['$selisih']),
    };

/// Petunjuk cara mengerjakan satu tahap, ditulis untuk dibacakan: angka dan
/// satuan memakai kata, bukan simbol. Pencocokan tahap menggunakan potongan
/// 'upuk' sehingga "pupuk", "memupuk", dan "pemupukan" ikut terdeteksi.
String guidance(Commodity c, PlantStage st) {
  final l = st.label.toLowerCase();
  if (l.contains('pengolahan')) {
    return tr('Bersihkan lahan dari gulma dan sisa tanaman musim lalu. '
        'Buat bedengan setinggi tiga puluh sampai empat puluh sentimeter agar '
        'air tidak menggenang, lalu diamkan tiga sampai tujuh hari sebelum tanam.');
  }
  if (l.contains('penanaman') || l.contains('bibit')) {
    return tr(
        'Tanam pagi sebelum jam sembilan atau sore setelah jam empat agar '
        'bibit tidak stres. Siram bedengan lebih dulu, tutup pangkal batang '
        'perlahan, dan jangan menekan terlalu padat.');
  }
  if (l.contains('sulam')) {
    return tr(
        'Jalani barisan tanam dan ganti bibit yang mati atau tumbuh kerdil. '
        'Siapkan cadangan dari persemaian yang sama umur dan tingginya.');
  }
  if (l.contains('pemangkasan') || l.contains('sanitasi')) {
    return tr('Potong cabang patah, tunas air yang tidak diperlukan, dan daun '
        'kuning di bawah kanopi. Kumpulkan dan buang jauh dari tanaman supaya '
        'spora jamur tidak menyebar.');
  }
  if (l.contains('upuk')) {
    return tpl(
        'Beri pupuk di samping barisan, sekitar sepuluh sentimeter dari '
        'batang, jangan menempel ke pangkal. Timbun tipis dan siram agar larut '
        'perlahan. {0} paling butuh pada fase tumbuh cepat ini.',
        [tr(c.name)]);
  }
  if (l.contains('hama')) {
    return tr(
        'Periksa daun bagian bawah dan pucuk di sepuluh titik acak. Kutip '
        'kelompok telur atau daun yang bergejala, lalu cocokkan gejala dengan '
        'panduan hama sebelum memutuskan penyemprotan.');
  }
  if (l.contains('panen')) {
    return tr('Panen pagi setelah embun kering tetapi sebelum panas. Potong, '
        'jangan tarik batang. Sortir segera agar hasil tidak tertumpuk panas '
        'di dalam karung.');
  }
  return tpl(
      'Lakukan {0} sesuai jadwal kalender tanam Anda, '
      'kemudian catat hasilnya agar jadwal berikutnya makin akurat.',
      [Lang.inggris ? tr(st.label) : st.label.toLowerCase()]);
}

/// Peringatan cuaca yang mengubah cara mengerjakan suatu tahap, bukan
/// membatalkannya.
String? weatherCaution(PlantStage st, WeatherDay? w) {
  if (w == null) return null;
  final l = st.label.toLowerCase();
  final prob = (w.rainProb * 100).round();
  final hujan = w.condition == 'hujan_lebat';
  if (l.contains('pengolahan') && hujan) {
    return tr('Hujan lebat dan tanah jenuh air. Menginjak bedengan hari ini '
        'memadatkan tanah; tunda satu sampai dua hari.');
  }
  if (l.contains('upuk') && (hujan || w.rainProb >= 0.7)) {
    return tpl(
        'Peluang hujan {0} persen. Pupuk akan larut terbawa air sebelum '
        'akar sempat menyerap; lebih baik setelah hujan reda.',
        ['$prob']);
  }
  if (l.contains('upuk') && w.condition == 'panas') {
    return tpl(
        'Suhu {0} derajat. Siram bedengan dulu agar pupuk '
        'tidak membakar akar, dan kerjakan sebelum jam tujuh pagi.',
        ['${w.maxTemp.round()}']);
  }
  if (l.contains('panen') &&
      (w.condition == 'hujan' || hujan || w.rainProb >= 0.6)) {
    return tpl(
        'Peluang hujan {0} persen. Panen lebih pagi, siapkan terpal '
        'pengering, dan jangan simpan hasil basah di karung tertutup.',
        ['$prob']);
  }
  if (l.contains('penanaman') && w.condition == 'panas') {
    return tpl(
        'Panas terik {0} derajat. Tanam sore dan pasang '
        'teduhan sementara selama tiga hari pertama.',
        ['${w.maxTemp.round()}']);
  }
  if (l.contains('hama') && hujan) {
    return tr(
        'Semprotan akan luntur sebelum menempel. Kerjakan pengamatan saja, '
        'tunda penyemprotan sampai daun kering.');
  }
  return null;
}

/// Bila belum ada rencana tanam, Mode Ladang tetap dapat digunakan: kerja
/// pengamatan rutin disertai saran dari cuaca hari ini.
List<FieldTask> _generalTasks({
  required Commodity activeCrop,
  required WeatherDay? today,
  required DateTime now,
}) {
  final tugas = <FieldTask>[
    FieldTask(
      crop: activeCrop,
      title: 'Keliling lahan & amati tanaman',
      detail: tpl(
          'Jalani barisan tanaman {0} dan '
          'periksa sepuluh titik acak: warna daun, lubang bekas gigit, dan '
          'kelembapan tanah sedalam dua sentimeter. Catat yang aneh di panduan '
          'hama agar saran berikutnya tepat.',
          [Lang.inggris ? tr(activeCrop.name) : activeCrop.name.toLowerCase()]),
      dueLabel: 'Jatuh tempo hari ini',
    ),
  ];
  if (today != null) {
    final saran = WeatherService.advice(today);
    if (saran.isNotEmpty) {
      tugas.add(FieldTask(
        crop: activeCrop,
        title: tpl('Sesuaikan kerja dengan cuaca {0}', [
          Lang.inggris
              ? tr(today.label).toLowerCase()
              : today.label.toLowerCase()
        ]),
        detail: saran.take(2).join(' '),
        dueLabel: 'Hari ini',
      ));
    }
  }
  if (today == null) {
    tugas.add(FieldTask(
      crop: activeCrop,
      title: 'Atur lokasi kebun',
      detail: 'Mode Ladang menyesuaikan kerja dengan cuaca di kebun Anda. '
          'Buka layar Cuaca lalu pilih nama desa atau kecamatan kebun Anda.',
      dueLabel: 'Sekali saja',
    ));
  }
  return tugas;
}
