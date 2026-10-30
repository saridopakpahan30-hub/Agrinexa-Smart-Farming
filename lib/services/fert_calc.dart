/// Perhitungan untuk layar Kalkulator Pupuk: jumlah tanaman, dosis per batang,
/// jadwal per fase, dan alasan satu pupuk cocok bagi tanaman tertentu.
///
/// Seluruh fungsi bersifat murni (tanpa Flutter, tanpa jaringan) sehingga mudah
/// diuji dan hasilnya dapat digunakan kembali oleh layar Laporan.
library;

import '../data/fertilizers.dart';
import '../models/commodity.dart';
import '../models/crop_guide.dart';

/// Jumlah tanaman di atas `areaM2` dari string jarak tanam bebas seperti
/// '60 × 50 cm', '2 × 2 m', atau '40 × 30 cm (2 biji per lubang)'.
///
/// Mengembalikan null bila polanya tidak dapat dipercaya (misalnya 'sebar
/// rata'), sehingga layar meminta jumlah tanaman kepada pengguna alih-alih
/// menetapkan angka tanpa dasar.
int? plantsFromSpacing(String space, double areaM2) {
  if (areaM2 <= 0) return null;
  final s = space.toLowerCase();
  if (s.contains('sebar rata') || s.contains('tanpa jarak')) return null;
  final angka = RegExp(r'([0-9]+(?:[.,][0-9]+)?)').allMatches(s).toList();
  if (angka.length < 2) return null;
  double parse(Match m) => double.parse(m.group(1)!.replaceAll(',', '.'));
  final a = parse(angka[0]);
  final b = parse(angka[1]);
  if (a <= 0 || b <= 0) return null;
  final meter = RegExp(r'\bx\s*[0-9]+(?:[.,][0-9]+)?\s*m').hasMatch(s) ||
      RegExp(r'[0-9]\s*m\b').hasMatch(s);
  final kali = meter ? 100.0 : 1.0;
  final perTanaman = (a * kali / 100) * (b * kali / 100);
  if (perTanaman <= 0) return null;
  var n = (areaM2 / perTanaman).floor();
  final biji = RegExp(r'\(([0-9])\s*biji').firstMatch(s);
  if (biji != null) n *= int.parse(biji.group(1)!);
  return n > 0 ? n : null;
}

/// Jumlah tanaman untuk satu komoditas pada luas tertentu. Tanaman keras
/// menggunakan kerapatan anjuran panduan (`trees` per hektar) bila tersedia.
int plantCount(Commodity c, CropGuide g, double areaM2) {
  if (g.trees > 0) return ((areaM2 / 10000) * g.trees).round();
  return plantsFromSpacing(g.spacing, areaM2) ?? 0;
}

/// Gram pupuk per satu tanaman. Nol bila jumlah tanaman tidak diketahui.
double gramsPerPlant(double kg, int plants) =>
    plants <= 0 ? 0 : kg * 1000 / plants;

/// Bagian tanaman yang dipanen, diturunkan dari kategori komoditas. Digunakan
/// untuk menjelaskan kecocokan hara tanpa menyusun tabel bagi 69 tanaman.
String harvestedPart(Commodity c) {
  switch (c.category) {
    case 'Sayuran':
      return 'daun dan bagian muda yang dipanen cepat';
    case 'Pangan':
      return 'biji atau umbi yang harus terisi penuh';
    case 'Buah':
      return 'buah, sehingga mutu isi buah lebih penting daripada daun';
    case 'Perkebunan':
      return 'hasil tahunan dari tanaman yang tidak boleh stres hara';
    case 'Rempah':
      return 'rimpang atau umbi yang butuh kalium dan bahan organik';
    default:
      return 'hasil panennya';
  }
}

/// Rentang umur pemberian satu jenis pupuk, dalam minggu sejak tanam.
/// Minggu bernilai negatif berarti diberikan sebelum tanam, pada saat
/// pengolahan tanah.
List<FertWindow> fertSchedule(CropGuide g, FertKind k, int growDays) {
  final hari = growDays > 0 ? growDays : 90;
  final out = <FertWindow>[];
  for (final id in k.phases) {
    final p = FertPhase.byId(id);
    out.add(FertWindow(
      p,
      id == 'olah' ? -2 : (p.from * hari / 7).ceil(),
      id == 'olah' ? 0 : (p.to * hari / 7).floor(),
    ));
  }
  return out;
}

