/// Panduan budidaya untuk tiap komoditas.
///
/// PENTING: panduan ini bersifat umum. Dosis pupuk dan pestisida berbeda
/// menurut varietas, kesuburan tanah, dan musim. Lakukan uji tanah dan
/// tanyakan kepada penyuluh pertanian (PPL) setempat. Selalu baca label
/// pestisida dan utamakan pengendalian hama terpadu (PHT): varietas tahan,
/// sanitasi, rotasi, serta musuh alami lebih dahulu.
library;

class Fert {
  final String name, detail, unit;
  final double? low, high;
  const Fert(this.name, this.detail, {this.low, this.high, this.unit = ''});

  bool get hasAmount => low != null && high != null && unit.isNotEmpty;

  /// Pupuk yang hanya digunakan pada kondisi tertentu (ditandai kata "bila"
  /// pada keterangan).
  bool get optional => detail.toLowerCase().contains('bila');
}

class Problem {
  final String name, type, symptom, action;
  const Problem(this.name, this.type, this.symptom, this.action);
}

class CropGuide {
  final double phMin, phMax;
  final String soil, altitude, water, sun, spacing, harvest, calNote;
  final int trees; // populasi per hektar (tanaman keras), 0 jika tidak dipakai
  final List<int> best, ok; // bulan tanam terbaik dan masih bisa (1 sampai 12)
  final List<Fert> fertilizers;
  final List<Problem> problems;
  final List<String> care;

  const CropGuide({
    required this.phMin,
    required this.phMax,
    required this.soil,
    required this.altitude,
    required this.water,
    required this.sun,
    required this.spacing,
    required this.harvest,
    required this.calNote,
    required this.trees,
    required this.best,
    required this.ok,
    required this.fertilizers,
    required this.problems,
    required this.care,
  });
}

/// Format penulisan data:
///  pupuk   'Nama|Keterangan'  atau  'Nama|Keterangan|min|maks|satuan'
///          satuan: ton/ha, kg/ha, kg/pohon, kg/pohon/thn, g/pohon/kali, g/pohon/thn
///  masalah 'Nama|Jenis|Gejala|Penanganan'
Fert _fert(String f) {
  final p = f.split('|');
  if (p.length >= 5) {
    return Fert(p[0], p[1],
        low: double.parse(p[2]), high: double.parse(p[3]), unit: p[4]);
  }
  return Fert(p[0], p[1]);
}

CropGuide _g({
  required List<double> ph,
  required String soil,
  required String alt,
  required String water,
  required String sun,
  required String space,
  required List<String> fert,
  required List<String> prob,
  required List<String> care,
  required String harvest,
  required List<int> best,
  required List<int> ok,
  int trees = 0,
  String calNote = '',
}) {
  return CropGuide(
    phMin: ph[0],
    phMax: ph[1],
    soil: soil,
    altitude: alt,
    water: water,
    sun: sun,
    spacing: space,
    harvest: harvest,
    calNote: calNote,
    trees: trees,
    best: best,
    ok: ok,
    fertilizers: [for (final f in fert) _fert(f)],
    problems: [
      for (final p in prob)
        Problem(
            p.split('|')[0], p.split('|')[1], p.split('|')[2], p.split('|')[3]),
    ],
    care: care,
  );
}

// ------------------------------------------------------ hitungan pupuk
class FertAmount {
  final Fert fert;
  final double lowKg, highKg;
  final String when;
  const FertAmount(this.fert, this.lowKg, this.highKg, this.when);
}

/// Kebutuhan pupuk (kg) untuk luas lahan tertentu, dari dosis per hektar
/// atau per pohon.
List<FertAmount> fertilizerPlan(CropGuide g, double areaM2) {
  final ha = areaM2 / 10000;
  final out = <FertAmount>[];
  for (final f in g.fertilizers) {
    if (!f.hasAmount) continue;
    double k;
    String when;
    switch (f.unit) {
      case 'ton/ha':
        k = ha * 1000;
        when = 'per musim tanam';
        break;
      case 'kg/ha':
        k = ha;
        when = 'per musim tanam';
        break;
      case 'kg/pohon':
        k = ha * g.trees;
        when = 'sekali, saat tanam';
        break;
      case 'kg/pohon/thn':
        k = ha * g.trees;
        when = 'per tahun';
        break;
      case 'g/pohon/kali':
        k = ha * g.trees / 1000;
        when = 'tiap pemberian';
        break;
      case 'g/pohon/thn':
        k = ha * g.trees / 1000;
        when = 'per tahun';
        break;
      default:
        continue;
    }
    if (k <= 0) continue;
    out.add(FertAmount(f, f.low! * k, f.high! * k, when));
  }
  return out;
}

// ---------------------------------------------------------- kalender
/// Bulan panen untuk tanaman semusim: bulan tanam + umur tanaman.
Set<int> harvestMonths(int growDays, List<int> plant) {
  final off = (growDays / 30.4).round();
  return {for (final m in plant) ((m - 1 + off) % 12) + 1};
}

CropGuide? guideFor(String id) => cropGuides[id];

