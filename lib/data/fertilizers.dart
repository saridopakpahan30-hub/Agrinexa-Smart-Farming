/// Tabel referensi jenis pupuk: fungsi, gejala kekurangan dan kelebihan, cara
/// aplikasi, waktu pemberian, serta pengaruhnya terhadap tanah.
///
/// Data disusun per unsur, bukan per tanaman. Gejala kekurangan nitrogen pada
/// cabai dan jagung identik karena yang menentukan adalah unsurnya. Yang
/// berbeda antar tanaman hanyalah dosis (`CropGuide.fertilizers`) dan kondisi
/// tanahnya (`phMin`, `phMax`, `soil`, `water`). Keduanya dipertemukan pada
/// `fertAlasan()` agar aplikasi dapat menjelaskan alasan kecocokan suatu
/// pupuk, bukan hanya menyebut namanya.
///
/// Angka batas mengacu pada praktik anjuran umum pemupukan di Indonesia
/// (dosis tunggal maksimum dan jarak antar pemberian). Nilainya tetap
/// merupakan perkiraan; uji tanah dan penyuluh (PPL) setempat lebih akurat.
library;

/// Fase pertumbuhan tanaman, dinyatakan sebagai pecahan umur hingga panen
/// (`Commodity.growDays`) agar berlaku untuk tanaman berumur 30 hari maupun
/// 4 tahun.
class FertPhase {
  final String id, name, note;
  final double from, to;

  const FertPhase(this.id, this.name, this.from, this.to, this.note);

  static FertPhase byId(String id) =>
      fertPhases.firstWhere((p) => p.id == id, orElse: () => fertPhases.last);

  /// Fase yang berlaku untuk pecahan umur [fraction]. Nilai negatif berarti
  /// sebelum tanam (persiapan lahan).
  static FertPhase of(double fraction) {
    for (final p in fertPhases) {
      if (fraction >= p.from && fraction < p.to) return p;
    }
    return fraction < 0 ? fertPhases.first : fertPhases.last;
  }
}

const fertPhases = [
  FertPhase('olah', 'Persiapan lahan', -1, 0.0,
      'Diberikan sebelum tanam, dicampur ke tanah waktu pengolahan.'),
  FertPhase('awal', 'Awal pertumbuhan', 0.0, 0.25,
      'Akar masih pendek, jadi dosis kecil tapi sering.'),
  FertPhase('veg', 'Pertumbuhan daun dan batang', 0.25, 0.5,
      'Fase tanaman menambah tinggi dan daun paling cepat.'),
  FertPhase('gen', 'Pembungaan dan pembentukan buah', 0.5, 0.75,
      'Kebutuhan kalium dan fosfor naik, nitrogen diturunkan.'),
  FertPhase('isi', 'Pengisian biji atau umbi', 0.75, 1.01,
      'Jangan beri nitrogen keras di sini: buah atau umbi jadi tidak serempak.'),
];

/// Arah pengaruh pupuk terhadap pH tanah. Nilai positif menaikkan (pembenah),
/// negatif menurunkan (pemupukan amonium berkelanjutan).
enum PhEffect { menaikkan, netral, menurunkan }

class FertKind {
  final String id, label, unsur, fungsi;

  /// Kecocokan dengan nama pupuk pada `Fert` (huruf kecil, sebagian kata
  /// sudah cukup).
  final List<String> match;

  /// Bagian tanaman yang paling diuntungkan — digunakan untuk menjelaskan
  /// kecocokan dengan bagian yang dipanen petani.
  final String feeds;
  final PhEffect phEffect;

  /// Kondisi tanah tempat pupuk ini bekerja paling baik, beserta akibatnya
  /// bila kondisi tanah berbeda.
  final String soilFit, soilWarn;

  final String deficiency, excess, method, split;

  /// Fase pemberian pupuk ini pada umumnya.
  final List<String> phases;

  /// Dosis satu kali aplikasi tertinggi yang masih aman (kg/ha). Nilai
  /// `null` berarti tidak ada batas tunggal yang kritis, hanya batas total.
  final double? maxPerHaOnce;

  const FertKind({
    required this.id,
    required this.label,
    required this.unsur,
    required this.fungsi,
    required this.match,
    required this.feeds,
    required this.phEffect,
    required this.soilFit,
    required this.soilWarn,
    required this.deficiency,
    required this.excess,
    required this.method,
    required this.split,
    required this.phases,
    this.maxPerHaOnce,
  });
}