class FertWindow {
  final FertPhase phase;
  final int fromWeek, toWeek;
  const FertWindow(this.phase, this.fromWeek, this.toWeek);

  bool get beforePlanting => toWeek <= 0;
}

class FertReason {
  final String title, text;
  final bool caution;
  const FertReason(this.title, this.text, {this.caution = false});
}

/// Alasan pupuk ini masuk daftar tanaman tersebut, dan kapan justru kurang
/// cocok. Disusun dari hara, pH ideal tanaman, jenis tanah, dan kebutuhan
/// air — seluruhnya data yang sudah tersedia di aplikasi.
List<FertReason> fertAlasan({
  required Commodity c,
  required CropGuide g,
  required FertKind k,
}) {
  final out = <FertReason>[];

  out.add(FertReason(
    'Hara yang Anda beli',
    '${k.label} menyediakan ${k.unsur}. Perannya: ${k.fungsi} '
    'Tanaman ini dipanen pada ${harvestedPart(c)}, dan pupuk ini paling '
    'berpengaruh pada ${k.feeds}.',
  ));

  final phMid = (g.phMin + g.phMax) / 2;
  switch (k.phEffect) {
    case PhEffect.menaikkan:
      final cocok = phMid < 6.0;
      out.add(FertReason(
        'Kaitannya dengan pH tanah',
        cocok
            ? 'Panduan ${c.name} menyebut pH ideal ${_ph(g)} — tanah yang perlu '
                'dikapur. ${k.label} menaikkan pH, sehingga hara lain terutama '
                'fosfor menjadi tersedia kembali.'
            : 'pH ideal ${c.name} sudah ${_ph(g)}, jadi ${k.label} hanya '
                'diberikan bila hasil uji tanah menunjukkan lahan Anda memang '
                'masam.',
        caution: !cocok,
      ));
      break;
    case PhEffect.menurunkan:
      final rawan = g.phMin < 5.5;
      out.add(FertReason(
        'Kaitannya dengan pH tanah',
        rawan
            ? '${k.label} perlahan menurunkan pH. Batas bawah ${c.name} ada di '
                'pH ${_num(g.phMin)}, jadi berikan bersama pupuk organik atau '
                'kapur agar tanah tidak cepat masam.'
            : '${k.label} perlahan menurunkan pH, tetapi rentang ${c.name} '
                '(${_ph(g)}) masih aman untuk beberapa musim berturut-turut.',
        caution: rawan,
      ));
      break;
    case PhEffect.netral:
      out.add(FertReason(
        'Kaitannya dengan pH tanah',
        '${k.label} hampir tidak mengubah pH, sehingga aman dipakai pada '
        'rentang ${c.name} (${_ph(g)}).',
      ));
      break;
  }

  final tanah = g.soil.toLowerCase();
  if (tanah.contains('pasir')) {
    out.add(FertReason(
      'Kaitannya dengan jenis tanah',
      'Tanah anjuran ${c.name} berpasir: ${k.soilFit}',
    ));
  } else if (tanah.contains('liat') || tanah.contains('gambut')) {
    out.add(FertReason(
      'Kaitannya dengan jenis tanah',
      'Tanah anjuran ${c.name} berat: ${k.soilWarn}',
      caution: k.id == 'sp36' || k.id == 'kcl',
    ));
  }

  if ((k.id == 'urea' || k.id == 'npk' || k.id == 'za') &&
      (g.water.toLowerCase().contains('genangan') ||
          g.water.toLowerCase().contains('lembap'))) {
    out.add(FertReason(
      'Kaitannya dengan air',
      '${c.name} tidak suka genangan tetapi tanah harus lembap. Tabur lalu '
      'tutup tanah, atau kocor pada tanaman kecil; nitrogen yang tertinggal di '
      'permukaan menguap sebagai amonia dan hilang sebelum sampai ke akar.',
      caution: true,
    ));
  }

  return out;
}

String _ph(CropGuide g) => '${_num(g.phMin)} sampai ${_num(g.phMax)}';

String _num(double v) =>
    v.toStringAsFixed(v % 1 == 0 ? 0 : 1).replaceAll('.', ',');