final cropGuides = <String, CropGuide>{
  // ------------------------------------------------------------- SAYURAN
  'cabai': _g(
    ph: [6.0, 7.0],
    best: [4, 5, 6],
    ok: [3, 7, 8, 10, 11],
    soil: 'Lempung berpasir, gembur, kaya bahan organik, drainase baik.',
    alt: '0 sampai 1.200 mdpl',
    water: 'Sedang. Siram teratur, hindari genangan.',
    sun: 'Penuh (lebih dari 8 jam per hari).',
    space: '60 × 50 cm',
    fert: [
      'Kompos / pupuk kandang|15 sampai 20 ton per ha sebagai pupuk dasar.|15|20|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, dibagi 3 sampai 4 kali (dasar, 2, 5, dan 8 MST).|300|400|kg/ha',
      'KCl|100 sampai 150 kg per ha saat mulai berbuah.|100|150|kg/ha',
      'Dolomit|1 sampai 2 ton per ha bila pH di bawah 5,5, 2 minggu sebelum tanam.|1|2|ton/ha',
    ],
    prob: [
      'Antraknosa (patek)|Jamur|Bercak cekung kehitaman pada buah, buah busuk dan mengering.|Buang buah sakit, jaga jarak tanam, hindari genangan, fungisida sesuai label.',
      'Layu bakteri / Fusarium|Bakteri|Tanaman layu mendadak walau tanah lembap, pangkal batang cokelat.|Cabut dan musnahkan tanaman, rotasi dengan non-terung-terungan, perbaiki drainase.',
      'Thrips dan kutu kebul|Hama|Daun keriting, keperakan atau menguning; pembawa virus keriting.|Mulsa perak, perangkap kuning, insektisida nabati (neem).',
    ],
    care: [
      'Pasang mulsa plastik untuk menekan gulma dan menjaga kelembapan.',
      'Pasang ajir dan ikat batang saat tanaman mulai tinggi.',
      'Siram pagi atau sore, kurangi saat hujan deras.',
      'Pangkas tunas air di bawah percabangan pertama agar buah lebih banyak.',
    ],
    harvest:
        'Mulai 75 sampai 90 hari setelah tanam. Petik saat buah merah 80 sampai 90 persen, lakukan bertahap tiap 3 sampai 7 hari.',
  ),
  'tomat': _g(
    ph: [6.0, 6.8],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    soil: 'Lempung gembur, subur, drainase baik.',
    alt: '0 sampai 1.500 mdpl (optimal 700 sampai 1.300)',
    water: 'Sedang dan merata. Hindari membasahi daun.',
    sun: 'Penuh.',
    space: '60 × 50 cm',
    fert: [
      'Kompos / pupuk kandang|15 sampai 20 ton per ha sebagai pupuk dasar.|15|20|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, bertahap tiap 2 sampai 3 minggu.|300|400|kg/ha',
      'KCl / ZK (kalium)|100 sampai 200 kg per ha, penting saat pembuahan.|100|200|kg/ha',
      'Dolomit / kalsium|Cegah busuk ujung buah; berikan sebelum tanam dan jaga penyiraman.',
    ],
    prob: [
      'Hawar daun (Phytophthora)|Jamur|Bercak basah cokelat pada daun dan buah saat lembap.|Fungisida protektif, jarak tanam longgar, jangan basahi daun malam hari.',
      'Layu bakteri|Bakteri|Tanaman segar layu mendadak, batang berlendir.|Cabut tanaman, rotasi, perbaiki drainase dan pH.',
      'Busuk ujung buah|Fisiologis|Ujung buah hitam dan cekung.|Penyiraman teratur, cukupi kalsium, jangan beri N berlebih.',
    ],
    care: [
      'Pasang ajir lalu ikat batang secara berkala.',
      'Wiwil (buang) tunas air agar tanaman fokus berbuah.',
      'Gunakan mulsa agar buah bersih dan kelembapan stabil.',
      'Siram teratur; fluktuasi air memicu buah pecah.',
    ],
    harvest:
        'Mulai 70 sampai 90 hari setelah tanam. Petik saat buah mulai merah (breaker) bila akan dikirim jauh.',
  ),
  'bawangmerah': _g(
    ph: [6.0, 6.8],
    best: [6, 7, 8],
    ok: [5, 9],
    soil: 'Lempung berpasir, remah, drainase baik.',
    alt: '0 sampai 1.000 mdpl (optimal dataran rendah)',
    water: 'Cukup tetapi tidak tergenang; kurangi menjelang panen.',
    sun: 'Penuh, minimal 70 persen penyinaran.',
    space: '20 × 15 cm',
    fert: [
      'Pupuk kandang / kompos|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, dibagi 2 kali (dasar dan 3 MST).|300|400|kg/ha',
      'ZA (sumber belerang)|200 sampai 300 kg per ha; bawang butuh belerang.|200|300|kg/ha',
      'KCl|100 sampai 150 kg per ha untuk kualitas umbi.|100|150|kg/ha',
    ],
    prob: [
      'Ulat bawang (Spodoptera exigua)|Hama|Daun berlubang, tampak transparan.|Kumpulkan telur dan ulat, perangkap feromon, insektisida sesuai label.',
      'Bercak ungu (Alternaria)|Jamur|Bercak ungu cekung pada daun, daun patah.|Kurangi kelembapan, fungisida, drainase baik.',
      'Moler / Fusarium|Jamur|Tanaman layu, pangkal umbi busuk, daun memutar.|Gunakan bibit sehat, rotasi, Trichoderma.',
    ],
    care: [
      'Pakai umbi bibit yang sudah cukup tua (2 sampai 3 bulan setelah panen).',
      'Siram teratur di awal, kurangi saat umbi membesar.',
      'Bersihkan gulma pada umur 2 dan 4 minggu.',
      'Buat bedengan tinggi dengan parit agar air tidak menggenang.',
    ],
    harvest:
        'Umur 60 sampai 70 hari, saat 60 sampai 70 persen daun rebah. Angin-anginkan 1 sampai 2 minggu sebelum disimpan.',
  ),
  'kentang': _g(
    ph: [5.0, 6.5],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9],
    soil: 'Andosol atau lempung gembur, subur, drainase baik.',
    alt: '1.000 sampai 2.000 mdpl',
    water: 'Sedang dan merata; kebutuhan tinggi saat pembentukan umbi.',
    sun: 'Penuh.',
    space: '70 × 30 cm',
    fert: [
      'Pupuk kandang|20 sampai 30 ton per ha sebagai pupuk dasar.|20|30|ton/ha',
      'NPK 15-15-15|Sekitar 600 sampai 800 kg per ha, dibagi saat tanam dan 30 hari.|600|800|kg/ha',
      'KCl / ZK|150 sampai 200 kg per ha untuk pembesaran umbi.|150|200|kg/ha',
      'Belerang / pH rendah|Jaga pH di bawah 6,0 untuk menekan penyakit kudis.',
    ],
    prob: [
      'Busuk daun (Phytophthora infestans)|Jamur|Bercak basah cokelat tua, cepat meluas saat lembap dan dingin.|Fungisida bergantian, varietas tahan, drainase, jarak tanam longgar.',
      'Layu bakteri|Bakteri|Tanaman layu, umbi berlendir dan berbau.|Bibit bersertifikat, rotasi, cabut tanaman sakit.',
      'Kudis (Streptomyces)|Bakteri|Bercak kasar seperti kudis pada kulit umbi.|Jaga pH rendah, rotasi, hindari kapur berlebihan.',
    ],
    care: [
      'Pakai bibit bersertifikat (G3 atau G4).',
      'Lakukan pembumbunan 2 kali agar umbi tidak terkena sinar (menghijau).',
      'Pastikan drainase baik; genangan memicu busuk.',
      'Pantau cuaca lembap dan dingin; semprot pencegahan bila perlu.',
    ],
    harvest:
        'Umur 90 sampai 120 hari, saat daun menguning dan kulit umbi kuat. Biarkan 1 sampai 2 minggu setelah daun mati sebelum panen.',
  ),
  'kubis': _g(
    ph: [6.0, 6.8],
    best: [5, 6, 7, 8],
    ok: [3, 4, 9, 10],
    soil: 'Lempung gembur, subur, kaya bahan organik.',
    alt: '300 sampai 2.000 mdpl (optimal 800 sampai 1.500)',
    water: 'Cukup dan merata.',
    sun: 'Penuh.',
    space: '60 × 50 cm',
    fert: [
      'Pupuk kandang / kompos|15 sampai 20 ton per ha sebagai pupuk dasar.|15|20|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, bertahap.|300|400|kg/ha',
      'Urea|100 sampai 150 kg per ha pada fase pertumbuhan daun.|100|150|kg/ha',
      'Boraks (boron)|Sekitar 10 sampai 15 kg per ha bila tanah miskin boron (krop berlubang).|10|15|kg/ha',
    ],
    prob: [
      'Akar gada (Plasmodiophora)|Jamur|Akar membengkak, tanaman layu di siang hari.|Naikkan pH mendekati 7, rotasi 3 sampai 5 tahun, bibit sehat.',
      'Ulat daun kubis (Plutella)|Hama|Daun berlubang seperti jendela.|Bt, musuh alami, tanaman perangkap sawi.',
      'Busuk hitam (Xanthomonas)|Bakteri|Bercak kuning berbentuk V dari tepi daun, urat menghitam.|Benih sehat, rotasi, hindari luka.',
    ],
    care: [
      'Semai 3 sampai 4 minggu lalu pindah tanam.',
      'Bersihkan gulma dan lakukan pembumbunan.',
      'Siram teratur; kekurangan air membuat krop kecil.',
      'Pantau ulat sejak awal dan rutin periksa bagian bawah daun.',
    ],
    harvest: 'Umur 70 sampai 90 hari. Panen saat krop padat, sebelum pecah.',
  ),
  'wortel': _g(
    ph: [5.8, 6.8],
    best: [5, 6, 7, 8],
    ok: [4, 9, 10],
    soil: 'Gembur, dalam, berpasir lempung, bebas batu.',
    alt: '1.000 sampai 1.500 mdpl',
    water: 'Merata; kekeringan lalu basah membuat umbi pecah.',
    sun: 'Penuh.',
    space: 'Baris 20 cm, antar tanaman 5 sampai 10 cm',
    fert: [
      'Kompos matang|15 sampai 20 ton per ha. Hindari pupuk kandang segar (umbi bercabang).|15|20|ton/ha',
      'NPK 16-16-16|Sekitar 300 kg per ha, dibagi 2 kali.|300|300|kg/ha',
      'KCl|Sekitar 100 kg per ha untuk kualitas umbi.|100|100|kg/ha',
    ],
    prob: [
      'Busuk lunak (Erwinia)|Bakteri|Umbi lembek berlendir dan berbau.|Drainase baik, hindari luka saat panen, rotasi.',
      'Bercak daun (Alternaria / Cercospora)|Jamur|Bercak cokelat pada daun.|Fungisida sesuai label, jaga jarak tanam.',
      'Nematoda puru akar|Hama|Umbi berbintil dan bercabang.|Rotasi dengan serealia, tambah bahan organik.',
    ],
    care: [
      'Olah tanah dalam dan halus agar umbi lurus.',
      'Jarangkan tanaman umur 2 sampai 3 minggu.',
      'Bumbun agar bahu umbi tertutup (tidak menghijau).',
      'Siram teratur tanpa menggenang.',
    ],
    harvest:
        'Umur 90 sampai 100 hari, saat umbi berwarna penuh dan ukuran seragam.',
  ),
  'sawi': _g(
    ph: [6.0, 7.0],
    best: [4, 5, 6, 7, 8, 9],
    ok: [1, 2, 3, 10, 11, 12],
    soil: 'Gembur, subur, kaya bahan organik.',
    alt: '0 sampai 1.200 mdpl',
    water: 'Cukup; siram 1 sampai 2 kali sehari saat kemarau.',
    sun: 'Penuh sampai teduh ringan.',
    space: '20 × 20 cm',
    fert: [
      'Kompos / pupuk kandang|10 sampai 15 ton per ha sebagai pupuk dasar.|10|15|ton/ha',
      'Urea|100 sampai 150 kg per ha, dibagi 2 kali (7 dan 21 hari).|100|150|kg/ha',
      'NPK 16-16-16|Sekitar 200 kg per ha bila perlu.|200|200|kg/ha',
    ],
    prob: [
      'Ulat daun (Plutella / Crocidolomia)|Hama|Daun berlubang-lubang.|Jaring penutup, Bt, ambil ulat manual.',
      'Kutu daun|Hama|Daun keriting, ada koloni kecil di bawah daun.|Semprot air sabun atau neem.',
      'Busuk lunak / bercak daun|Bakteri|Daun busuk berlendir atau bercak cokelat.|Drainase baik, jangan terlalu rapat, buang tanaman sakit.',
    ],
    care: [
      'Semai 7 sampai 10 hari lalu pindah tanam.',
      'Siram pagi dan sore, tanpa membuat tanah becek.',
      'Bersihkan gulma pada 2 minggu pertama.',
      'Tutup bedengan dengan jaring bila ulat banyak.',
    ],
    harvest:
        'Umur 30 sampai 40 hari. Panen saat daun lebar dan belum berbunga.',
  ),
  'terong': _g(
    ph: [5.5, 6.8],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9, 10, 11],
    soil: 'Lempung gembur, subur, drainase baik.',
    alt: '0 sampai 1.200 mdpl',
    water: 'Sedang dan teratur.',
    sun: 'Penuh.',
    space: '70 × 60 cm',
    fert: [
      'Pupuk kandang / kompos|15 sampai 20 ton per ha sebagai pupuk dasar.|15|20|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, bertahap tiap 3 sampai 4 minggu.|300|400|kg/ha',
      'KCl|100 sampai 150 kg per ha saat pembuahan.|100|150|kg/ha',
    ],
    prob: [
      'Layu bakteri|Bakteri|Tanaman layu mendadak.|Cabut tanaman, rotasi, drainase baik, bibit sehat.',
      'Penggerek buah dan pucuk (Leucinodes)|Hama|Pucuk layu, buah berlubang.|Buang bagian terserang, perangkap feromon.',
      'Tungau dan kutu kebul|Hama|Daun menguning bercak, keperakan.|Neem, perangkap kuning, jaga kelembapan.',
    ],
    care: [
      'Pasang ajir agar batang tidak rebah.',
      'Pangkas tunas yang tidak produktif.',
      'Mulsa untuk menjaga kelembapan.',
      'Panen rutin agar tanaman terus berbuah.',
    ],
    harvest:
        'Mulai 70 sampai 100 hari. Petik saat buah mengkilap dan belum keras bijinya, tiap 3 sampai 4 hari.',
  ),
  'timun': _g(
    ph: [6.0, 7.0],
    best: [5, 6, 7, 8],
    ok: [3, 4, 9, 10],
    soil: 'Gembur, subur, kaya bahan organik, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Cukup dan merata.',
    sun: 'Penuh.',
    space: '60 × 40 cm dengan lanjaran',
    fert: [
      'Kompos / pupuk kandang|10 sampai 15 ton per ha sebagai pupuk dasar.|10|15|ton/ha',
      'NPK 16-16-16|250 sampai 300 kg per ha, bertahap.|250|300|kg/ha',
      'KCl|Sekitar 100 kg per ha saat berbuah.|100|100|kg/ha',
    ],
    prob: [
      'Embun tepung (powdery mildew)|Jamur|Bercak putih seperti tepung di daun.|Jaga sirkulasi udara, fungisida belerang atau sesuai label.',
      'Bulai (downy mildew)|Jamur|Bercak kuning bersudut, bawah daun keunguan.|Hindari daun basah lama, fungisida sesuai label.',
      'Lalat buah dan kumbang daun|Hama|Buah cacat, daun berlubang.|Perangkap atraktan, bungkus buah, sanitasi.',
    ],
    care: [
      'Pasang lanjaran agar buah bersih dan lurus.',
      'Mulsa untuk menjaga kelembapan dan menekan gulma.',
      'Siram teratur, hindari menyiram saat bunga mekar.',
      'Panen rutin sebelum buah terlalu tua.',
    ],
    harvest:
        'Umur 45 sampai 55 hari. Panen tiap 1 sampai 2 hari saat buah muda dan seragam.',
  ),
  'kacangpanjang': _g(
    ph: [5.5, 6.5],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9, 10],
    soil: 'Lempung berpasir, gembur, drainase baik.',
    alt: '0 sampai 800 mdpl',
    water: 'Sedang; peka terhadap genangan.',
    sun: 'Penuh.',
    space: '60 × 30 cm (2 biji per lubang)',
    fert: [
      'Kompos|Sekitar 10 ton per ha sebagai pupuk dasar.|10|10|ton/ha',
      'SP-36|100 kg per ha untuk perakaran dan pembungaan.|100|100|kg/ha',
      'KCl|50 sampai 75 kg per ha.|50|75|kg/ha',
      'Urea / NPK|Dosis rendah (NPK 100 sampai 150 kg per ha); kacang-kacangan memfiksasi N sendiri.|100|150|kg/ha',
    ],
    prob: [
      'Kutu daun dan penggerek polong|Hama|Daun keriting; polong berlubang.|Perangkap kuning, buang polong terserang, insektisida nabati.',
      'Karat daun|Jamur|Bintik oranye kecokelatan pada daun.|Jaga jarak tanam, fungisida sesuai label.',
      'Virus mosaik|Virus|Daun belang dan kerdil.|Cabut tanaman sakit, kendalikan kutu daun.',
    ],
    care: [
      'Pasang lanjaran sejak umur 2 minggu.',
      'Siram teratur terutama saat berbunga.',
      'Petik polong muda secara rutin agar produksi berlanjut.',
    ],
    harvest:
        'Mulai 50 sampai 60 hari. Petik polong muda sebelum biji menonjol, tiap 2 sampai 3 hari.',
  ),

  // -------------------------------------------------------------- PANGAN
  'jagung': _g(
    ph: [5.6, 7.5],
    best: [10, 11, 3, 4],
    ok: [12, 5, 6, 7],
    soil: 'Lempung gembur, drainase baik, subur.',
    alt: '0 sampai 1.300 mdpl',
    water: 'Cukup, terutama saat berbunga dan pengisian biji.',
    sun: 'Penuh.',
    space: '75 × 20 cm (1 biji per lubang)',
    fert: [
      'Urea|300 sampai 400 kg per ha, 2 sampai 3 tahap (7 sampai 10, 25 sampai 30, dan 40 hari).|300|400|kg/ha',
      'SP-36|100 sampai 150 kg per ha sebagai pupuk dasar.|100|150|kg/ha',
      'KCl|Sekitar 100 kg per ha.|100|100|kg/ha',
      'Pupuk kandang|2 sampai 5 ton per ha untuk memperbaiki tanah.|2|5|ton/ha',
    ],
    prob: [
      'Bulai (Peronosclerospora)|Jamur|Garis putih kekuningan pada daun, tanaman kerdil.|Benih tahan dan berlapis fungisida, musnahkan tanaman sakit, tanam serempak.',
      'Ulat grayak (Spodoptera frugiperda)|Hama|Daun berlubang, kotoran di pucuk.|Pantau dini, Bt atau insektisida nabati, tumpangsari.',
      'Hawar daun (Helminthosporium)|Jamur|Bercak lonjong cokelat memanjang di daun.|Varietas tahan, fungisida bila serangan berat.',
    ],
    care: [
      'Tanam serempak dengan petani sekitar untuk menekan hama.',
      'Lakukan penyiangan dan pembumbunan pada 2 sampai 4 minggu.',
      'Pastikan air cukup saat bunga jantan dan betina muncul.',
      'Pupuk nitrogen diberikan bertahap, bukan sekaligus.',
    ],
    harvest:
        'Umur 90 sampai 110 hari. Panen saat klobot menguning dan biji keras; jemur sampai kadar air sekitar 14 persen.',
  ),
  'padi': _g(
    ph: [5.5, 7.0],
    best: [11, 12, 3, 4],
    ok: [1, 7, 8],
    soil: 'Lempung liat sawah, mampu menahan air.',
    alt: '0 sampai 1.200 mdpl (optimal 0 sampai 650)',
    water: 'Tinggi; gunakan pengairan berselang untuk hemat air.',
    sun: 'Penuh.',
    space: 'Jajar legowo 2:1 (25 × 12,5 × 50 cm)',
    fert: [
      'Urea|200 sampai 250 kg per ha, 3 tahap (7 sampai 10, 25 sampai 30, dan 40 sampai 45 hari).|200|250|kg/ha',
      'SP-36|75 sampai 100 kg per ha sebagai pupuk dasar.|75|100|kg/ha',
      'KCl|50 sampai 100 kg per ha.|50|100|kg/ha',
      'Pupuk organik / jerami|Sekitar 2 ton per ha untuk memperbaiki tanah.|2|2|ton/ha',
    ],
    prob: [
      'Blas (Pyricularia)|Jamur|Bercak belah ketupat pada daun; leher malai patah.|Varietas tahan, kurangi N berlebih, fungisida sesuai label.',
      'Wereng cokelat|Hama|Tanaman mengering melingkar (hopperburn).|Varietas tahan, pengairan berselang, hindari insektisida berlebihan.',
      'Tungro|Virus|Daun kuning-jingga, tanaman kerdil.|Tanam serempak, varietas tahan, kendalikan wereng hijau.',
    ],
    care: [
      'Gunakan benih bersertifikat dan rendam sebelum semai.',
      'Atur air: macak-macak awal, tergenang tipis saat anakan, keringkan menjelang panen.',
      'Siang gulma pada 3 dan 6 minggu setelah tanam.',
      'Pantau hama dan penyakit tiap pekan.',
    ],
    harvest:
        'Umur 105 sampai 125 hari, saat 90 persen bulir menguning. Keringkan gabah sampai kadar air sekitar 14 persen.',
  ),
  'kedelai': _g(
    ph: [5.8, 7.0],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9],
    soil: 'Lempung berpasir, gembur, drainase baik.',
    alt: '0 sampai 900 mdpl',
    water:
        'Sedang; peka genangan, butuh air saat berbunga dan pengisian polong.',
    sun: 'Penuh.',
    space: '40 × 15 cm (2 biji per lubang)',
    fert: [
      'SP-36|75 sampai 100 kg per ha sebagai pupuk dasar.|75|100|kg/ha',
      'KCl|50 sampai 75 kg per ha.|50|75|kg/ha',
      'Urea|25 sampai 50 kg per ha sebagai starter; selebihnya dari bintil akar.|25|50|kg/ha',
      'Inokulum Rhizobium / kapur|Bantu bintil akar; kapur bila tanah masam.',
    ],
    prob: [
      'Karat daun (Phakopsora)|Jamur|Bintik cokelat kemerahan di bawah daun.|Varietas tahan, fungisida sesuai label.',
      'Penggerek polong (Etiella)|Hama|Polong berlubang, biji rusak.|Tanam serempak, pantau saat pembentukan polong.',
      'Pengisap polong (Riptortus)|Hama|Biji kempes dan bercak.|Sanitasi gulma, insektisida sesuai ambang.',
    ],
    care: [
      'Tanam setelah padi dengan olah tanah minimal untuk menghemat biaya.',
      'Siang gulma pada 14 dan 30 hari.',
      'Buat parit drainase agar tidak tergenang.',
    ],
    harvest:
        'Umur 80 sampai 90 hari, saat 95 persen polong menguning kecokelatan.',
  ),
  'kacangtanah': _g(
    ph: [5.5, 6.5],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9, 10],
    soil: 'Lempung berpasir gembur, kaya kalsium.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Sedang; jangan tergenang saat polong terbentuk.',
    sun: 'Penuh.',
    space: '40 × 10 sampai 15 cm',
    fert: [
      'SP-36|Sekitar 100 kg per ha.|100|100|kg/ha',
      'KCl|50 sampai 100 kg per ha.|50|100|kg/ha',
      'Kapur pertanian / gipsum|300 sampai 500 kg per ha saat berbunga untuk pengisian polong.|300|500|kg/ha',
      'Urea|25 sampai 50 kg per ha sebagai starter.|25|50|kg/ha',
    ],
    prob: [
      'Bercak daun (Cercospora)|Jamur|Bercak cokelat bulat pada daun, daun gugur.|Rotasi, fungisida sesuai label.',
      'Busuk batang (Sclerotium)|Jamur|Pangkal batang busuk dengan miselium putih.|Drainase, rotasi, cabut tanaman sakit.',
      'Aflatoksin (Aspergillus)|Jamur|Biji berjamur saat penyimpanan.|Keringkan cepat, simpan kering dan bersih.',
    ],
    care: [
      'Bumbun saat 30 hari agar ginofor mudah menembus tanah.',
      'Jaga tanah tetap gembur.',
      'Siang gulma secara hati-hati agar tidak melukai ginofor.',
    ],
    harvest:
        'Umur 90 sampai 100 hari. Keringkan polong sampai kadar air 9 persen atau kurang.',
  ),
  'ubijalar': _g(
    ph: [5.5, 6.5],
    best: [4, 5, 6, 10, 11],
    ok: [3, 7, 8, 9, 12],
    soil: 'Gembur dan berpasir, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Sedang; kurangi menjelang panen.',
    sun: 'Penuh.',
    space: '100 × 25 cm (guludan)',
    fert: [
      'Pupuk kandang|Sekitar 10 ton per ha sebagai pupuk dasar.|10|10|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha.|200|300|kg/ha',
      'KCl|100 sampai 150 kg per ha untuk pembesaran umbi.|100|150|kg/ha',
      'Hindari N berlebih|Terlalu banyak N membuat daun lebat, umbi kecil.',
    ],
    prob: [
      'Boleng / lanas (Cylas formicarius)|Hama|Umbi berlubang dan terasa pahit.|Bumbun tinggi, rotasi, perangkap feromon, panen tepat waktu.',
      'Kudis (Sphaceloma)|Jamur|Bercak kasar pada batang dan daun.|Stek sehat, rotasi.',
      'Busuk batang (Fusarium)|Jamur|Batang busuk dan layu.|Stek bebas penyakit, drainase baik.',
    ],
    care: [
      'Gunakan stek pucuk sepanjang 25 sampai 30 cm.',
      'Buat guludan agar umbi mudah membesar dan dipanen.',
      'Tutup retakan tanah agar boleng sulit masuk.',
    ],
    harvest:
        'Umur 3,5 sampai 4 bulan, saat daun menguning. Panen di tanah kering.',
  ),
  'singkong': _g(
    ph: [5.5, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 3, 4],
    soil: 'Gembur, berpasir sampai lempung; toleran tanah kurang subur.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Rendah sampai sedang; tidak tahan genangan.',
    sun: 'Penuh.',
    space: '100 × 80 cm',
    fert: [
      'Pupuk kandang|5 sampai 10 ton per ha sebagai pupuk dasar.|5|10|ton/ha',
      'NPK 16-16-16|150 sampai 250 kg per ha.|150|250|kg/ha',
      'Urea|100 sampai 150 kg per ha, 2 kali.|100|150|kg/ha',
      'KCl|Sekitar 100 kg per ha untuk meningkatkan pati.|100|100|kg/ha',
    ],
    prob: [
      'Hawar bakteri (Xanthomonas)|Bakteri|Bercak bersudut basah, daun layu.|Stek sehat, rotasi, sanitasi.',
      'Tungau merah dan kutu putih|Hama|Daun menguning bercak, pucuk kerdil.|Neem, musuh alami, tanam sesuai musim.',
      'Busuk akar|Jamur|Akar dan umbi busuk.|Drainase baik, hindari lahan tergenang.',
    ],
    care: [
      'Gunakan stek batang sehat 20 sampai 25 cm, 5 sampai 7 ruas.',
      'Siang gulma pada 1 dan 2 bulan.',
      'Tumpangsari dengan kacang-kacangan menambah pendapatan.',
    ],
    harvest:
        'Umur 8 sampai 12 bulan, tergantung varietas. Panen saat kadar pati tinggi.',
  ),

  // ---------------------------------------------------------------- BUAH
  'semangka': _g(
    ph: [6.0, 7.0],
    best: [5, 6, 7, 8],
    ok: [4, 9],
    soil: 'Lempung berpasir, gembur, drainase baik.',
    alt: '0 sampai 800 mdpl',
    water: 'Cukup saat tumbuh; kurangi menjelang panen agar manis.',
    sun: 'Penuh, sangat butuh sinar.',
    space: '200 × 60 sampai 100 cm',
    fert: [
      'Pupuk kandang / kompos|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|250 sampai 300 kg per ha, bertahap.|250|300|kg/ha',
      'KCl / ZK|Berikan saat pembentukan buah untuk kemanisan.',
      'Batasi N|N berlebih saat berbuah membuat rasa kurang manis.',
    ],
    prob: [
      'Layu fusarium|Jamur|Tanaman layu dari satu sisi, batang pecah.|Rotasi, bibit sehat, tanah tidak terlalu basah.',
      'Embun tepung dan antraknosa|Jamur|Bercak putih atau cekung pada daun dan buah.|Fungisida sesuai label, sirkulasi udara.',
      'Kutu daun dan lalat buah|Hama|Daun keriting; buah cacat.|Perangkap, bungkus buah.',
    ],
    care: [
      'Gunakan mulsa plastik hitam-perak.',
      'Sisakan 1 sampai 2 buah per tanaman.',
      'Alasi buah dengan jerami agar tidak busuk.',
      'Atur sulur agar tidak kusut.',
    ],
    harvest:
        'Umur 65 sampai 80 hari, saat tangkai dan sulur dekat buah mengering, bunyi berdengung.',
  ),
  'melon': _g(
    ph: [6.0, 6.8],
    best: [5, 6, 7, 8],
    ok: [4, 9],
    soil: 'Lempung berpasir, gembur, drainase baik.',
    alt: '0 sampai 900 mdpl',
    water: 'Teratur dan terukur; kurangi saat buah matang.',
    sun: 'Penuh.',
    space: '100 × 50 cm dengan lanjaran',
    fert: [
      'Kompos / pupuk kandang|10 sampai 15 ton per ha sebagai pupuk dasar.|10|15|ton/ha',
      'NPK 16-16-16|Bertahap; naikkan kalium saat pembentukan buah.',
      'KCl / ZK|Mendukung kemanisan dan tekstur.',
      'Kalsium|Menguatkan kulit dan mengurangi pecah buah.',
    ],
    prob: [
      'Layu fusarium|Jamur|Tanaman layu dan batang berlendir.|Media bersih, rotasi, bibit sehat.',
      'Embun tepung|Jamur|Lapisan putih tepung di daun.|Sirkulasi udara, fungisida sesuai label.',
      'Tungau dan kutu kebul|Hama|Daun menguning keperakan.|Perangkap, neem, pantau rutin.',
    ],
    care: [
      'Budidaya di rumah plastik meningkatkan kualitas.',
      'Wiwil tunas samping hingga ruas 8 sampai 10.',
      'Seleksi 1 buah per tanaman.',
      'Kurangi air saat buah mulai membentuk jaring.',
    ],
    harvest: 'Umur 60 sampai 75 hari, saat jaring merata dan aroma harum.',
  ),
  'pepaya': _g(
    ph: [6.0, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 3],
    trees: 2500,
    soil: 'Lempung gembur, drainase sangat baik.',
    alt: '0 sampai 700 mdpl',
    water: 'Sedang; sangat peka genangan.',
    sun: 'Penuh.',
    space: '2 × 2 m',
    fert: [
      'Pupuk kandang|10 sampai 20 kg per pohon sebagai pupuk dasar.|10|20|kg/pohon',
      'NPK 16-16-16|100 sampai 200 g per pohon tiap 2 sampai 3 bulan.|100|200|g/pohon/kali',
      'Kalium|Tambah saat berbuah untuk kualitas.',
      'Boron|Cukupi untuk mengurangi buah cacat.',
    ],
    prob: [
      'Virus bercak cincin (PRSV)|Virus|Daun mosaik, cincin pada buah.|Cabut tanaman sakit, kendalikan kutu daun, bibit sehat.',
      'Busuk pangkal batang (Phytophthora)|Jamur|Pangkal batang busuk basah, tanaman layu.|Drainase baik, bumbun, hindari luka.',
      'Antraknosa|Jamur|Bercak cekung pada buah.|Panen tepat waktu, fungisida sesuai label.',
    ],
    care: [
      'Tanam 2 sampai 3 bibit per lubang, pertahankan yang betina atau hermafrodit.',
      'Siang gulma di sekitar batang.',
      'Pastikan tanah tidak menggenang.',
    ],
    harvest:
        'Mulai 8 sampai 10 bulan. Panen saat 1 sampai 2 garis kuning muncul di kulit.',
  ),
  'pisang': _g(
    ph: [5.5, 7.0],
    best: [10, 11, 12],
    ok: [1, 2, 3, 4],
    trees: 1111,
    soil: 'Lempung gembur kaya bahan organik, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Tinggi dan merata; tidak tahan genangan.',
    sun: 'Penuh sampai teduh ringan.',
    space: '3 × 3 m (atau 2,5 × 2,5 m)',
    fert: [
      'Pupuk kandang|10 sampai 20 kg per rumpun sebagai pupuk dasar.|10|20|kg/pohon',
      'NPK 16-16-16|100 sampai 200 g per rumpun tiap 2 sampai 3 bulan.|100|200|g/pohon/kali',
      'KCl|Pisang butuh banyak kalium untuk pengisian tandan.',
    ],
    prob: [
      'Layu fusarium (Panama)|Jamur|Daun tua menguning dan patah, batang busuk dalam.|Bibit bebas penyakit, musnahkan rumpun sakit, jangan pindahkan tanah.',
      'Layu bakteri (darah)|Bakteri|Daun layu, getah kemerahan di bonggol.|Sanitasi alat, musnahkan rumpun, bunga jantan dipotong.',
      'Bercak daun (sigatoka)|Jamur|Bercak cokelat memanjang di daun.|Buang daun sakit, jarak tanam longgar.',
    ],
    care: [
      'Sisakan 2 sampai 3 anakan per rumpun.',
      'Buang daun kering dan sanitasi rumpun.',
      'Bungkus tandan dan beri penyangga agar tidak rebah.',
    ],
    harvest:
        'Umur 9 sampai 12 bulan, saat buah bulat dan sudut mulai membulat.',
  ),
  'nanas': _g(
    ph: [4.5, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 3, 4],
    calNote:
        'Panen sekitar 14 sampai 18 bulan setelah tanam. Induksi pembungaan membantu panen lebih serempak.',
    soil: 'Lempung berpasir, drainase sangat baik; toleran masam.',
    alt: '0 sampai 800 mdpl',
    water: 'Rendah sampai sedang; tidak tahan genangan.',
    sun: 'Penuh.',
    space: '60 × 30 × 30 cm (zig-zag)',
    fert: [
      'Pupuk kandang|Sekitar 10 ton per ha sebagai pupuk dasar.|10|10|ton/ha',
      'NPK / Urea|Dibagi 4 sampai 5 kali selama pertumbuhan.',
      'Kalium dan magnesium|Mendukung ukuran dan rasa buah.',
    ],
    prob: [
      'Busuk hati / akar (Phytophthora)|Jamur|Daun muda layu dan mudah dicabut, pangkal busuk.|Drainase baik, bibit sehat.',
      'Layu kutu putih (mealybug wilt)|Hama|Daun memerah dan layu.|Kendalikan kutu putih dan semut.',
      'Busuk pangkal buah|Jamur|Pangkal buah lunak, berbau.|Hindari luka saat panen.',
    ],
    care: [
      'Gunakan mahkota atau tunas sehat sebagai bibit.',
      'Mulsa menekan gulma dan menjaga kelembapan.',
      'Induksi pembungaan agar panen serempak.',
    ],
    harvest:
        'Umur 14 sampai 18 bulan, saat mata buah mulai menguning dari pangkal.',
  ),

  // ---------------------------------------------------------- PERKEBUNAN
  'kopi': _g(
    ph: [5.5, 6.5],
    best: [11, 12],
    ok: [10, 1, 2],
    trees: 1600,
    calNote:
        'Tanaman tahunan: tanam di awal musim hujan. Panen raya biasanya setahun sekali, waktunya berbeda menurut ketinggian dan daerah. Populasi dihitung dari jarak Arabika; Robusta sekitar 1.100 pohon per ha.',
    soil: 'Andosol atau lempung gembur, subur, kaya bahan organik.',
    alt: 'Arabika 1.000 sampai 1.800 mdpl; Robusta 300 sampai 800 mdpl',
    water:
        'Curah hujan 1.500 sampai 2.500 mm per tahun dengan 2 sampai 3 bulan kering.',
    sun: 'Perlu naungan 30 sampai 50 persen (lamtoro, dadap).',
    space: 'Arabika 2,5 × 2,5 m; Robusta 3 × 3 m',
    fert: [
      'Pupuk kandang / kompos|10 sampai 20 kg per pohon per tahun.|10|20|kg/pohon/thn',
      'NPK 16-16-16|Sekitar 150 sampai 300 g per pohon per tahun, dibagi 2 kali (awal dan akhir musim hujan).|150|300|g/pohon/thn',
      'Dolomit|Bila pH di bawah 5,0, berikan 0,5 sampai 1 kg per pohon.|0.5|1|kg/pohon',
    ],
    prob: [
      'Karat daun (Hemileia vastatrix)|Jamur|Bintik oranye di bawah daun, daun gugur.|Varietas tahan, naungan, pemupukan cukup, fungisida tembaga.',
      'Penggerek buah kopi (PBKo)|Hama|Buah berlubang kecil, biji rusak.|Petik bubuk, lelesan (ambil buah jatuh), perangkap.',
      'Jamur akar|Jamur|Pohon layu, akar membusuk.|Drainase baik, bongkar pohon sakit.',
    ],
    care: [
      'Pangkas bentuk dan produksi secara teratur.',
      'Jaga pohon naungan agar mutu dan kelembapan terjaga.',
      'Beri mulsa di sekitar pohon.',
      'Lakukan sanitasi buah dan ranting sakit.',
    ],
    harvest:
        'Panen selektif buah merah. Olah segera setelah petik (basah atau kering) dan jemur sampai kadar air sekitar 12 persen.',
  ),
  'kakao': _g(
    ph: [6.0, 7.0],
    best: [11, 12],
    ok: [10, 1, 2],
    trees: 1111,
    calNote:
        'Tanaman tahunan: tanam di awal musim hujan. Biasanya ada panen raya dan panen sela dalam setahun, waktunya mengikuti curah hujan daerah.',
    soil: 'Lempung dalam, subur, drainase baik.',
    alt: '0 sampai 600 mdpl',
    water: 'Curah hujan 1.500 sampai 2.500 mm per tahun, merata.',
    sun: 'Perlu naungan, terutama saat muda.',
    space: '3 × 3 m',
    fert: [
      'Pupuk kandang / kompos|10 sampai 15 kg per pohon per tahun.|10|15|kg/pohon/thn',
      'NPK 16-16-16|Sekitar 100 sampai 300 g per pohon per tahun, dibagi 2 kali.|100|300|g/pohon/thn',
      'Dolomit|Bila tanah masam.',
    ],
    prob: [
      'Busuk buah (Phytophthora palmivora)|Jamur|Bercak cokelat basah pada buah, lalu busuk.|Panen sering, buang buah sakit, pangkas agar tidak terlalu lembap.',
      'Penggerek buah kakao (PBK)|Hama|Biji lengket, buah masak awal.|Panen sering, sarungisasi buah, pangkas.',
      'VSD (Vascular Streak Dieback)|Jamur|Daun menguning sepasang pada ranting.|Pangkas ranting 30 cm di bawah gejala.',
    ],
    care: [
      'Pangkas dan atur naungan.',
      'Sanitasi buah busuk dan kulit buah.',
      'Fermentasi biji 5 sampai 6 hari untuk mutu dan harga lebih baik.',
    ],
    harvest: 'Panen tiap 1 sampai 2 minggu saat buah menguning atau memerah.',
  ),
  'karet': _g(
    ph: [5.0, 6.5],
    best: [11, 12],
    ok: [10, 1, 2],
    trees: 555,
    calNote:
        'Tanaman tahunan: tanam di awal musim hujan. Sadap bisa sepanjang tahun; hasil turun saat gugur daun dan hujan lebat.',
    soil: 'Lempung berpasir dalam, drainase baik.',
    alt: '0 sampai 400 mdpl (hingga 600)',
    water: 'Curah hujan 2.000 sampai 3.000 mm per tahun.',
    sun: 'Penuh.',
    space: '6 × 3 m atau 7 × 3 m',
    fert: [
      'NPK 16-16-16 (tanaman muda)|Sekitar 100 sampai 200 g per pohon per tahun, bertahap.|100|200|g/pohon/thn',
      'NPK 16-16-16 (tanaman menghasilkan)|Sekitar 250 sampai 400 g per pohon per tahun, 2 kali.|250|400|g/pohon/thn',
      'Pupuk organik|Perbaiki struktur tanah di piringan.',
    ],
    prob: [
      'Jamur akar putih (Rigidoporus)|Jamur|Daun layu, akar membusuk dengan miselium putih.|Bongkar akar sakit, beri Trichoderma atau belerang.',
      'Gugur daun (Colletotrichum)|Jamur|Daun muda gugur, bercak cokelat.|Pemupukan cukup, fungisida bila perlu.',
      'Kering alur sadap (KAS)|Fisiologis|Alur sadap mengering dan tidak mengeluarkan lateks.|Istirahatkan sadap, kurangi intensitas.',
    ],
    care: [
      'Sadap pagi (sekitar 05.00 sampai 07.00) dengan kemiringan 30 sampai 40 derajat.',
      'Jangan menyadap terlalu dalam.',
      'Jaga kebersihan piringan dan mutu lateks.',
    ],
    harvest:
        'Mulai sadap umur 5 sampai 6 tahun. Bekukan lateks dengan benar agar mutu terjaga.',
  ),
  'sawit': _g(
    ph: [4.0, 6.0],
    best: [10, 11, 12],
    ok: [1, 2],
    trees: 143,
    calNote:
        'Tanaman tahunan: tanam di awal musim hujan. Panen sepanjang tahun tiap 7 sampai 14 hari; produksi naik turun mengikuti curah hujan.',
    soil: 'Tanah mineral atau gambut dalam, drainase baik.',
    alt: '0 sampai 400 mdpl',
    water: 'Curah hujan 2.000 sampai 2.500 mm per tahun, merata.',
    sun: 'Penuh.',
    space: 'Segitiga sama sisi 9 m',
    fert: [
      'Urea / ZA|1,5 sampai 2,5 kg per pohon per tahun untuk tanaman menghasilkan, dibagi 2 kali.|1.5|2.5|kg/pohon/thn',
      'KCl (MOP)|2 sampai 3 kg per pohon per tahun.|2|3|kg/pohon/thn',
      'Kieserit (magnesium)|1 sampai 1,5 kg per pohon per tahun.|1|1.5|kg/pohon/thn',
      'Borat|100 sampai 200 g per pohon per tahun.|100|200|g/pohon/thn',
    ],
    prob: [
      'Busuk pangkal batang (Ganoderma)|Jamur|Pelepah patah, tubuh buah jamur di pangkal batang.|Sanitasi, bongkar pohon sakit, parit isolasi.',
      'Ulat api dan ulat kantong|Hama|Daun habis dimakan.|Pantau, Bt, musuh alami.',
      'Kumbang tanduk (Oryctes)|Hama|Pucuk muda tergerek.|Sanitasi tumpukan batang, perangkap feromon.',
    ],
    care: [
      'Pangkas pelepah songgo dua.',
      'Jaga piringan bersih dan jalan panen.',
      'Rawat parit dan drainase.',
    ],
    harvest:
        'Panen TBS matang (minimal 2 brondolan jatuh) dan kirim ke pabrik dalam 24 jam.',
  ),
  'tebu': _g(
    ph: [6.0, 7.5],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    calNote:
        'Masa tanam sampai tebang sekitar 12 bulan. Tebang dilakukan pada musim giling (musim kemarau).',
    soil: 'Lempung gembur, subur, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Tinggi saat tumbuh, kurangi menjelang tebang.',
    sun: 'Penuh.',
    space: 'Jarak antar baris 135 sampai 150 cm',
    fert: [
      'ZA|400 sampai 600 kg per ha, 2 sampai 3 tahap.|400|600|kg/ha',
      'SP-36|100 sampai 200 kg per ha.|100|200|kg/ha',
      'KCl|100 sampai 200 kg per ha.|100|200|kg/ha',
    ],
    prob: [
      'Pokahbung|Jamur|Pucuk membusuk, daun muda keriput.|Varietas tahan, fungisida bila serangan berat.',
      'Penggerek batang dan pucuk|Hama|Lubang pada batang, pucuk mati.|Sanitasi, musuh alami (parasitoid).',
      'Luka api (smut)|Jamur|Pucuk berbentuk cambuk hitam.|Cabut rumpun sakit, bibit sehat.',
    ],
    care: [
      'Gunakan bibit bagal 2 sampai 3 mata.',
      'Kletek (buang daun kering) untuk mengurangi hama.',
      'Lakukan keprasan 2 sampai 3 kali untuk menghemat bibit.',
    ],
    harvest: 'Umur 10 sampai 12 bulan, saat rendemen optimum.',
  ),

  // -------------------------------------------------------------- REMPAH
  'jahe': _g(
    ph: [5.5, 7.0],
    best: [10, 11, 12],
    ok: [9, 1, 2],
    soil: 'Gembur, kaya bahan organik, drainase baik.',
    alt: '200 sampai 900 mdpl',
    water: 'Sedang dan teratur.',
    sun: 'Penuh sampai naungan ringan.',
    space: '40 × 30 cm',
    fert: [
      'Pupuk kandang|20 sampai 30 ton per ha sebagai pupuk dasar.|20|30|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha, bertahap.|300|400|kg/ha',
      'KCl|Dukung pembentukan rimpang.',
    ],
    prob: [
      'Busuk rimpang (Fusarium / Ralstonia)|Jamur / Bakteri|Daun menguning dan layu, rimpang busuk.|Bibit sehat, drainase baik, rotasi, cabut tanaman sakit.',
      'Bercak daun|Jamur|Bercak cokelat pada daun.|Sanitasi, jarak tanam longgar.',
      'Lalat rimpang|Hama|Rimpang berlubang.|Rotasi, sanitasi lahan.',
    ],
    care: [
      'Pakai rimpang bibit 2 sampai 3 mata tunas, sekitar 25 sampai 40 g.',
      'Beri mulsa jerami dan lakukan pembumbunan.',
      'Beri naungan ringan pada awal pertumbuhan.',
    ],
    harvest:
        'Panen 8 sampai 10 bulan untuk jahe muda, 10 sampai 12 bulan untuk jahe tua.',
  ),
  'kunyit': _g(
    ph: [5.0, 7.5],
    best: [10, 11, 12],
    ok: [9, 1, 2],
    soil: 'Gembur dan subur, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Sedang; toleran naungan.',
    sun: 'Penuh sampai naungan ringan.',
    space: '50 × 40 cm',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha.|10|20|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha, bertahap.|200|300|kg/ha',
      'KCl|Dukung pembesaran rimpang.',
    ],
    prob: [
      'Bercak daun (Colletotrichum)|Jamur|Bercak cokelat pada daun.|Sanitasi daun sakit, fungisida bila parah.',
      'Busuk rimpang|Jamur / Bakteri|Rimpang lunak dan berbau.|Drainase baik, bibit sehat.',
      'Penggulung daun|Hama|Daun menggulung dan rusak.|Buang daun terserang.',
    ],
    care: [
      'Beri mulsa jerami agar tanah lembap.',
      'Lakukan pembumbunan saat tanaman berumur 2 sampai 3 bulan.',
      'Cocok di antara pohon buah dengan naungan ringan.',
    ],
    harvest: 'Umur 9 sampai 12 bulan, saat daun menguning dan mengering.',
  ),
  'lada': _g(
    ph: [5.5, 6.5],
    best: [11, 12],
    ok: [10, 1, 2],
    trees: 2500,
    calNote:
        'Tanaman tahunan: tanam di awal musim hujan. Panen umumnya sekali setahun, waktunya berbeda menurut daerah.',
    soil: 'Lempung gembur, subur, drainase baik.',
    alt: '0 sampai 700 mdpl',
    water: 'Curah hujan 2.000 sampai 3.000 mm per tahun; tidak tahan genangan.',
    sun: 'Naungan ringan.',
    space: '2 × 2 m dengan tiang panjat',
    fert: [
      'Pupuk kandang|Sekitar 10 kg per pohon per tahun.|10|10|kg/pohon/thn',
      'NPK 16-16-16|150 sampai 300 g per pohon per tahun, dibagi 2 sampai 3 kali.|150|300|g/pohon/thn',
      'Dolomit|Bila tanah masam.',
    ],
    prob: [
      'Busuk pangkal batang (Phytophthora capsici)|Jamur|Layu mendadak, pangkal batang busuk.|Drainase baik, hindari luka, Trichoderma, cabut tanaman sakit.',
      'Penyakit kuning (nematoda)|Hama|Daun menguning, pertumbuhan terhambat.|Bahan organik, bibit sehat.',
      'Penggerek batang|Hama|Batang berlubang dan layu.|Buang bagian terserang.',
    ],
    care: [
      'Pasang tiang panjat dan ikat sulur.',
      'Pangkas sulur cacing agar produksi meningkat.',
      'Beri mulsa untuk menjaga kelembapan.',
    ],
    harvest:
        'Panen saat buah mulai kuning kemerahan, sekitar 8 sampai 9 bulan setelah berbunga. Jemur sampai kering merata.',
  ),
  'serai': _g(
    ph: [5.0, 6.5],
    best: [10, 11, 12, 1],
    ok: [2, 3, 9],
    soil: 'Gembur, drainase baik; toleran tanah kurang subur.',
    alt: '0 sampai 1.200 mdpl',
    water: 'Sedang.',
    sun: 'Penuh.',
    space: '100 × 50 cm',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha.|10|20|ton/ha',
      'Urea|100 sampai 200 kg per ha, bagi dalam beberapa kali setelah tiap panen.|100|200|kg/ha',
      'NPK|Tambahan bila hasil daun kurang.',
    ],
    prob: [
      'Bercak daun (Curvularia)|Jamur|Bercak cokelat pada daun.|Sanitasi dan jarak tanam longgar.',
      'Karat daun|Jamur|Bintik oranye di daun.|Buang daun sakit, fungisida bila parah.',
      'Busuk pangkal|Jamur|Pangkal rumpun busuk.|Drainase baik.',
    ],
    care: [
      'Tanam anakan rumpun yang sehat.',
      'Panen pertama 4 sampai 6 bulan, berikutnya tiap 3 sampai 4 bulan.',
      'Sulingkan segera setelah panen untuk mutu minyak.',
    ],
    harvest:
        'Potong daun 10 sampai 15 cm di atas tanah. Segera sulingkan atau layukan sebentar.',
  ),
  'bawangputih': _g(
    ph: [6.0, 7.0],
    best: [4, 5, 6],
    ok: [3, 7, 8],
    soil: 'Lempung berpasir, gembur, bahan organik tinggi, drainase baik.',
    alt: '700 sampai 1.200 mdpl',
    water: 'Sedang; kurangi menjelang panen agar umbi kering.',
    sun: 'Penuh.',
    space: '20 × 15 cm',
    fert: [
      'Pupuk kandang|15 sampai 25 ton per ha sebagai pupuk dasar.|15|25|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha, dibagi dua kali pemberian.|200|300|kg/ha',
      'KCl|80 sampai 120 kg per ha saat pembentukan umbi.|80|120|kg/ha',
    ],
    prob: [
      'Bercak ungu (Alternaria)|Jamur|Bercak keunguan pada daun, daun mengering.|Rotasi tanaman, sanitasi, fungisida sesuai label.',
      'Layu Fusarium|Jamur|Daun menguning dari ujung, umbi busuk.|Cabut tanaman sakit, rotasi minimal 2 tahun.',
      'Ulat bawang|Hama|Daun berlubang dan terlipat.|Ambil manual, sanitasi lahan, insektisida bila parah.',
    ],
    care: [
      'Pilih siung bibit yang padat dan bebas cacat.',
      'Siram teratur namun berhenti 1 sampai 2 minggu sebelum panen.',
      'Bersihkan gulma dengan hati-hati karena akar dangkal.',
    ],
    harvest:
        'Panen 90 sampai 120 hari setelah tanam saat 60 persen daun menguning dan rebah. Angkat umbi, ikat, lalu keringkan 2 sampai 3 minggu.',
  ),
  'kangkung': _g(
    ph: [5.5, 7.0],
    best: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    ok: [],
    soil: 'Hampir semua tanah; subur dan lembap lebih baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Banyak; jaga tanah selalu lembap.',
    sun: 'Penuh hingga teduh ringan.',
    space: '20 × 15 cm atau sebar rata',
    fert: [
      'Kompos|5 sampai 10 ton per ha sebagai pupuk dasar.|5|10|ton/ha',
      'Urea|50 sampai 100 kg per ha setelah tiap panen potong.|50|100|kg/ha',
    ],
    prob: [
      'Bercak daun (Cercospora)|Jamur|Bercak cokelat pada daun.|Sanitasi, jarak tanam longgar.',
      'Karat putih|Jamur|Bintik putih di bawah daun.|Buang daun sakit, rotasi.',
      'Ulat grayak|Hama|Daun berlubang besar.|Ambil manual, insektisida nabati.',
    ],
    care: [
      'Bisa ditanam sepanjang tahun asal air tersedia.',
      'Panen potong menyisakan 2 sampai 3 buku untuk panen berikutnya.',
      'Siram tiap hari pada musim kemarau.',
    ],
    harvest:
        'Panen pertama 25 sampai 30 hari setelah tanam dengan cara potong atau cabut. Panen potong berulang tiap 10 sampai 14 hari.',
  ),
  'buncis': _g(
    ph: [6.0, 7.0],
    best: [4, 5, 6, 7],
    ok: [3, 8, 9],
    soil: 'Lempung gembur, drainase baik.',
    alt: '0 sampai 1.500 mdpl',
    water: 'Sedang; hindari genangan.',
    sun: 'Penuh.',
    space: '70 × 20 cm (merambat) atau 50 × 20 cm (tegak)',
    fert: [
      'Kompos|10 sampai 15 ton per ha sebagai pupuk dasar.|10|15|ton/ha',
      'NPK 16-16-16|150 sampai 250 kg per ha, dibagi dua kali.|150|250|kg/ha',
    ],
    prob: [
      'Karat daun|Jamur|Bintik oranye di bawah daun.|Sanitasi, rotasi, fungisida sesuai label.',
      'Antraknosa|Jamur|Bercak cokelat pada polong dan biji.|Benih sehat, rotasi tanaman.',
      'Lalat bibit|Hama|Lubang pada kecambah dan batang muda.|Perlakuan benih, tanam serempak.',
    ],
    care: [
      'Pasang ajir segera untuk tipe merambat.',
      'Petik polong muda secara rutin agar pembungaan berlanjut.',
      'Hindari bekerja di kebun saat daun basah untuk menekan penyakit.',
    ],
    harvest:
        'Panen 45 sampai 55 hari setelah tanam; petik polong muda tiap 2 sampai 3 hari sekali.',
  ),
  'mangga': _g(
    ph: [5.5, 7.0],
    best: [6, 7, 8],
    ok: [5, 9],
    soil: 'Lempung dalam, drainase baik, tidak tergenang.',
    alt: '0 sampai 700 mdpl',
    water: 'Sedang; musim kering memicu pembungaan.',
    sun: 'Penuh.',
    space: '10 × 10 m',
    trees: 100,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 2 kg per pohon per tahun, dibagi dua kali.|1|2|kg/pohon/thn',
    ],
    prob: [
      'Antraknosa|Jamur|Bercak hitam pada daun, bunga, dan buah.|Sanitasi tajuk, fungisida saat berbunga.',
      'Busuk batang Diplodia|Jamur|Luka berlendir dan getah pada batang.|Sanitasi luka, oles fungisida.',
      'Lalat buah|Hama|Buah berlubang dan gugur muda.|Perangkap atraktan, bungkus buah.',
    ],
    care: [
      'Pangkas setelah panen agar tajuk terbuka dan sinar masuk.',
      'Bungkus buah muda dengan kertas untuk kulit yang mulus.',
      'Jaga drainase; akar mangga tidak tahan genangan lama.',
    ],
    harvest:
        'Panen 90 sampai 120 hari setelah berbunga tergantung varietas; petik matang pohon dengan menyisakan tangkai 5 sampai 10 cm.',
  ),
  'alpukat': _g(
    ph: [5.5, 6.5],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung dalam, drainase sangat baik; tidak tahan akar tergenang.',
    alt: '300 sampai 1.500 mdpl',
    water: 'Sedang dan merata sepanjang tahun.',
    sun: 'Penuh; teduh ringan saat masih bibit.',
    space: '10 × 10 m',
    trees: 100,
    fert: [
      'Pupuk kandang|20 sampai 30 kg per pohon per tahun.|20|30|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1,5 kg per pohon per tahun sesuai umur.|0.5|1.5|kg/pohon/thn',
    ],
    prob: [
      'Busuk akar Phytophthora|Jamur|Daun menguning dan layu, akar cokelat.|Drainase baik, bibit bebas penyakit, hindari genangan.',
      'Kerak buah (scab)|Jamur|Bercak kasar pada kulit buah dan daun.|Pangkas tajuk, fungisida saat berbunga.',
      'Ulat daun|Hama|Daun berlubang dan tergulung.|Pemantauan, insektisida bila perlu.',
    ],
    care: [
      'Tanam campuran tipe bunga A dan B agar penyerbukan silang baik.',
      'Beri mulsa tebal di sekitar perakaran dangkal.',
      'Petik pada umur tua; alpukat tidak matang di pohon.',
    ],
    harvest:
        'Panen 8 sampai 10 bulan setelah berbunga; ciri tangkai menguning dan kulit kusam. Matangkan pada suhu ruang 5 sampai 7 hari.',
  ),
  'durian': _g(
    ph: [5.0, 7.0],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung dalam, subur, drainase baik; tidak tahan genangan.',
    alt: '0 sampai 800 mdpl',
    water: 'Banyak dan merata; musim kering pendek memicu bunga.',
    sun: 'Penuh saat dewasa; teduh ringan saat bibit.',
    space: '10 × 12 m',
    trees: 80,
    fert: [
      'Pupuk kandang|30 sampai 50 kg per pohon per tahun.|30|50|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 3 kg per pohon per tahun sesuai umur.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Busuk pangkal Phytophthora|Jamur|Getah dan luka cokelat pada pangkal batang.|Drainase, sanitasi, fungisida sistemik.',
      'Busuk buah|Jamur|Bercak cokelat berair pada kulit buah.|Sanitasi buah gugur, fungisida.',
      'Penggerek batang|Hama|Lubang dan serbuk kayu pada batang.|Sanitasi, suntik insektisida pada lubang.',
    ],
    care: [
      'Gunakan bibit okulasi varietas unggul agar cepat berbuah.',
      'Bantu penyerbukan dengan kuas pada malam hari.',
      'Jarangkan buah muda agar ukuran dan mutu terjaga.',
    ],
    harvest:
        'Panen 100 sampai 130 hari setelah berbunga tergantung varietas; buah matang jatuh sendiri, jadi panen tepat waktu atau pasang jaring.',
  ),
  'vanili': _g(
    ph: [6.0, 7.0],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Gembur, kaya bahan organik, drainase baik, di bawah naungan.',
    alt: '0 sampai 800 mdpl',
    water: 'Sedang; kelembapan udara tinggi disukai.',
    sun: 'Teduh (naungan 50 sampai 70 persen).',
    space: '200 × 150 cm dengan tiang panjat',
    trees: 1500,
    fert: [
      'Kompos|5 sampai 10 kg per tanaman per tahun.|5|10|kg/pohon/thn',
      'NPK 16-16-16|50 sampai 100 g per tanaman per tahun.|50|100|g/pohon/thn',
    ],
    prob: [
      'Busuk batang Fusarium|Jamur|Batang menguning lalu lembek.|Sanitasi, drainase, bibit sehat.',
      'Antraknosa|Jamur|Bercak pada daun dan sulur.|Sanitasi, atur kerapatan naungan.',
      'Busuk polong|Jamur|Polong bercak cokelat dan busuk.|Jaga kelembapan, buang polong sakit.',
    ],
    care: [
      'Serbuk sari harus dipindahkan manual pada pagi hari saat bunga mekar.',
      'Lilitkan sulur pada tiang agar mudah diserbuki dan dipanen.',
      'Curing bertahap menentukan harga; jangan terburu-buru.',
    ],
    harvest:
        'Panen 8 sampai 9 bulan setelah penyerbukan saat ujung polong menguning. Lanjutkan curing 3 sampai 6 bulan hingga hitam beraroma.',
  ),
  'kayumanis': _g(
    ph: [5.0, 6.5],
    best: [9, 10, 11],
    ok: [3, 4, 8],
    soil: 'Lempung berpasir sampai liat, subur, drainase baik.',
    alt: '500 sampai 1.500 mdpl',
    water: 'Sedang sampai banyak dan merata.',
    sun: 'Penuh hingga teduh ringan.',
    space: '200 × 200 cm atau rapat 100 × 100 cm',
    trees: 2500,
    fert: [
      'Pupuk kandang|5 sampai 10 kg per tanaman per tahun.|5|10|kg/pohon/thn',
      'NPK 16-16-16|100 sampai 200 g per tanaman per tahun.|100|200|g/pohon/thn',
    ],
    prob: [
      'Busuk akar|Jamur|Daun menguning dan tanaman kerdil.|Drainase baik, sanitasi.',
      'Bercak daun|Jamur|Bercak cokelat pada daun.|Sanitasi, fungisida bila parah.',
      'Penggerek batang|Hama|Lubang pada batang muda.|Potong dan musnahkan bagian terserang.',
    ],
    care: [
      'Pangkas bentuk sejak muda agar batang lurus dan mudah dikupas.',
      'Kupas kulit segera setelah tebang agar tidak menghitam.',
      'Jemur gulungan kulit perlahan untuk warna dan aroma terbaik.',
    ],
    harvest:
        'Panen umur 4 sampai 5 tahun dengan menebang batang; kupas kulit, gulung, lalu jemur perlahan 3 sampai 5 hari.',
  ),
  'labu': _g(
    ph: [5.8, 6.8],
    best: [4, 5, 6],
    ok: [3, 7, 8, 9],
    soil: 'Lempung berpasir subur kaya organik, drainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Sedang sampai banyak; kritis saat pembungaan.',
    sun: 'Penuh.',
    space: '150 × 100 cm, merambat atau menjalar',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|250 sampai 350 kg per ha dibagi dua aplikasi.|250|350|kg/ha',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan putih pada permukaan daun.|Sanitasi, fungisida bila parah.',
      'Lalat buah|Hama|Buah berlubang lalu busuk.|Pembungkusan buah, perangkap.',
      'Busuk buah|Jamur|Bercak basah pada buah yang menyentuh tanah.|Alas jerami, drainase baik.',
    ],
    care: [
      'Alas buah dengan jerami atau plastik mulsa.',
      'Pangkas sulur liar agar nutrisi terfokus ke buah.',
      'Kawinkan bunga manual pagi hari bila serangga penyerbuk sedikit.',
    ],
    harvest:
        'Panen 80 sampai 100 hari setelah tanam saat tangkai mengering dan kulit keras; potong dengan tangkai 3 sampai 5 cm.',
  ),
  'paprika': _g(
    ph: [5.5, 6.8],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    soil: 'Lempung gembur kaya organik; paling baik di rumah plastik.',
    alt: '600 sampai 1.500 mdpl',
    water: 'Teratur dan merata; tidak tahan tanah becek.',
    sun: 'Penuh dengan naungan ringan saat terik.',
    space: '60 × 50 cm',
    fert: [
      'Pupuk kandang|15 sampai 25 ton per ha sebagai pupuk dasar.|15|25|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha diberikan bertahap.|300|400|kg/ha',
      'Kalsium|Bila ujung buah busuk karena kekurangan kalsium.',
    ],
    prob: [
      'Busuk ujung buah|Fisiologis|Ujung buah cokelat cekung dan kering.|Irigasi teratur, pupuk kalsium.',
      'Antraknosa|Jamur|Bercak bulat cekung pada buah.|Sanitasi, fungisida preventif.',
      'Thrips|Hama|Daun keriting dengan bintik perak.|Perangkap, insektisida selektif.',
    ],
    care: [
      'Pasang ajir dan ikat batang utama sejak dini.',
      'Buang buah pertama agar tanaman tumbuh kuat.',
      'Jaga kelembapan stabil dengan irigasi tetes.',
    ],
    harvest:
        'Panen 90 sampai 110 hari setelah tanam saat warna penuh terbentuk; gunting tangkai, jangan ditarik.',
  ),
  'sirsak': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 3, 10],
    soil: 'Lempung berpasir sampai liat dengan drainase baik.',
    alt: '0 sampai 500 mdpl',
    water: 'Sedang; tahan kering sebentar setelah dewasa.',
    sun: 'Penuh.',
    space: '600 × 600 cm',
    trees: 275,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'Busuk buah|Jamur|Bercak hitam meluas pada kulit buah.|Sanitasi, pembungkusan buah muda.',
      'Kutu putih|Hama|Bintik putih pada daun dan buah.|Kendalikan semut, insektisida bila parah.',
      'Lalat buah|Hama|Belatung di dalam buah rontok.|Perangkap, sanitasi buah jatuh.',
    ],
    care: [
      'Pangkas pembentukan tajuk rendah agar panen mudah.',
      'Tipiskan buah muda sisakan satu sampai dua per tangkai.',
      'Bungkus buah muda dengan kertas atau plastik berlubang.',
    ],
    harvest:
        'Panen 3 sampai 4 tahun setelah tanam saat kulit hijau kekuningan dan duri merenggang; potong dengan tangkai.',
  ),
  'manggis': _g(
    ph: [5.0, 6.5],
    best: [11, 12, 1],
    ok: [2, 10],
    soil: 'Lempung dalam kaya organik tanpa genangan.',
    alt: '0 sampai 800 mdpl',
    water: 'Banyak dan merata; stres air merusak mutu buah.',
    sun: 'Teduh parsial saat muda, penuh saat produktif.',
    space: '1000 × 1000 cm',
    trees: 100,
    fert: [
      'Pupuk kandang|30 sampai 60 kg per pohon per tahun.|30|60|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 3 kg per pohon per tahun.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Getah kuning|Fisiologis|Daging buah bercak getah kuning.|Irigasi stabil, hindari stres air.',
      'Busuk buah|Jamur|Kulit menghitam dan buah lembek.|Sanitasi, panen tepat waktu.',
      'Kutu putih|Hama|Permukaan buah berbintik putih.|Sanitasi, insektisida bila parah.',
    ],
    care: [
      'Beri naungan parsial pada tanaman muda.',
      'Mulsa tebal menjaga kelembapan zona akar.',
      'Panen dengan gunting bertangkai, jangan dijatuhkan.',
    ],
    harvest:
        'Panen 8 sampai 10 tahun setelah tanam saat kulit ungu penuh; petik dengan gunting menyertakan tangkai 2 cm.',
  ),
  'kacangmerah': _g(
    ph: [5.8, 7.0],
    best: [4, 5, 6],
    ok: [3, 7, 8],
    soil: 'Lempung berpasir gembur dengan drainase baik.',
    alt: '300 sampai 1.500 mdpl',
    water: 'Sedang; kurangi saat polong mengisi.',
    sun: 'Penuh.',
    space: '40 × 20 cm',
    fert: [
      'Pupuk kandang|5 sampai 10 ton per ha sebagai pupuk dasar.|5|10|ton/ha',
      'SP-36|50 sampai 100 kg per ha saat tanam.|50|100|kg/ha',
    ],
    prob: [
      'Layu bakteri|Bakteri|Tanaman layu mendadak saat berbunga.|Rotasi tanaman, bibit sehat.',
      'Karat daun|Jamur|Bintik cokelat berbubuk pada daun.|Varietas tahan, fungisida.',
      'Ulat grayak|Hama|Daun berlubang sampai gundul.|Pemantauan rutin, insektisida bila ambang terlampaui.',
    ],
    care: [
      'Bumbun pangkal batang saat umur 3 minggu.',
      'Hindari genangan lebih dari satu hari.',
      'Panen bertahap saat polong menguning kering.',
    ],
    harvest:
        'Panen 90 sampai 110 hari setelah tanam saat polong kering menguning; cabut, jemur, lalu pipil bijinya.',
  ),
  'kacangpolong': _g(
    ph: [5.8, 7.0],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung gembur kaya organik.',
    alt: '700 sampai 1.500 mdpl',
    water: 'Teratur; sensitif kekeringan saat berbunga.',
    sun: 'Penuh hingga teduh ringan.',
    space: '50 × 10 cm dengan lanjaran',
    fert: [
      'Kompos|10 sampai 15 ton per ha sebagai pupuk dasar.|10|15|ton/ha',
      'SP-36|50 sampai 75 kg per ha saat tanam.|50|75|kg/ha',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan putih pada daun.|Sirkulasi udara baik, fungisida.',
      'Busuk akar|Jamur|Tanaman layu dan pangkal membusuk.|Rotasi tanaman, drainase baik.',
      'Ulat polong|Hama|Polong berlubang berisi ulat.|Petik polong terserang, insektisida.',
    ],
    care: [
      'Pasang lanjaran setinggi 150 cm saat mulai memanjat.',
      'Siram pagi hari pada masa berbunga.',
      'Petik polong muda tiap 2 sampai 3 hari.',
    ],
    harvest:
        'Panen 55 sampai 70 hari setelah tanam saat polong muda berisi penuh; petik dengan tangan hati-hati.',
  ),
  'belimbing': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 9, 10],
    soil: 'Lempung berpasir subur berdrainase baik.',
    alt: '0 sampai 500 mdpl',
    water: 'Sedang sampai banyak dan merata.',
    sun: 'Penuh.',
    space: '600 × 600 cm',
    trees: 275,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'Bercak daun|Jamur|Bercak cokelat pada helaian daun.|Sanitasi, fungisida bila parah.',
      'Lalat buah|Hama|Buah berlubang lalu rontok.|Pembungkusan buah, perangkap.',
      'Kutu putih|Hama|Bintik putih pada tunas muda.|Insektisida bila populasi tinggi.',
    ],
    care: [
      'Bungkus buah muda dengan plastik berlubang.',
      'Pangkas tunas air agar cahaya masuk tajuk.',
      'Jaga irigasi saat pembungaan agar buah tidak rontok.',
    ],
    harvest:
        'Panen 2 sampai 3 tahun setelah tanam (okulasi) saat warna kuning merata; potong menyertakan tangkai.',
  ),
  'apel': _g(
    ph: [5.5, 6.5],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung berpasir dalam, subur, drainase baik.',
    alt: '1.000 sampai 1.400 mdpl',
    water: 'Teratur; mulsa membantu menjaga kelembapan.',
    sun: 'Penuh.',
    space: '300 × 300 cm',
    trees: 1100,
    fert: [
      'Pupuk kandang|15 sampai 30 kg per pohon per tahun.|15|30|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1,5 kg per pohon per tahun.|0.5|1.5|kg/pohon/thn',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan putih pada daun muda.|Fungisida, pangkas bagian sakit.',
      'Busuk buah|Jamur|Bercak cokelat membusuk pada buah.|Sanitasi, fungisida preventif.',
      'Kutu daun|Hama|Daun mengeriting berkoloni.|Musuh alami, insektisida bila parah.',
    ],
    care: [
      'Pangkas pembentukan dan pembuahan tiap musim.',
      'Jarangkan buah muda sisakan satu per dompol.',
      'Bungkus buah untuk warna dan mutu kulit.',
    ],
    harvest:
        'Panen 3 sampai 4 tahun setelah tanam saat warna merah menutup dan buah mudah dilepas; petik menyertakan tangkai.',
  ),
  'daunpandan': _g(
    ph: [5.5, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 3, 9],
    soil: 'Lempung lembap kaya bahan organik.',
    alt: '0 sampai 700 mdpl',
    water: 'Banyak; menyukai tanah lembap terus.',
    sun: 'Teduh ringan hingga penuh.',
    space: '100 × 100 cm',
    fert: [
      'Pupuk kandang|5 sampai 10 kg per tanaman per tahun.|5|10|kg/pohon/thn',
      'Urea|20 sampai 40 g per tanaman setelah tiap panen daun.|20|40|g/pohon/kali',
    ],
    prob: [
      'Bercak daun|Jamur|Bercak cokelat memanjang pada daun.|Sanitasi daun tua, fungisida bila parah.',
      'Kutu putih|Hama|Bintik putih pada pangkal daun.|Insektisida bila populasi tinggi.',
    ],
    care: [
      'Potong daun dari luar ke dalam rumpun.',
      'Beri mulsa organik untuk menjaga kelembapan.',
      'Pisahkan anakan sehat untuk bibit baru.',
    ],
    harvest:
        'Panen daun mulai umur 8 sampai 12 bulan dan seterusnya tiap 2 sampai 3 bulan; potong daun tua dekat pangkal.',
  ),
  'tembakau': _g(
    ph: [5.5, 6.5],
    best: [4, 5],
    ok: [3, 6],
    soil: 'Lempung berpasir subur dengan drainase sangat baik.',
    alt: '0 sampai 900 mdpl',
    water: 'Sedang; hujan saat panen merusak mutu daun.',
    sun: 'Penuh.',
    space: '100 × 50 cm',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 15-15-15|300 sampai 500 kg per ha diberikan bertahap.|300|500|kg/ha',
    ],
    prob: [
      'Busuk batang|Jamur|Batang menghitam dan tanaman layu.|Drainase baik, rotasi tanaman.',
      'Ulat grayak|Hama|Daun berlubang besar.|Pemantauan rutin, insektisida bila ambang terlampaui.',
      'Bercak cokelat|Jamur|Bercak konsentris pada daun tua.|Sanitasi, fungisida.',
    ],
    care: [
      'Buang tunas ketiak (wiwil) rutin tiap minggu.',
      'Pangkas bunga saat muncul agar daun menebal.',
      'Naungi daun hasil petikan sebelum diperam.',
    ],
    harvest:
        'Panen 90 sampai 120 hari bertahap dari daun bawah ke atas; peram 1 sampai 2 hari lalu keringkan di kumbung.',
  ),
  'kemiri': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 3],
    soil: 'Toleran; dari subur sampai marginal asal drainase baik.',
    alt: '0 sampai 800 mdpl',
    water: 'Sedang; tahan kering setelah dewasa.',
    sun: 'Penuh.',
    space: '1000 × 1000 cm',
    trees: 100,
    fert: [
      'Pupuk kandang|20 sampai 50 kg per pohon per tahun.|20|50|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 3 kg per pohon per tahun.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Busuk akar|Jamur|Daun menguning dan tajuk menipis.|Drainase baik, sanitasi.',
      'Penggerek batang|Hama|Lubang gerekan pada batang.|Potong bagian terserang, sanitasi.',
    ],
    care: [
      'Kumpulkan buah jatuh secara rutin saat musim panen.',
      'Jemur buah untuk melepas kulit luar.',
      'Pecah cangkang setelah biji kering sempurna.',
    ],
    harvest:
        'Panen 4 sampai 5 tahun setelah tanam saat buah jatuh alami; kupas kulit, jemur, lalu pecah cangkang.',
  ),
  'anggur': _g(
    ph: [5.5, 6.5],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    soil: 'Lempung berpasir dalam dengan drainase sangat baik.',
    alt: '0 sampai 300 mdpl dengan musim kering jelas',
    water: 'Sedang; kurangi saat pemasakan buah.',
    sun: 'Penuh.',
    space: '300 × 300 cm dengan para-para',
    trees: 1100,
    fert: [
      'Pupuk kandang|10 sampai 20 kg per pohon per tahun.|10|20|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1 kg per pohon per tahun.|0.5|1|kg/pohon/thn',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan kelabu pada daun dan buah.|Sirkulasi kanopi, fungisida.',
      'Busuk buah|Jamur|Dompol membusuk saat musim hujan.|Jarangkan dompol, fungisida preventif.',
    ],
    care: [
      'Pangkas pembuahan dua kali setahun setelah tanaman dewasa.',
      'Jarangkan dompol dan buah untuk ukuran merata.',
      'Atur kanopi agar sinar masuk ke zona buah.',
    ],
    harvest:
        'Panen 1 sampai 2 tahun setelah tanam, 90 sampai 110 hari setelah pangkas; gunting dompol yang matang gula.',
  ),
  'rambutan': _g(
    ph: [5.0, 6.5],
    best: [11, 12, 1],
    ok: [2, 10],
    soil: 'Lempung dalam kaya bahan organik.',
    alt: '0 sampai 500 mdpl',
    water: 'Banyak saat tumbuh, kering saat pembungaan.',
    sun: 'Penuh.',
    space: '1000 × 1000 cm',
    trees: 100,
    fert: [
      'Pupuk kandang|30 sampai 60 kg per pohon per tahun.|30|60|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 3 kg per pohon per tahun.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Busuk buah|Jamur|Bercak cokelat pada kulit buah.|Sanitasi, hindari buah menyentuh tanah.',
      'Kutu putih|Hama|Bintik putih pada dompol buah.|Insektisida bila populasi tinggi.',
    ],
    care: [
      'Pangkas tajuk agar cahaya merata dan panen mudah.',
      'Jaga kelembapan saat berbunga agar buah tidak rontok.',
      'Panen per dompol dengan gunting atau pisau.',
    ],
    harvest:
        'Panen 4 sampai 5 tahun setelah tanam saat kulit merah penuh; potong tangkai dompol, jangan petik satuan.',
  ),
  'kacanghijau': _g(
    ph: [5.5, 7.0],
    best: [4, 5, 6],
    ok: [3, 7, 8, 9],
    soil: 'Lempung berpasir sampai liat dengan drainase baik.',
    alt: '0 sampai 500 mdpl',
    water: 'Sedikit sampai sedang; relatif tahan kering.',
    sun: 'Penuh.',
    space: '40 × 15 cm',
    fert: [
      'Pupuk kandang|3 sampai 5 ton per ha sebagai pupuk dasar.|3|5|ton/ha',
      'SP-36|50 sampai 75 kg per ha saat tanam.|50|75|kg/ha',
    ],
    prob: [
      'Bercak daun|Jamur|Bercak cokelat pada helaian daun.|Rotasi tanaman, fungisida bila parah.',
      'Ulat polong|Hama|Polong berlubang.|Petik polong terserang, insektisida.',
      'Kutu daun|Hama|Daun mengeriting berkoloni.|Musuh alami, insektisida bila parah.',
    ],
    care: [
      'Bumbun pangkal batang saat umur 3 minggu.',
      'Panen bertahap tiap 3 sampai 4 hari.',
      'Jemur polong sampai kering sebelum dipipil.',
    ],
    harvest:
        'Panen 55 sampai 70 hari setelah tanam saat polong berubah cokelat kering; cabut utuh atau petik bertahap.',
  ),
  'ketumbar': _g(
    ph: [6.0, 7.5],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    soil: 'Lempung gembur berdrainase baik.',
    alt: '700 sampai 1.500 mdpl',
    water: 'Sedang; kurangi saat biji mengisi.',
    sun: 'Penuh.',
    space: '30 × 10 cm',
    fert: [
      'Kompos|5 sampai 10 ton per ha sebagai pupuk dasar.|5|10|ton/ha',
      'NPK 16-16-16|100 sampai 150 kg per ha.|100|150|kg/ha',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan putih pada daun.|Sirkulasi udara baik, fungisida.',
      'Busuk akar|Jamur|Tanaman layu mendadak.|Drainase baik, rotasi tanaman.',
    ],
    care: [
      'Siram seperlunya; tanaman tidak menyukai tanah becek.',
      'Siangi gulma saat tanaman masih muda.',
      'Panen saat buah cokelat lalu jemur utuh.',
    ],
    harvest:
        'Panen 90 sampai 110 hari setelah tanam saat buah cokelat kering; potong tanaman, jemur, lalu pipil biji.',
  ),
  'cengkeh': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 10],
    soil: 'Lempung dalam subur, drainase baik, terlindung angin.',
    alt: '0 sampai 900 mdpl',
    water: 'Banyak dan merata; tidak tahan genangan.',
    sun: 'Penuh hingga teduh ringan saat muda.',
    space: '800 × 800 cm',
    trees: 155,
    fert: [
      'Pupuk kandang|20 sampai 50 kg per pohon per tahun.|20|50|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'Busuk akar|Jamur|Daun menguning dan ranting mengering.|Drainase baik, sanitasi.',
      'Bercak daun|Jamur|Bercak ungu kecokelatan pada daun.|Sanitasi, fungisida bila parah.',
    ],
    care: [
      'Beri naungan parsial pada tanaman muda.',
      'Mulsa tebal menjaga kelembapan zona akar.',
      'Panen bunga tepat warna sebelum berubah merah.',
    ],
    harvest:
        'Panen 5 sampai 7 tahun setelah tanam saat bunga hijau kekuningan; petik tanpa daun, jemur sampai cokelat kering.',
  ),
  'stroberi': _g(
    ph: [5.5, 6.5],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung berpasir gembur kaya organik, drainase baik.',
    alt: '800 sampai 1.500 mdpl',
    water: 'Teratur; hindari daun dan buah basah.',
    sun: 'Penuh.',
    space: '40 × 30 cm pada bedengan',
    fert: [
      'Kompos|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha diberikan bertahap.|200|300|kg/ha',
    ],
    prob: [
      'Busuk buah|Jamur|Buah berbulu kelabu dan lembek.|Mulsa, sirkulasi, fungisida.',
      'Bercak daun|Jamur|Bercak ungu pada daun.|Sanitasi daun tua, fungisida.',
      'Tungau|Hama|Daun keriput berbintik kuning.|Akarisida bila populasi tinggi.',
    ],
    care: [
      'Buang sulur berlebih, sisakan bibit terpilih.',
      'Mulsa plastik menjaga buah tetap kering.',
      'Petik buah matang setiap 2 hari.',
    ],
    harvest:
        'Panen 2 sampai 3 bulan setelah tanam bibit dan berlanjut 8 sampai 12 bulan; petik pagi saat merah penuh.',
  ),
  'lemon': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 5, 6],
    soil: 'Lempung berpasir dalam dengan drainase sangat baik.',
    alt: '0 sampai 800 mdpl',
    water: 'Sedang dan merata; genangan merusak akar.',
    sun: 'Penuh.',
    space: '500 × 500 cm',
    trees: 400,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'CVPD|Bakteri|Daun kuning belang dan tulang daun menonjol.|Bibit bebas penyakit, kendalikan kutu loncat.',
      'Kutu putih|Hama|Bintik putih pada daun dan buah.|Insektisida bila populasi tinggi.',
    ],
    care: [
      'Pangkas tunas air dan cabang di dalam tajuk.',
      'Jaga irigasi saat pembungaan dan pembuahan.',
      'Panen dengan gunting agar tangkai rapi.',
    ],
    harvest:
        'Panen 2 sampai 3 tahun setelah tanam saat kulit kuning mengilap; potong dengan gunting menyertakan tangkai pendek.',
  ),
  'kapulaga': _g(
    ph: [5.5, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 9],
    soil: 'Lempung kaya organik, lembap, di bawah naungan.',
    alt: '300 sampai 1.000 mdpl',
    water: 'Banyak dan merata; tidak tahan genangan.',
    sun: 'Teduh parsial (naungan 30 sampai 50 persen).',
    space: '150 × 150 cm',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha dibagi dua aplikasi.|200|300|kg/ha',
    ],
    prob: [
      'Busuk rimpang|Jamur|Rimpang lembek dan tanaman layu.|Drainase baik, bibit sehat.',
      'Bercak daun|Jamur|Bercak cokelat pada helaian daun.|Sanitasi, fungisida bila parah.',
    ],
    care: [
      'Pangkas batang tua setelah panen untuk merangsang anakan.',
      'Jaga seresah daun sebagai mulsa alami.',
      'Panen polong matang satu per satu.',
    ],
    harvest:
        'Panen mulai umur 2 sampai 3 tahun saat polong hijau kekuningan; petik per tandan lalu keringkan perlahan.',
  ),
  'teh': _g(
    ph: [4.5, 5.5],
    best: [9, 10, 11],
    ok: [3, 4, 8],
    soil: 'Lempung berpasir asam, dalam, drainase baik.',
    alt: '800 sampai 2.000 mdpl',
    water: 'Banyak dan merata sepanjang tahun.',
    sun: 'Penuh hingga teduh ringan.',
    space: '120 × 60 cm',
    trees: 13000,
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha per tahun.|10|20|ton/ha',
      'Urea|200 sampai 400 kg per ha per tahun dibagi empat.|200|400|kg/ha',
    ],
    prob: [
      'Busuk akar|Jamur|Tanaman layu dan daun menguning.|Drainase baik, sanitasi tunggul.',
      'Ulat daun|Hama|Daun berlubang sampai habis.|Petik manual, insektisida bila ambang.',
    ],
    care: [
      'Pangkas produksi berkala agar bidang petik tetap rendah.',
      'Petik pucuk peko plus dua daun muda.',
      'Kembalikan sisa pangkasan sebagai mulsa.',
    ],
    harvest:
        'Panen pucuk setiap 7 sampai 14 hari sepanjang tahun setelah umur 3 tahun; standar pucuk peko plus dua daun.',
  ),
  'jeruk': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 5, 6],
    soil: 'Lempung berpasir dalam tanpa lapisan keras, drainase baik.',
    alt: '0 sampai 1.200 mdpl sesuai varietas',
    water: 'Teratur; genangan memicu busuk akar.',
    sun: 'Penuh.',
    space: '500 × 500 cm',
    trees: 400,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'CVPD|Bakteri|Daun kuning belang, buah kecil keras.|Bibit bebas penyakit, kendalikan kutu loncat.',
      'Busuk akar|Jamur|Daun menguning dari tajuk bawah.|Drainase baik, fungisida bila perlu.',
      'Lalat buah|Hama|Buah berlubang lalu rontok.|Perangkap, sanitasi buah jatuh.',
    ],
    care: [
      'Pangkas bentuk dan buang tunas air.',
      'Jaga kelembapan stabil saat pembuahan.',
      'Panen dengan gunting saat warna merata.',
    ],
    harvest:
        'Panen 2 sampai 3 tahun setelah tanam saat kulit kuning merata dan sedikit lunak; potong tangkai dengan gunting.',
  ),
  'buahnaga': _g(
    ph: [5.5, 6.5],
    best: [10, 11, 12],
    ok: [1, 2, 9],
    soil: 'Lempung berpasir gembur dengan drainase sangat baik.',
    alt: '0 sampai 600 mdpl',
    water: 'Sedikit; tanaman kaktus tahan kering.',
    sun: 'Penuh.',
    space: '250 × 250 cm per tiang panjat',
    trees: 1600,
    fert: [
      'Pupuk kandang|10 sampai 20 kg per tiang per tahun.|10|20|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1 kg per tiang per tahun.|0.5|1|kg/pohon/thn',
    ],
    prob: [
      'Busuk batang|Jamur|Batang lembek kecokelatan.|Drainase baik, potong bagian sakit.',
      'Antraknosa|Jamur|Bercak cokelat pada batang dan buah.|Sanitasi, fungisida.',
    ],
    care: [
      'Ikat sulur pada tiang dan pangkas sulur tidak produktif.',
      'Bantu penyerbukan manual pada bunga yang mekar malam.',
      'Tipiskan buah, sisakan dua sampai tiga per sulur.',
    ],
    harvest:
        'Panen mulai umur 1,5 tahun saat sisik merah merata dan buah agak lunak; potong menyertakan tangkai pendek.',
  ),
  'seledri': _g(
    ph: [5.8, 6.8],
    best: [5, 6, 7],
    ok: [4, 8, 9],
    soil: 'Lempung lembap kaya bahan organik.',
    alt: '700 sampai 1.500 mdpl',
    water: 'Banyak dan merata; tidak tahan kering.',
    sun: 'Penuh hingga teduh ringan.',
    space: '25 × 20 cm',
    fert: [
      'Kompos|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|150 sampai 250 kg per ha diberikan bertahap.|150|250|kg/ha',
    ],
    prob: [
      'Bercak daun|Jamur|Bercak cokelat pada daun dan tangkai.|Sanitasi, fungisida.',
      'Busuk pangkal|Jamur|Pangkal batang lembek dan layu.|Rotasi tanaman, drainase baik.',
    ],
    care: [
      'Siram pagi dan sore pada musim kering.',
      'Siangi gulma dengan tangan karena akar dangkal.',
      'Panen daun luar atau cabut utuh satu rumpun.',
    ],
    harvest:
        'Panen 60 sampai 90 hari setelah tanam; petik daun luar bertahap atau cabut rumpun utuh.',
  ),
  'brokoli': _g(
    ph: [5.5, 6.8],
    best: [5, 6, 7],
    ok: [4, 8],
    soil: 'Lempung subur kaya organik, drainase baik.',
    alt: '800 sampai 1.500 mdpl',
    water: 'Teratur dan merata.',
    sun: 'Penuh.',
    space: '60 × 50 cm',
    fert: [
      'Pupuk kandang|15 sampai 25 ton per ha sebagai pupuk dasar.|15|25|ton/ha',
      'NPK 16-16-16|250 sampai 350 kg per ha diberikan bertahap.|250|350|kg/ha',
    ],
    prob: [
      'Busuk lunak|Bakteri|Bunga berlendir dan berbau.|Hindari luka, rotasi, sanitasi.',
      'Ulat daun|Hama|Bunga berlubang dan kotor.|Pemantauan rutin, insektisida bila ambang terlampaui.',
      'Bercak hitam|Jamur|Bercak hitam pada daun dan bunga.|Sanitasi, fungisida.',
    ],
    care: [
      'Bumbun pangkal batang saat umur 3 minggu.',
      'Jaga kelembapan stabil agar bunga padat.',
      'Potong bunga utama dengan tangkai 10 cm.',
    ],
    harvest:
        'Panen 55 sampai 70 hari setelah tanam saat kuncup rapat; potong bunga dengan tangkai, tunas samping menyusul.',
  ),
  'pala': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 6, 7],
    soil: 'Lempung vulkanis dalam, subur, drainase baik.',
    alt: '0 sampai 700 mdpl',
    water: 'Banyak dan merata; tidak tahan genangan.',
    sun: 'Teduh parsial saat muda, penuh saat produktif.',
    space: '900 × 900 cm',
    trees: 120,
    fert: [
      'Pupuk kandang|20 sampai 50 kg per pohon per tahun.|20|50|kg/pohon/thn',
      'NPK 16-16-16|1 sampai 3 kg per pohon per tahun.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Busuk akar|Jamur|Daun menguning lalu gugur.|Drainase baik, sanitasi.',
      'Bercak daun|Jamur|Bercak cokelat pada daun muda.|Sanitasi, fungisida bila parah.',
    ],
    care: [
      'Beri naungan dan penahan angin saat muda.',
      'Sisakan satu pohon jantan per sepuluh pohon betina.',
      'Kumpulkan buah pecah setiap hari saat musim panen.',
    ],
    harvest:
        'Panen 6 sampai 8 tahun setelah tanam saat buah pecah alami; pisahkan biji, fuli, dan daging lalu jemur terpisah.',
  ),
  'kelapa': _g(
    ph: [5.5, 7.0],
    best: [11, 12, 1],
    ok: [2, 3, 10],
    soil: 'Lempung berpasir dalam; toleran wilayah pesisir.',
    alt: '0 sampai 400 mdpl',
    water: 'Sedang sampai banyak; tahan kering sebentar.',
    sun: 'Penuh.',
    space: '800 × 800 cm pola segitiga',
    trees: 145,
    fert: [
      'Pupuk kandang|30 sampai 60 kg per pohon per tahun.|30|60|kg/pohon/thn',
      'KCl|1 sampai 3 kg per pohon per tahun untuk isi buah.|1|3|kg/pohon/thn',
    ],
    prob: [
      'Busuk pucuk|Jamur|Pucuk membusuk dan mudah tercabut.|Drainase baik, sanitasi tanaman sakit.',
      'Kumbang badak|Hama|Pucuk berlubang dan pelepah patah.|Sanitasi sarang, perangkap.',
    ],
    care: [
      'Bersihkan piringan bawah pohon dari gulma.',
      'Kembalikan sabut dan janur sebagai mulsa.',
      'Sesuaikan umur panen dengan tujuan: buah muda atau tua.',
    ],
    harvest:
        'Panen 5 sampai 6 tahun setelah tanam; buah tua 12 bulan untuk kopra atau buah muda 7 sampai 8 bulan untuk air.',
  ),
  'salak': _g(
    ph: [5.0, 6.5],
    best: [11, 12, 1],
    ok: [2, 10],
    soil: 'Lempung kaya organik, lembap, drainase baik.',
    alt: '100 sampai 700 mdpl',
    water: 'Banyak dan merata; tidak tahan genangan lama.',
    sun: 'Teduh parsial hingga penuh saat dewasa.',
    space: '250 × 250 cm',
    trees: 1600,
    fert: [
      'Pupuk kandang|10 sampai 20 kg per pohon per tahun.|10|20|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1,5 kg per pohon per tahun.|0.5|1.5|kg/pohon/thn',
    ],
    prob: [
      'Busuk buah|Jamur|Buah lembek berbau saat lembap.|Sanitasi, drainase, penjarangan buah.',
      'Bercak daun|Jamur|Bercak cokelat pada daun tua.|Sanitasi, fungisida bila parah.',
    ],
    care: [
      'Tipiskan buah muda, sisakan dua sampai tiga per dompol.',
      'Bantu penyerbukan dengan serbuk sari pohon jantan.',
      'Pangkas pelepah tua untuk akses panen.',
    ],
    harvest:
        'Panen 3 sampai 4 tahun setelah tanam saat kulit cokelat kekuningan dan duri jarang; potong tangkai dompol.',
  ),
  'markisa': _g(
    ph: [5.5, 6.5],
    best: [9, 10, 11],
    ok: [3, 4, 8],
    soil: 'Lempung berpasir subur dengan drainase baik.',
    alt: '800 sampai 1.500 mdpl',
    water: 'Teratur; stres air merontokkan buah.',
    sun: 'Penuh.',
    space: '300 × 300 cm dengan rambatan',
    trees: 1100,
    fert: [
      'Pupuk kandang|10 sampai 20 kg per pohon per tahun.|10|20|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 1,5 kg per pohon per tahun.|0.5|1.5|kg/pohon/thn',
    ],
    prob: [
      'Busuk buah|Jamur|Bercak cokelat lalu buah rontok.|Sanitasi, fungisida preventif.',
      'Virus BWV|Virus|Daun belang dan buah belang keras.|Bibit bebas virus, cabut tanaman sakit.',
    ],
    care: [
      'Atur sulur pada rambatan agar cahaya merata.',
      'Pangkas sulur tidak produktif setelah panen.',
      'Kumpulkan buah jatuh setiap pagi.',
    ],
    harvest:
        'Panen 1 sampai 1,5 tahun setelah tanam saat buah jatuh alami atau warna ungu penuh; kumpulkan tiap pagi.',
  ),
  'jambubiji': _g(
    ph: [5.5, 6.5],
    best: [11, 12, 1],
    ok: [2, 9, 10],
    soil: 'Toleran; lempung subur sampai liat berdrainase baik.',
    alt: '0 sampai 1.000 mdpl',
    water: 'Sedang; tahan kering setelah dewasa.',
    sun: 'Penuh.',
    space: '500 × 500 cm',
    trees: 400,
    fert: [
      'Pupuk kandang|20 sampai 40 kg per pohon per tahun.|20|40|kg/pohon/thn',
      'NPK 16-16-16|0,5 sampai 2 kg per pohon per tahun.|0.5|2|kg/pohon/thn',
    ],
    prob: [
      'Lalat buah|Hama|Belatung di dalam buah lalu rontok.|Pembungkusan buah, perangkap.',
      'Bercak daun|Jamur|Bercak cokelat pada helaian daun.|Sanitasi, fungisida bila parah.',
    ],
    care: [
      'Pangkas tajuk agar cahaya masuk dan panen mudah.',
      'Bungkus buah muda dengan plastik atau kertas.',
      'Jarangkan buah untuk ukuran merata.',
    ],
    harvest:
        'Panen 2 sampai 3 tahun setelah tanam saat kulit hijau kekuningan; potong dengan tangkai, jangan ditarik.',
  ),
  'pare': _g(
    ph: [5.5, 6.8],
    best: [4, 5, 6],
    ok: [3, 7, 8, 9],
    soil: 'Lempung gembur kaya bahan organik.',
    alt: '0 sampai 800 mdpl',
    water: 'Teratur dan merata.',
    sun: 'Penuh.',
    space: '100 × 60 cm dengan lanjaran',
    fert: [
      'Pupuk kandang|10 sampai 20 ton per ha sebagai pupuk dasar.|10|20|ton/ha',
      'NPK 16-16-16|200 sampai 300 kg per ha diberikan bertahap.|200|300|kg/ha',
    ],
    prob: [
      'Embun tepung|Jamur|Lapisan putih pada permukaan daun.|Sirkulasi udara baik, fungisida.',
      'Lalat buah|Hama|Buah berlubang lalu busuk.|Perangkap, sanitasi buah terserang.',
    ],
    care: [
      'Pasang lanjaran dan atur sulur merata.',
      'Petik buah muda tiap 2 sampai 3 hari.',
      'Buang daun tua bagian bawah untuk sirkulasi.',
    ],
    harvest:
        'Panen 45 sampai 60 hari setelah tanam saat buah muda hijau kencang; potong menyertakan tangkai pendek.',
  ),
  'cabaihijau': _g(
    ph: [5.5, 6.5],
    best: [4, 5, 6],
    ok: [3, 7, 8, 9],
    soil: 'Lempung berpasir subur dengan drainase baik.',
    alt: '0 sampai 800 mdpl',
    water: 'Teratur; tidak tahan tanah becek.',
    sun: 'Penuh.',
    space: '60 × 50 cm',
    fert: [
      'Pupuk kandang|15 sampai 25 ton per ha sebagai pupuk dasar.|15|25|ton/ha',
      'NPK 16-16-16|300 sampai 400 kg per ha diberikan bertahap.|300|400|kg/ha',
    ],
    prob: [
      'Antraknosa|Jamur|Bercak cekung pada buah.|Sanitasi, fungisida preventif.',
      'Thrips|Hama|Daun keriting dengan bintik perak.|Perangkap, insektisida selektif.',
      'Layu bakteri|Bakteri|Tanaman layu mendadak.|Rotasi tanaman, bibit sehat.',
    ],
    care: [
      'Pasang mulsa plastik dan ajir.',
      'Pangkas tunas bawah sampai percabangan utama.',
      'Petik hijau besar setiap 3 sampai 4 hari.',
    ],
    harvest:
        'Panen 75 sampai 90 hari setelah tanam saat buah hijau penuh dan kencang; petik menyertakan tangkai.',
  ),
};