const fertKinds = [
  FertKind(
    id: 'urea',
    label: 'Urea',
    unsur: 'Nitrogen (N) 46%',
    fungsi: 'Mempercepat pertumbuhan daun, batang, dan tinggi tanaman.',
    match: ['urea'],
    feeds: 'daun dan batang',
    phEffect: PhEffect.menurunkan,
    soilFit: 'Semua jenis tanah yang pH-nya sudah di atas 5,5 dan air cukup.',
    soilWarn:
        'Pada tanah di bawah pH 5,5 sebagian nitrogen tidak terpakai karena mikroba tanah berhenti bekerja; perbaiki pH lebih dulu.',
    deficiency:
        'Daun tua menguning mulai dari ujung, tanaman kerdil, anakan sedikit, panen lebih awal tetapi hasilnya ringan.',
    excess:
        'Batang lemas dan mudah rebah, daun terlalu rimbun sehingga lembap dan mudah kena jamur, pembungaan tertunda, dan pada padi nitrogen berlebih justru menurunkan mutu beras. Sisa nitrat juga tercuci ke air tanah.',
    method:
        'Tabur di antara barisan pada tanah lembap lalu tutup tanah, atau kocor bila tanaman masih kecil. Jangan biarkan butiran menempel di daun dan jangan tabur saat matahari terik.',
    split:
        'Bagi menjadi 2 sampai 3 kali pemberian, misalnya saat tanam, umur 3 minggu, dan umur 6 minggu. Sekali tabur tidak lebih dari 150 kg/ha.',
    phases: ['awal', 'veg'],
    maxPerHaOnce: 150,
  ),
  FertKind(
    id: 'za',
    label: 'ZA',
    unsur: 'Nitrogen (N) 21% + Belerang (S) 24%',
    fungsi:
        'Sumber nitrogen yang lebih lambat tersedia, sekaligus menambah belerang.',
    match: ['za', 'ammonium sulfat'],
    feeds: 'daun dan batang, plus mutu protein',
    phEffect: PhEffect.menurunkan,
    soilFit:
        'Tanah yang sudah kapur atau pH menengah, dan tanaman yang butuh belerang seperti bawang, kubis, dan padi.',
    soilWarn:
        'Lebih cepat membuat tanah asam daripada urea, jadi jangan dipakai terus-menerus pada tanah gambut atau tanah masam tanpa kapur.',
    deficiency:
        'Sama seperti kekurangan nitrogen, ditambah daun muda menguning pucat karena belerang tidak bergerak dari daun tua.',
    excess:
        'Tanah menjadi asam lebih cepat daripada urea, sehingga hara lain terkunci dan pertumbuhan akar terhambat.',
    method:
        'Tabur larikan di samping barisan lalu tutup tanah. Cocok untuk tanah yang tidak terlalu asam.',
    split: 'Diberikan 2 kali bersamaan dengan pemupukan nitrogen pertama.',
    phases: ['awal', 'veg'],
    maxPerHaOnce: 250,
  ),
  FertKind(
    id: 'sp36',
    label: 'SP-36',
    unsur: 'Fosfor (P2O5) 36%',
    fungsi:
        'Membentuk akar, bunga, dan biji; tersedia lambat sehingga harus lebih dulu masuk tanah.',
    match: ['sp-36', 'sp 36', 'tsp', 'super fosfat'],
    feeds: 'akar, bunga, dan biji',
    phEffect: PhEffect.netral,
    soilFit:
        'Tanah mineral yang pH-nya 5,5 sampai 7,5, ditempatkan di lubang atau larikan dekat akar.',
    soilWarn:
        'Pada tanah sangat masam atau sangat basa, fosfor langsung diikat besi/aluminium sehingga hilang; pada tanah liat padat sebarannya sangat pendek, jadi harus dekat akar.',
    deficiency:
        'Tanaman kerdil sejak kecil, daun tua menguning keunguan, akar sedikit, bunga rontok dan biji hampa.',
    excess:
        'Fosfor berlebih tidak terlihat langsung, tetapi mengikat seng dan besi di tanah sehingga tanaman justru kekurangan unsur mikro; pemborosan karena harganya mahal.',
    method:
        'Tabur atau tempatkan di lubang tanam sebelum bibit ditanam, karena fosfor hampir tidak bergerak di tanah. Jangan ditebar di permukaan.',
    split:
        'Sebaiknya sekali saja, seluruh dosis, saat pengolahan tanah atau lubang tanam.',
    phases: ['olah', 'awal'],
  ),
  FertKind(
    id: 'kcl',
    label: 'KCl',
    unsur: 'Kalium (K2O) 60%',
    fungsi:
        'Mengatur air dalam tanaman, memperkuat batang, dan mengisi buah, biji, atau umbi.',
    match: ['kcl', 'zk', 'mop', 'kalium'],
    feeds: 'buah, biji, dan umbi',
    phEffect: PhEffect.netral,
    soilFit:
        'Tanah berpasir dan tanah bergambut yang cepat kehilangan kalium, serta semua tanaman yang dipanen buahnya.',
    soilWarn:
        'Pada tanah liat alkalis kalium sudah banyak terikat sehingga hasilnya kecil. Hindari pada tanaman sensitif klorida seperti tembakau, kentang bibit, dan beberapa buah.',
    deficiency:
        'Ujung dan tepi daun tua mengering seperti terbakar, batang lemah, buah kecil tidak merata, umbi tidak berisi.',
    excess:
        'Penyerapan magnesium dan kalsium terhambat, daun menguning di antara tulang daun, dan pada tanaman sensitif klorida mutu hasilnya turun.',
    method:
        'Tabur di sekitar zona akar pada tanah lembap lalu tutup. Untuk tanaman keras, buat parit melingkar di bawah tepi tajuk.',
    split:
        'Bagi 2 kali, misalnya saat mulai berbunga dan saat buah mulai mengisi.',
    phases: ['veg', 'gen', 'isi'],
    maxPerHaOnce: 150,
  ),
  FertKind(
    id: 'npk',
    label: 'NPK majemuk',
    unsur: 'N, P, dan K dalam satu butiran (misal 16-16-16)',
    fungsi:
        'Praktis untuk pemupukan rutin karena ketiga hara utama masuk bersamaan.',
    match: ['npk', 'phonska', 'mutiara'],
    feeds: 'pertumbuhan menyeluruh',
    phEffect: PhEffect.menurunkan,
    soilFit:
        'Tanah yang belum pernah diuji sama sekali, karena ketiga hara utama terjamin sekaligus.',
    soilWarn:
        'Perbandingan haranya tetap, padahal tanaman butuh banyak kalium justru di fase buah — jadi NPK saja biasanya kurang pada fase itu.',
    deficiency:
        'Gejalanya campuran: tanaman kerdil, daun pucat, dan buah atau biji tidak terisi.',
    excess:
        'Garam terkonsentrasi di sekitar akar sehingga akar muda terbakar, tepi daun cokelat, dan tanaman layu walau tanah masih basah. Hara yang tidak terpakai tercuci.',
    method:
        'Tabur larikan 5 sampai 10 cm dari batang lalu tutup tanah dan siram. Bisa dikocor untuk tanaman yang masih kecil.',
    split:
        'Bagi 2 sampai 3 kali. Jangan memberi seluruh dosis sekaligus, terutama pada tanah berpasir.',
    phases: ['awal', 'veg', 'gen'],
    maxPerHaOnce: 300,
  ),
  FertKind(
    id: 'kandang',
    label: 'Pupuk kandang',
    unsur: 'Hara lengkap rendah + bahan organik',
    fungsi:
        'Memperbaiki struktur dan daya tahan tanah sambil menyediakan hara perlahan.',
    match: ['kandang', 'pupuk organik', 'jerami'],
    feeds: 'keseluruhan tanah dan akar',
    phEffect: PhEffect.netral,
    soilFit:
        'Tanah berpasir yang cepat kering dan tanah liat yang padat — keduanya menjadi lebih gembur.',
    soilWarn:
        'Pada tanah yang sudah subur, tambahan haranya kecil sehingga efeknya lebih ke struktur daripada ke hasil.',
    deficiency:
        'Tanah menjadi padat, sulit menyimpan air, hara mudah tercuci, dan hasil menurun pada musim berikutnya.',
    excess:
        'Kandang yang belum matang justru membakar akar dan membawa biji rumput serta patogen. Terlalu banyak juga menaikkan kadar amonia.',
    method:
        'Sebar merata lalu balik ke dalam tanah 1 sampai 4 minggu sebelum tanam, hanya untuk kandang yang sudah matang (remah, tidak berbau tajam).',
    split: 'Sekali per musim tanam, saat pengolahan tanah.',
    phases: ['olah'],
  ),
  FertKind(
    id: 'kompos',
    label: 'Kompos',
    unsur: 'Bahan organik matang + hara lengkap rendah',
    fungsi:
        'Menambah bahan organik dan kehidupan mikroba tanah; haranya kecil tetapi tersedia stabil.',
    match: ['kompos'],
    feeds: 'keseluruhan tanah dan akar',
    phEffect: PhEffect.netral,
    soilFit:
        'Semua jenis tanah, terutama tanah tandas atau bekas pertanian intensif.',
    soilWarn:
        'Kompos dari sampah kota bisa membawa logam berat; pakai bahan asal yang diketahui.',
    deficiency:
        'Bahan organik tanah turun, tanah menjadi keras setelah hujan lalu pecah saat kemarau.',
    excess:
        'Jarang membakar tanaman, tetapi haranya tidak cukup untuk tanaman berat.',
    method:
        'Sebar di barisan atau lubang tanam lalu aduk dengan lapisan atas tanah. Bisa juga sebagai mulsa di pangkal batang.',
    split: 'Sekali per musim, atau tiap tahun untuk tanaman keras.',
    phases: ['olah'],
  ),
  FertKind(
    id: 'kapur',
    label: 'Kapur / dolomit',
    unsur: 'Kalsium (Ca) dan pada dolomit juga magnesium (Mg)',
    fungsi: 'Menaikkan pH tanah dan menyediakan kalsium serta magnesium.',
    match: ['dolomit', 'kapur', 'gipsum', 'kaptan'],
    feeds: 'ketersediaan semua hara',
    phEffect: PhEffect.menaikkan,
    soilFit:
        'Tanah masam di bawah pH 5,5 — kondisi sebagian besar lahan tua di Indonesia.',
    soilWarn:
        'Pada tanah yang sudah di atas pH 7, kapur justru mengunci besi, mangan, dan seng.',
    deficiency:
        'Pada tanah asam, hara fosfor terkunci dan daun menguning di antara tulang daun; pertumbuhan akar berhenti.',
    excess:
        'pH melonjak, dan besi, mangan, serta seng menjadi tidak tersedia sehingga daun muda menguning. Kapur berlebih juga membuat tanah menggumpal.',
    method:
        'Sebar halus merata setelah pengolahan tanah, lalu aduk dan biarkan 2 sampai 4 minggu sebelum tanam. Jangan diberikan bersamaan dengan pupuk kandang atau amonium karena nitrogen hilang sebagai amonia.',
    split: 'Sekali per musim atau per tahun, berdasarkan hasil uji pH.',
    phases: ['olah'],
  ),
  FertKind(
    id: 'kieserit',
    label: 'Kieserit',
    unsur: 'Magnesium (MgO) 27% + belerang',
    fungsi: 'Membentuk klorofil sehingga daun hijau penuh.',
    match: ['kieserit', 'magnesium'],
    feeds: 'hijau daun dan mutu',
    phEffect: PhEffect.netral,
    soilFit:
        'Tanah berpasir dan tanah asam yang banyak dicuci hujan, serta lahan yang sering diberi KCl.',
    soilWarn: 'Pada tanah liat kaya magnesium biasanya tidak diperlukan.',
    deficiency:
        'Daun tua menguning di antara tulang daun tetapi tulangnya tetap hijau.',
    excess: 'Mengganggu penyerapan kalsium dan kalium.',
    method:
        'Tabur di sekitar zona akar lalu siram, atau semprot encer pada daun.',
    split: 'Sekali atau dua kali selama musim.',
    phases: ['veg', 'gen'],
  ),
  FertKind(
    id: 'boraks',
    label: 'Boraks / boron',
    unsur: 'Mikro hara boron (B)',
    fungsi: 'Menunjang pembungaan, penyerbukan, dan isi buah.',
    match: ['boraks', 'boron', 'borat'],
    feeds: 'bunga dan isi buah',
    phEffect: PhEffect.netral,
    soilFit:
        'Tanah pH tinggi atau tanah berkapur, tempat boron sulit tersedia.',
    soilWarn:
        'Selisih antara cukup dan racun sangat sempit, jadi hanya dipakai bila gejalanya memang ada.',
    deficiency:
        'Bunga rontok, buah atau umbi berongga dan pecah, titik tumbuh mati.',
    excess:
        'Boron menjadi racun pada selisih dosis yang kecil: tepi daun mengering lalu daun gugur. Jangan pernah menggandakan dosis.',
    method:
        'Larutkan lalu semprot ke daun pada pagi hari, atau tabur merata bersama pupuk lain. Jangan menyiramkan larutan pekat di satu titik.',
    split: 'Satu sampai dua kali, hanya saat berbunga.',
    phases: ['gen'],
  ),
];

/// Mencari jenis pupuk untuk nama bebas pada `Fert`. Mengembalikan `null` bila
/// tidak dikenal, agar layar tetap dapat menampilkan dosis tanpa mengarang
/// gejala yang menyertainya.
FertKind? kindFor(String name) {
  final n = name.toLowerCase();
  for (final k in fertKinds) {
    for (final m in k.match) {
      if (n.contains(m)) return k;
    }
  }
  return null;
}
