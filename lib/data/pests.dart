import '../models/commodity.dart';

/// Pusat Hama & Penyakit — panduan gejala, pencegahan, dan penanganan.
///
/// [categories] merujuk pada commodityCategories; nilai kosong berarti semua
/// kategori.
class PestInfo {
  final String id, name, emoji, brief;
  final List<String> categories;
  final List<String> commodityIds;
  final List<String> symptoms;
  final List<String> prevention;
  final List<String> treatment;
  final bool severe;

  const PestInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.brief,
    this.categories = const [],
    this.commodityIds = const [],
    required this.symptoms,
    required this.prevention,
    required this.treatment,
    this.severe = false,
  });

  bool matchCategory(String cat) =>
      categories.isEmpty || categories.contains(cat);

  bool matchCommodity(String id) =>
      commodityIds.contains(id) ||
      (commodityIds.isEmpty && matchCategory(commodityById(id).category));
}

final pests = <PestInfo>[
  const PestInfo(
    id: 'kutu-daun',
    name: 'Kutu Daun (Aphids)',
    emoji: '',
    brief: 'Serangga kecil pengisap daun muda, pembawa virus.',
    categories: ['Sayuran', 'Rempah'],
    symptoms: [
      'Daun muda keriting, melengkung ke bawah, dan mengkerut.',
      'Permukaan daun lengket (embun madu) dan sering dihinggapi semut.',
      'Coloni kutu hijau/hitam terlihat di balik daun dan pucuk.',
    ],
    prevention: [
      'Pasang perangkap kuning lengket beberapa meter dari bedengan.',
      'Jangan berlebih pupuk nitrogen — jaringan muda terlalu lunak.',
      'Tanam bunga pengusir (kenikir, zinnia) di tepi bedengan.',
    ],
    treatment: [
      'Semprot air kuat untuk merontokkan koloni bila serangan awal.',
      'Aplikasikan insektisida nabati (minyak nimba / sabun larut).',
      'Pada serangan berat: rotasi bahan aktif insektisida, semprot sore hari.',
    ],
  ),
  const PestInfo(
    id: 'thrips-cabai',
    name: 'Thrips & Virus Keriting',
    emoji: '🌶️',
    brief: 'Hama utama cabai; menyebarkan virus keriting daun.',
    categories: ['Sayuran'],
    commodityIds: ['cabai', 'tomat', 'terong'],
    symptoms: [
      'Ujung daun muda menggulung ke atas dan kaku.',
      'Lingkaran kecokelatan pada buah (bekas gigitan thrips).',
      'Tanaman kerdil dan bunga rontok bila tertular virus.',
    ],
    prevention: [
      'Gunakan mulsa perak untuk mengusir thrips dan memantulkan cahaya.',
      'Pasang perangkap kuning + jaring pelindung sejak pembibitan.',
      'Tanam serempak dalam satu hamparan, hindari inang alternatif.',
    ],
    treatment: [
      'Cabut dan bakar tanaman yang sudah tertular virus (tidak bisa sembuh).',
      'Semprot insektisida sistemik pada fase bibit; rotasi bahan aktif.',
      'Kendalikan semut yang memelihara koloni thrips.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'antraknosa',
    name: 'Antraknosa (Pateak)',
    emoji: '🍄',
    brief: 'Jamur penyebab bercak tenggelam pada buah.',
    categories: ['Sayuran', 'Buah'],
    commodityIds: ['cabai', 'tomat', 'semangka', 'melon', 'timun'],
    symptoms: [
      'Bercak bulat tenggelam pada buah dengan cincin hitam-kemerahan.',
      'Buah membusuk dari ujung dan sering mengering menggantung.',
      'Menjalar cepat saat cuaca lembap dan banyak hujan.',
    ],
    prevention: [
      'Atur jarak tanam agar sirkulasi udara baik dan daun cepat kering.',
      'Sanitasi: bersihkan sisa tanaman dan buah jatuh dari area.',
      'Rotasi tanaman minimal 1 musim dengan bukan famili terong-terongan.',
    ],
    treatment: [
      'Petik dan buang buah bergejala jauh dari lahan (jangan dikompos).',
      'Semprot fungisida kontak (mancozeb) + sistemik (benomil) bergantian.',
      'Kurangi penyiraman over-head; siram ke tanah, bukan daun.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'lalat-buah',
    name: 'Lalat Buah',
    emoji: '🪰',
    brief: 'Belitnya menggerek buah dari dalam.',
    categories: ['Buah', 'Sayuran'],
    commodityIds: ['pepaya', 'pisang', 'melon', 'timun', 'cabai'],
    symptoms: [
      'Titik tusukan pada kulit buah, buah busuk sebelum matang.',
      'Belatung kecil berwarna putih-krem di dalam buah.',
      'Buah jatuh dini dan bau asam.',
    ],
    prevention: [
      'Bungkus buah (kertas/kantong plastik berlubang) sejak 2 minggu setelah bunga mekar.',
      'Pasang perangkap metil eugenol di tepi lahan.',
      'Bersihkan buah jatuh setiap hari — putusnya siklus perkembangbiakan.',
    ],
    treatment: [
      'Kumpulkan buah terserang, rendam air 1–2 hari atau kubur > 30 cm.',
      'Semprot umpan protein + insektisida di sore hari pada titik-titik hinggap.',
      'Sanitasi kebun tetangga serentak bila memungkinkan.',
    ],
  ),
  const PestInfo(
    id: 'wereng-padi',
    name: 'Wereng Batang Cokelat',
    emoji: '🌾',
    brief: 'Pengisap pangkal batang padi penyebab "taman tebu".',
    categories: ['Pangan'],
    commodityIds: ['padi'],
    symptoms: [
      'Rumpun menguning dan mengering seperti terbakar, meluas dari satu titik.',
      'Bangkai wereng dan busa di pangkal batang.',
      'Parah pada varietas rentan + pupuk N tinggi + jarak tanam rapat.',
    ],
    prevention: [
      'Tanam varietas tahan dan jajar legowo untuk udara lancar.',
      'Pengairan berselang memutus siklus wereng.',
      'Hindari insektisida spektrum luas yang membunuh predator.',
    ],
    treatment: [
      'Semprot selektif (buprofezin/imidakloprid) hanya pada radius serangan.',
      'Turunkan populasi cepat sebelum menyebar — wereng berkembang biak eksponensial.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'ulat-graya',
    name: 'Ulat Graya Jagung',
    emoji: '🐛',
    brief: 'Fall armyworm: merusak daun dan titik tumbuh jagung.',
    categories: ['Pangan'],
    commodityIds: ['jagung'],
    symptoms: [
      'Lubang tidak beraturan pada daun dengan serbuk gergaji di ketiak daun.',
      'Titik tumbuh (heart) digerogoti, tanaman muda bisa mati.',
      'Ulat bergaris kepala membentuk huruf Y terbalik.',
    ],
    prevention: [
      'Tanam lebih awal dan serempak agar lolos generasi puncak hama.',
      'Semprot ekstrak nimba pada fase 1–4 daun.',
      'Pasang beacon trap / tanaman pemburu di sekitar lahan.',
    ],
    treatment: [
      'Aplikasi insektisida tepat di titik tumbuh (arahkan semprotan ke kerucut daun).',
      'Manfaatkan musuh alami: Trichogramma, predator, dan burung.',
      'Rotasi bahan aktif untuk mencegah resistensi.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'busuk-akar',
    name: 'Busuk Akar & Layu Fusarium',
    emoji: '💧',
    brief: 'Jamur tular tanah akibat drainase buruk.',
    symptoms: [
      'Tanaman layu siang hari lalu pulih pagi — makin lama menetap.',
      'Pangkal batang menghitam, akar kecokelatan dan hancur.',
      'Menyebar lewat air genangan dan alat kerja.',
    ],
    prevention: [
      'Bedengan tinggi + saluran drainase; jangan tanam di lahan tergenang.',
      'Rotasi tanaman dan solarisasi tanah sebelum musim baru.',
      'Gunakan bibit sehat dan perlakuan Trichoderma pada lubang tanam.',
    ],
    treatment: [
      'Cabut tanaman sakit, taburi kapur dolomit di lubang bekasnya.',
      'Kurangi frekuensi siram; biarkan lapisan atas tanah mengering.',
      'Fungisida sistemik (metalaksil) hanya membantu pada infeksi awal.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'hawar-kentang',
    name: 'Hawar Daun (Late Blight)',
    emoji: '🥔',
    brief: 'Penyakit kentang/tomat penyebab busuk daun cepat menular.',
    categories: ['Sayuran'],
    commodityIds: ['kentang', 'tomat'],
    symptoms: [
      'Bercak basah tak beraturan pada tepi daun dengan lingkaran putih kabur.',
      'Batang hitam dan tanaman rebah dalam hitungan hari.',
      'Umbi berbintik cokelat dengan busuk masuk ke dalam.',
    ],
    prevention: [
      'Gunakan umbi/benih bersertifikat bebas penyakit.',
      'Pembumbunan tinggi dan hindari daun basah terlalu lama.',
      'Fungisida protektif terjadwal saat kelembapan tinggi.',
    ],
    treatment: [
      'Pangkas dan buang bagian terserang, jangan dikompos.',
      'Semprot fungisida kontak + sistemik bergantian, ulangi 7–10 hari.',
      'Panen umbi segera bila busuk mulai masuk, keringkan sebelum simpan.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'bercak-ungu',
    name: 'Bercak Ungu Bawang',
    emoji: '🧅',
    brief: 'Jamur Alternaria pada daun bawang merah.',
    categories: ['Sayuran'],
    commodityIds: ['bawangmerah'],
    symptoms: [
      'Bercak oval putih-kuning membesar menjadi ungu dengan cincin konsentris.',
      'Ujung daun mengering seperti terbakar, fotosintesis turun.',
      'Serangan parah membuat umbi kecil dan tahan simpan rendah.',
    ],
    prevention: [
      'Jarak tanam cukup dan penyiraman pagi agar daun cepat kering.',
      'Gunakan umbi bibit sehat, rendam fungisida sebelum tanam.',
      'Rotasi 2–3 musim dengan bukan bawang-bawangan.',
    ],
    treatment: [
      'Semprot fungisida (mancozeb/klorotalonil) 7 hari sekali saat lembap.',
      'Buang daun terserang berat dari lahan.',
    ],
  ),
  const PestInfo(
    id: 'ulat-daun',
    name: 'Ulat Daun Kubis (Plutella)',
    emoji: '🥬',
    brief: 'Lubang kecil penuh di daun sawi, kubis, dan pakcoy.',
    categories: ['Sayuran'],
    commodityIds: ['kubis', 'sawi', 'kacangpanjang'],
    symptoms: [
      'Jendela transparan pada daun lalu berlubang.',
      'Ulat hijau kecil menggantung dengan benang sutra saat diganggu.',
      'Krop kubis terisi kotoran dan rapuh.',
    ],
    prevention: [
      'Tutup bedengan dengan jaring halus sejak semai.',
      'Tanam tanaman perangkap (lobak/sawi pahit) di keliling.',
      'Kumpulkan telur dan ulat pagi hari secara manual.',
    ],
    treatment: [
      'Semprot Bt (Bacillus thuringiensis) — efektif dan aman panen dekat.',
      'Insektisida kontak sore hari bila ledakan populasi.',
    ],
  ),
  const PestInfo(
    id: 'penggerek-polong',
    name: 'Penggerek Polong Kedelai',
    emoji: '🫘',
    brief: 'Larva memakan biji di dalam polong.',
    categories: ['Pangan'],
    commodityIds: ['kedelai', 'kacangtanah'],
    symptoms: [
      'Lubang bulat bersih pada polong dengan butiran kotoran.',
      'Biji bolong dan berkurang bobotnya saat disimpan.',
      'Ngengat kecil aktif terbang sore menjelang malam.',
    ],
    prevention: [
      'Tanam tepat awal musim agar fase polong lolos puncak populasi ngengat.',
      'Perangkap lampu untuk memantau dan mengurangi ngengat.',
      'Jangan menunda panen lebih dari 10 hari setelah polong masak.',
    ],
    treatment: [
      'Semprot saat ambang: 2 ulat per tanaman pada fase pengisian biji.',
      'Simpan biji dengan daun salam / suhu rendah untuk menekan larva sisa.',
    ],
  ),
  const PestInfo(
    id: 'busuk-rimpang',
    name: 'Busuk Rimpang Jahe & Kunyit',
    emoji: '🫚',
    brief: 'Layu dan bau pada rimpang akibat jamur/bakteri.',
    categories: ['Rempah'],
    commodityIds: ['jahe', 'kunyit', 'serai'],
    symptoms: [
      'Daun menguning lalu layu meski tanah lembap.',
      'Rimpang lunak, berair, dan bau tajam tidak sedap.',
      'Menular cepat lewat air yang menggenang.',
    ],
    prevention: [
      'Hanya rimpang bibit sehat; rendam fungisida + bakterisida sebelum tanam.',
      'Bedengan tinggi dengan saluran drainase dalam.',
      'Rotasi lahan minimal 2 tahun untuk lahan endemik.',
    ],
    treatment: [
      'Bongkar tanaman sakit dan taburi lubang dengan dolomit.',
      'Hentikan sementara pengairan berlebihan; keringkan zona perakaran.',
    ],
  ),
  const PestInfo(
    id: 'kutu-putih',
    name: 'Kutu Putih & Semut',
    emoji: '⚪',
    brief: 'Gumpalan putih di ketiak daun dan batang.',
    symptoms: [
      'Bintik seperti kapas menempel pada ketiak daun, batang, dan buah muda.',
      'Daun menguning dan tumbuh kerdil karena cairan diisap.',
      'Sering ada semut yang "memelihara" kutu.',
    ],
    prevention: [
      'Pangkas agar tajuk tidak terlalu lembap dan rapat.',
      'Putus akses semut dengan perangkap lem di batang/pancang.',
      'Lepaskan predator Cryptolaemus bila tersedia.',
    ],
    treatment: [
      'Lap/semprot air sabun pada koloni kecil.',
      'Minyak nimba / petrolium emulsi pada serangan luas, semprot balik daun.',
    ],
  ),
  const PestInfo(
    id: 'tikus',
    name: 'Tikus Sawah',
    emoji: '🐀',
    brief: 'Merusak batang muda dan menggerek bulir isi susu.',
    categories: ['Pangan'],
    commodityIds: ['padi', 'jagung'],
    symptoms: [
      'Bekas potongan serong pada batang seperti digunting.',
      'Jejak dan lubang di pematang; bulir hilang sebagian.',
      'Kerusakan parah pada pertanaman tidak serempak.',
    ],
    prevention: [
      'Tanam serempak seluas hamparan agar tikus kehabisan inang bergilir.',
      'Gropyokan dan sanitasi semak di sekitar lahan.',
      'Pasang pagar tanaman border (serai/vezu) di tepi hamparan.',
    ],
    treatment: [
      'Umpan beracun (rodentisida) di lubang aktif, hati-hati hewan peliharaan.',
      'Perangkap bukaan dan EMPO (rumah tikus) dengan predator.',
    ],
  ),
  const PestInfo(
    id: 'botrytis-stroberi',
    name: 'Busuk Kelabu Stroberi (Botrytis)',
    emoji: '🍓',
    brief: 'Jamur abu-abu pada buah matang di cuaca lembap.',
    categories: ['Buah'],
    commodityIds: ['stroberi'],
    symptoms: [
      'Buah matang berbulu abu-abu dan lembek dari ujung.',
      'Bunga mengering dan mati sebelum jadi buah.',
      'Menyebar cepat saat hujan berkepanjangan dan tajuk rapat.',
    ],
    prevention: [
      'Mulsa plastik / jerami agar buah tidak menyentuh tanah basah.',
      'Jarak tanam longgar dan pangkas daun tua rutin.',
      'Siram pagi ke tanah, hindari membasahi buah dan bunga.',
    ],
    treatment: [
      'Petik buah terinfeksi tiap pagi, buang jauh dari lahan.',
      'Fungisida berbahan aktif berbeda bergantian saat lembap tinggi.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'cpvd-jeruk',
    name: 'CVPD / Huanglongbing Jeruk',
    emoji: '🍊',
    brief: 'Penyakit bakteri mematikan jeruk, dibawa kutu Diaphorina.',
    categories: ['Buah'],
    commodityIds: ['jeruk', 'lemon'],
    symptoms: [
      'Belang kuning tidak simetris pada daun (bukan kuning seragam).',
      'Buah kecil, miring, dan masam dengan biji kempis.',
      'Tunas baru kaku, pendek, dan menguning seperti roset.',
    ],
    prevention: [
      'Gunakan bibit bersertifikat bebas CVPD.',
      'Kendalikan vektor kutu Diaphorina dengan insektisida terjadwal.',
      'Cabut segera pohon tertular agar tidak jadi sumber penularan.',
    ],
    treatment: [
      'Belum ada obat; bongkar dan bakar pohon positif.',
      'Sanitasi kebun dan kontrol vektor ketat pada tanaman sehat.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'karat-daun-kopi',
    name: 'Karat Daun Kopi (Hemileia)',
    emoji: '☕',
    brief: 'Bubuk oranye di bawah daun kopi penyebab gugur daun.',
    categories: ['Perkebunan'],
    commodityIds: ['kopi'],
    symptoms: [
      'Bercak kuning di permukaan daun, bubuk oranye di baliknya.',
      'Daun gugur dini sehingga cabang gundul dari bawah.',
      'Produksi turun drastis pada musim hujan berkepanjangan.',
    ],
    prevention: [
      'Tanam varietas tahan (mis. sebagian robusta) dan naungan cukup.',
      'Pangkas teratur agar tajuk tidak lembap dan rapat.',
      'Pupuk berimbang; tanaman stres lebih rentan.',
    ],
    treatment: [
      'Fungisida tembaga (Cu) saat awal musim hujan.',
      'Kumpulkan dan bakar daun gugur untuk menekan inokulum.',
    ],
  ),
  const PestInfo(
    id: 'pbk-kakao',
    name: 'Penggerek Buah Kakao (PBK)',
    emoji: '🍫',
    brief: 'Ulat menggerek biji kakao dari dalam buah.',
    categories: ['Perkebunan'],
    commodityIds: ['kakao'],
    symptoms: [
      'Buah muda belang-belang dan bentuk tidak normal.',
      'Biji lengket satu sama lain dan berwarna cokelat kehitaman.',
      'Lubang keluar kecil pada kulit buah saat ulat dewasa keluar.',
    ],
    prevention: [
      'Panen sering (tiap 7 hari) dan sanitasi buah terserang.',
      'Pangkas dan atur naungan agar tajuk tidak terlalu rimbun.',
      'Sarang semut hitam (Dolichoderus) sebagai musuh alami.',
    ],
    treatment: [
      'Kumpulkan dan benamkan buah terserang > 30 cm.',
      'Insektisida hanya pada ambang ekonomi, rotasi bahan aktif.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'layu-panama',
    name: 'Layu Fusarium / Penyakit Panama',
    emoji: '🍌',
    brief: 'Jamur tular tanah mematikan pada pisang.',
    categories: ['Buah'],
    commodityIds: ['pisang'],
    symptoms: [
      'Daun tua menguning dari tepi lalu layu dan patah pada pelepah.',
      'Belahan batang dalam berwarna cokelat kemerahan.',
      'Tanaman mati meski tanah lembap; menyebar lewat air dan alat.',
    ],
    prevention: [
      'Bibit kultur jaringan bebas penyakit, bukan anakan dari kebun sakit.',
      'Rotasi lahan dan drainase baik; hindari lahan endemik.',
      'Sterilkan alat kerja antar blok kebun.',
    ],
    treatment: [
      'Bongkar dan bakar rumpun sakit termasuk bonggolnya.',
      'Taburi dolomit / Trichoderma pada lubang bekas untuk menekan jamur.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'lalat-buah-mangga',
    name: 'Lalat Buah Mangga',
    emoji: '🥭',
    brief: 'Belatung dalam buah mangga menjelang matang.',
    categories: ['Buah'],
    commodityIds: ['mangga'],
    symptoms: [
      'Titik tusukan hitam pada kulit buah muda.',
      'Daging buah berlubang dan busuk dari dalam saat matang.',
      'Buah jatuh sebelum waktunya dengan belatung di dalamnya.',
    ],
    prevention: [
      'Bungkus buah dengan kertas sejak pentil sebesar telur.',
      'Perangkap metil eugenol 10–20 per hektar.',
      'Bersihkan buah jatuh harian untuk memutus siklus.',
    ],
    treatment: [
      'Kumpulkan buah terserang, kubur atau rendam air garam.',
      'Umpan protein + insektisida pada titik hinggap sore hari.',
    ],
  ),
  const PestInfo(
    id: 'busuk-umbi-singkong',
    name: 'Busuk Umbi Singkong',
    emoji: '🥔',
    brief: 'Jamur / bakteri pembusuk umbi saat panen dan simpan.',
    categories: ['Pangan'],
    commodityIds: ['singkong', 'ubijalar'],
    symptoms: [
      'Umbi berbau asam dan berlendir cokelat saat dibelah.',
      'Daun layu mendadak meski hujan cukup.',
      'Bercak hitam cekung pada kulit umbi di lahan.',
    ],
    prevention: [
      'Stek dari batang sehat; rendam fungisida sebelum tanam.',
      'Panen tepat umur, jangan tunda saat tanah basah.',
      'Keringkan umbi sebelum disimpan; hindari luka mekanis.',
    ],
    treatment: [
      'Buang umbi busuk dari gudang agar tidak menular.',
      'Rotasi 2 musim dengan tanaman bukan inang pada lahan endemik.',
    ],
  ),
  const PestInfo(
    id: 'penggerek-pucuk-tebu',
    name: 'Penggerek Pucuk & Batang Tebu',
    emoji: '🎋',
    brief: 'Ulat menggerek pucuk dan ruas batang tebu.',
    categories: ['Perkebunan'],
    commodityIds: ['tebu'],
    symptoms: [
      'Pucuk mati dan mengering (dead heart) mudah dicabut.',
      'Lubang gerek pada ruas dengan serbuk gerek di sekitarnya.',
      'Batang berbobot ringan dan kadar gula turun.',
    ],
    prevention: [
      'Tanam varietas tahan dan bibit sehat.',
      'Lepaskan parasit Trichogramma saat awal musim.',
      'Sanitasi sisa tanaman dan gulma inang.',
    ],
    treatment: [
      'Insektisida sistemik pada fase tunas bila serangan di atas ambang.',
      'Cabut dan bakar pucuk mati untuk mengurangi sumber ulat.',
    ],
  ),
  const PestInfo(
    id: 'ulat-tanah-tembakau',
    name: 'Ulat Tanah & Kutu Tembakau',
    emoji: '🍃',
    brief: 'Pemotong bibit dan pengisap daun tembakau.',
    categories: ['Perkebunan'],
    commodityIds: ['tembakau'],
    symptoms: [
      'Bibit terpotong pangkalnya pada malam hari.',
      'Daun berlubang dan keriting akibat isapan kutu.',
      'Pertumbuhan terhambat dan daun bawah menguning.',
    ],
    prevention: [
      'Olah tanah baik dan sanitasi gulma sebelum tanam.',
      'Perangkap cahaya untuk memantau ngengat ulat tanah.',
      'Jaga jarak tanam agar daun tidak saling lembap.',
    ],
    treatment: [
      'Tabur insektisida granula di sekitar pangkal bibit sore hari.',
      'Semprot insektisida kontak pada daun bila populasi kutu naik.',
    ],
  ),
  const PestInfo(
    id: 'busuk-putih-bawangputih',
    name: 'Busuk Putih Bawang Putih',
    emoji: '🧄',
    brief: 'Jamur Sclerotium dengan miselium putih pada umbi.',
    categories: ['Sayuran'],
    commodityIds: ['bawangputih', 'bawangmerah'],
    symptoms: [
      'Miselium putih seperti kapas pada pangkal batang dan umbi.',
      'Umbi lunak berair lalu mengering dan berongga.',
      'Bintik hitam kecil (sklerotia) pada sisa tanaman di tanah.',
    ],
    prevention: [
      'Umbi bibit sehat dan rotasi 3–4 tahun dengan bukan bawang-bawangan.',
      'Drainase baik; hindari tanah terlalu basah berkepanjangan.',
      'Solarisasi tanah atau biofungisida sebelum tanam.',
    ],
    treatment: [
      'Cabut tanaman sakit beserta tanah sekitarnya, bakar.',
      'Fungisida pada infeksi awal hanya memperlambat, bukan menyembuhkan.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'bercak-daun-wortel',
    name: 'Bercak Daun Wortel (Alternaria)',
    emoji: '🥕',
    brief: 'Bercak cokelat pada daun wortel menurunkan fotosintesis.',
    categories: ['Sayuran'],
    commodityIds: ['wortel'],
    symptoms: [
      'Bercak cokelat tua berbatas kuning pada tepi daun.',
      'Daun mengering dari pinggir dan tanaman tampak gosong.',
      'Umbi kecil karena daun rusak mengurangi pengisian.',
    ],
    prevention: [
      'Benih bersertifikat dan perlakuan benih fungisida.',
      'Jarak tanam cukup dan irigasi ke tanah, bukan daun.',
      'Rotasi 2 musim dengan tanaman beda famili.',
    ],
    treatment: [
      'Fungisida kontak (mancozeb) saat gejala pertama muncul.',
      'Buang daun terinfeksi berat dari lahan.',
    ],
  ),
  const PestInfo(
    id: 'karat-buncis',
    name: 'Karat Daun Buncis (Uromyces)',
    emoji: '🫛',
    brief: 'Bintik karat cokelat pada daun buncis dan kacang.',
    categories: ['Sayuran', 'Pangan'],
    commodityIds: ['buncis', 'kacangpanjang', 'kacangmerah', 'kacangpolong'],
    symptoms: [
      'Bintik kecil cokelat-karat menonjol di bawah daun.',
      'Daun menguning lalu gugur sebelum waktunya.',
      'Polong kecil dan biji tidak penuh pada serangan berat.',
    ],
    prevention: [
      'Varietas tahan dan jarak tanam longgar.',
      'Hindari penyiraman overhead sore hari.',
      'Rotasi tanaman dan sanitasi sisa panen.',
    ],
    treatment: [
      'Fungisida berbahan aktif berbeda bergantian tiap 7–10 hari.',
      'Petik dan buang daun terinfeksi awal.',
    ],
  ),
  const PestInfo(
    id: 'ulat-kangkung',
    name: 'Ulat & Kutu pada Kangkung-Bayam',
    emoji: '🥬',
    brief: 'Pemakan daun cepat pada sayuran daun panen pendek.',
    categories: ['Sayuran'],
    commodityIds: ['kangkung', 'sawi'],
    symptoms: [
      'Lubang tidak beraturan pada daun muda.',
      'Kotoran ulat hitam menempel di permukaan daun.',
      'Koloni kutu hijau di balik daun membuat daun keriting.',
    ],
    prevention: [
      'Jaring halus sejak semai untuk menghalangi ngengat bertelur.',
      'Rotasi cepat dan sanitasi sisa panen.',
      'Tanam serempak per bedengan agar panen bersamaan.',
    ],
    treatment: [
      'Semprot Bt atau insektisida nabati karena panen dekat.',
      'Kumpulkan ulat manual pagi hari pada lahan kecil.',
    ],
  ),
  const PestInfo(
    id: 'busuk-buah-labu',
    name: 'Busuk Buah Labu & Timun (Phytophthora)',
    emoji: '🎃',
    brief: 'Busuk basah pada buah cucurbitaceae di tanah basah.',
    categories: ['Sayuran', 'Buah'],
    commodityIds: ['labu', 'timun', 'semangka', 'melon'],
    symptoms: [
      'Bercak basah kebasahan pada sisi buah menyentuh tanah.',
      'Busuk meluas cepat dengan bau tanah pada cuaca lembap.',
      'Daun layu mendadak meski air cukup (infeksi pangkal).',
    ],
    prevention: [
      'Mulsa dan ajir agar buah tidak menempel tanah basah.',
      'Drainase baik dan irigasi tetes, hindari genangan.',
      'Rotasi 2–3 musim dengan bukan cucurbitaceae.',
    ],
    treatment: [
      'Buang buah terinfeksi jauh dari lahan.',
      'Fungisida sistemik (metalaksil) pada infeksi awal pangkal batang.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'virus-mosaik-paprika',
    name: 'Virus Mosaik & Kutu pada Paprika',
    emoji: '🫑',
    brief: 'Mosaik daun dan buah belang akibat virus bawaan kutu.',
    categories: ['Sayuran'],
    commodityIds: ['paprika', 'cabai', 'tomat'],
    symptoms: [
      'Belang hijau-muda/kuning tidak beraturan pada daun.',
      'Daun keriput, mengecil, dan tanaman kerdil.',
      'Buah belang dan bentuk tidak normal.',
    ],
    prevention: [
      'Bibit bebas virus dan sanitasi alat serta tangan pekerja.',
      'Kendalikan vektor kutu daun dan thrips sejak pembibitan.',
      'Cabut tanaman bergejala awal agar tidak jadi sumber.',
    ],
    treatment: [
      'Tidak ada obat virus; bongkar tanaman tertular.',
      'Fokus pada pengendalian vektor untuk tanaman sehat.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'busuk-batang-durian',
    name: 'Busuk Batang & Akar Durian (Phytophthora)',
    emoji: '🍈',
    brief: 'Jamur pembusuk batang dan akar pada durian dan manggis.',
    categories: ['Buah'],
    commodityIds: ['durian', 'manggis', 'alpukat'],
    symptoms: [
      'Bercak basah cokelat pada pangkal batang, sering keluar lendir.',
      'Daun menguning dari tajuk bawah lalu gugur.',
      'Akar halus membusuk dan berbau tanah saat digali.',
    ],
    prevention: [
      'Drainase baik; jangan menimbun tanah terlalu tinggi di pangkal.',
      'Bibit dari entres sehat dan lahan tidak tergenang.',
      'Hindari luka mekanis pada pangkal batang saat pemeliharaan.',
    ],
    treatment: [
      'Kerok jaringan sakit lalu oles fungisida sistemik pada luka.',
      'Suntik / kocor fungisida fosfit pada pohon berharga tinggi.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'busuk-buah-manggis',
    name: 'Busuk Buah & Getah Kuning Manggis',
    emoji: '🟣',
    brief: 'Getah kuning dan busuk buah menurunkan mutu ekspor.',
    categories: ['Buah'],
    commodityIds: ['manggis'],
    symptoms: [
      'Getah kuning mengeras pada kulit dan daging buah.',
      'Bercak cokelat cekung pada kulit buah menjelang panen.',
      'Buah busuk dari dalam meski kulit tampak normal.',
    ],
    prevention: [
      'Kurangi stres air: irigasi teratur saat pengisian buah.',
      'Sanitasi buah jatuh dan pangkas cabang sakit.',
      'Panen tepat masak dengan gunting, hindari buah jatuh.',
    ],
    treatment: [
      'Sortir ketat; buah bergetah tidak layak jual.',
      'Fungisida protektif saat musim hujan pada tajuk buah.',
    ],
  ),
  const PestInfo(
    id: 'busuk-batang-vanili',
    name: 'Busuk Batang Vanili (Fusarium)',
    emoji: '🌿',
    brief: 'Jamur pembusuk batang merambat pada vanili.',
    categories: ['Rempah'],
    commodityIds: ['vanili'],
    symptoms: [
      'Bercak cokelat kehitaman memanjang pada ruas batang.',
      'Batang mengering dari titik infeksi ke atas.',
      'Daun menguning lalu rontok pada ruas terserang.',
    ],
    prevention: [
      'Naungan cukup dan sirkulasi udara baik di para-para.',
      'Stek bibit sehat; hindari luka saat pengikatan.',
      'Sanitasi bagian sakit segera setelah terlihat.',
    ],
    treatment: [
      'Potong batang sakit 10 cm di bawah bercak, bakar.',
      'Oles / semprot fungisida pada bekas potongan dan sekitarnya.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'helopeltis-kakao-teh',
    name: 'Kepik Helopeltis (Pengisap Buah)',
    emoji: '🐞',
    brief: 'Kepik pengisap buah dan pucuk pada kakao, teh, dan jambu.',
    categories: ['Perkebunan'],
    commodityIds: ['kakao', 'teh'],
    symptoms: [
      'Bercak cekung hitam pada buah muda dan pucuk.',
      'Pucuk mati dan cabang berbentuk seperti sapu.',
      'Buah muda gugur atau berbentuk tidak normal.',
    ],
    prevention: [
      'Naungan teratur mengurangi populasi kepik.',
      'Sanitasi dan panen sering memutus sumber makanan.',
      'Konservasi musuh alami (semut, laba-laba).',
    ],
    treatment: [
      'Semprot insektisida kontak sore hari saat populasi naik.',
      'Fokus pada buah muda dan pucuk sebagai sasaran.',
    ],
  ),
  const PestInfo(
    id: 'blister-blight-teh',
    name: 'Blister Blight & Cacar Daun Teh',
    emoji: '🍵',
    brief: 'Jamur penyebab cacar dan lepuh pada daun teh muda.',
    categories: ['Perkebunan'],
    commodityIds: ['teh'],
    symptoms: [
      'Bercak transparan lalu lepuh putih pada daun muda.',
      'Daun muda melengkung dan mati sebelum dipetik.',
      'Produksi pucuk turun pada musim hujan lembap.',
    ],
    prevention: [
      'Pangkas naungan agar cahaya dan udara masuk.',
      'Petik sering agar daun muda tidak menumpuk.',
      'Hindari kebun terlalu rapat dan lembap.',
    ],
    treatment: [
      'Fungisida tembaga saat awal musim hujan.',
      'Buang pucuk terinfeksi saat pemetikan.',
    ],
  ),
  const PestInfo(
    id: 'busuk-bunga-cengkeh',
    name: 'Busuk Bunga & Gugur Daun Cengkeh',
    emoji: '🌸',
    brief: 'Jamur penyebab gugur bunga dan daun cengkeh.',
    categories: ['Rempah'],
    commodityIds: ['cengkeh'],
    symptoms: [
      'Bunga menghitam dan gugur sebelum panen.',
      'Bercak cokelat pada daun lalu gugur massal.',
      'Tajuk menipis dan produksi turun drastis.',
    ],
    prevention: [
      'Naungan cukup pada tanaman muda dan drainase baik.',
      'Sanitasi bunga dan daun gugur di bawah tajuk.',
      'Pupuk berimbang agar tanaman tidak stres.',
    ],
    treatment: [
      'Fungisida kontak saat awal musim berbunga lembap.',
      'Kumpulkan dan bakar sisa bunga gugur.',
    ],
  ),
  const PestInfo(
    id: 'ganoderma-sawit',
    name: 'Busuk Pangkal Batang (Ganoderma)',
    emoji: '🌴',
    brief: 'Jamur mematikan pangkal batang kelapa sawit dan karet.',
    categories: ['Perkebunan'],
    commodityIds: ['sawit', 'karet', 'kemiri'],
    symptoms: [
      'Daun tombak (spear) tidak membuka dan menguning.',
      'Tubuh buah jamur seperti kipas pada pangkal batang.',
      'Pangkal batang berongga dan tanaman miring lalu roboh.',
    ],
    prevention: [
      'Sanitasi tunggul dan sisa kayu saat pembukaan lahan.',
      'Aplikasi Trichoderma pada lubang tanam dan sekitar pangkal.',
      'Hindari luka mekanis pada pangkal batang.',
    ],
    treatment: [
      'Bongkar dan bakar tanaman sakit beserta akarnya.',
      'Isolasi area dengan parit agar miselium tidak menjalar.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'jamur-upas-karet',
    name: 'Jamur Upas & Alur Sadap Karet',
    emoji: '🌳',
    brief: 'Jamur pada cabang dan luka sadap pohon karet.',
    categories: ['Perkebunan'],
    commodityIds: ['karet'],
    symptoms: [
      'Lapisan putih-merah muda seperti sarang pada cabang.',
      'Cabang mati dan daun menggantung cokelat.',
      'Panel sadap busuk dan alur tidak pulih.',
    ],
    prevention: [
      'Jarak tanam dan pangkas agar tajuk tidak lembap.',
      'Sadap sesuai aturan agar luka tidak terlalu dalam.',
      'Oles fungisida pada panel sadap saat musim hujan.',
    ],
    treatment: [
      'Kerok jaringan jamur lalu oles fungisida pada luka.',
      'Potong cabang terinfeksi berat dan bakar.',
    ],
  ),
  const PestInfo(
    id: 'busuk-buah-apel',
    name: 'Kudis & Busuk Buah Apel',
    emoji: '🍎',
    brief: 'Kudis daun dan busuk buah pada apel dataran tinggi.',
    categories: ['Buah'],
    commodityIds: ['apel'],
    symptoms: [
      'Bercak hijau-zaitun berbulu pada daun dan buah muda.',
      'Buah bercak gabus dan bentuk tidak normal.',
      'Busuk cokelat melingkar pada buah matang di simpan.',
    ],
    prevention: [
      'Pangkas tajuk agar cepat kering setelah hujan.',
      'Varietas tahan dan sanitasi daun gugur.',
      'Fungisida protektif terjadwal saat musim hujan.',
    ],
    treatment: [
      'Fungisida sistemik + kontak bergantian saat gejala awal.',
      'Sortir buah bercak sebelum penyimpanan.',
    ],
  ),
  const PestInfo(
    id: 'embun-tepung-anggur',
    name: 'Embun Tepung & Busuk Buah Anggur',
    emoji: '🍇',
    brief: 'Lapisan putih tepung dan busuk tandan anggur.',
    categories: ['Buah'],
    commodityIds: ['anggur'],
    symptoms: [
      'Lapisan putih seperti tepung pada daun dan buah muda.',
      'Daun keriting dan mengering dari tepi.',
      'Tandan buah berjamur abu-abu dan rontok.',
    ],
    prevention: [
      'Pangkas dan atur kanopi agar udara lancar.',
      'Hindari penyiraman overhead; siram ke tanah.',
      'Buang daun dan tandan terinfeksi awal.',
    ],
    treatment: [
      'Fungisida belerang / sistemik saat gejala pertama.',
      'Ulangi 7–10 hari pada musim lembap.',
    ],
  ),
  const PestInfo(
    id: 'bintik-hitam-nanas',
    name: 'Busuk Hati & Bintik Nanas',
    emoji: '🍍',
    brief: 'Busuk hati dan bercak buah pada nanas.',
    categories: ['Buah'],
    commodityIds: ['nanas'],
    symptoms: [
      'Daun pusat mudah dicabut dan berbau busuk.',
      'Bercak cokelat cekung pada kulit buah.',
      'Buah kecil dan rasa hambar pada serangan berat.',
    ],
    prevention: [
      'Drainase baik; nanas tidak tahan genangan.',
      'Bibit sehat dan perlakuan fungisida sebelum tanam.',
      'Sanitasi sisa panen dan gulma inang.',
    ],
    treatment: [
      'Buang tanaman busuk hati beserta akarnya.',
      'Fungisida pada infeksi awal hanya memperlambat.',
    ],
  ),
  const PestInfo(
    id: 'kutu-perisai-lada',
    name: 'Kutu Perisai & Busuk Pangkal Lada',
    emoji: '🌶️',
    brief: 'Kutu pengisap dan jamur pembusuk pangkal lada.',
    categories: ['Rempah'],
    commodityIds: ['lada'],
    symptoms: [
      'Bintik cokelat menempel seperti perisai pada daun dan batang.',
      'Daun menguning dan rontok dari bawah.',
      'Pangkal batang membusuk dan tanaman layu mendadak.',
    ],
    prevention: [
      'Naungan dan drainase baik; hindari tanah tergenang.',
      'Sanitasi gulma dan sisa tanaman di sekitar tiang panjat.',
      'Kendalikan semut yang memelihara kutu.',
    ],
    treatment: [
      'Semprot minyak nimba / sabun pada koloni kutu.',
      'Kocor fungisida pada pangkal tanaman terinfeksi awal.',
    ],
  ),
  const PestInfo(
    id: 'ulat-bulu-sirsak',
    name: 'Ulat Bulu & Busuk Buah Sirsak',
    emoji: '🍏',
    brief: 'Pemakan daun dan busuk buah pada sirsak dan belimbing.',
    categories: ['Buah'],
    commodityIds: ['sirsak', 'belimbing'],
    symptoms: [
      'Daun berlubang dan tersisa tulang daunnya.',
      'Ulat berbulu menempel berkelompok di balik daun.',
      'Buah bercak cokelat dan busuk dari titik luka.',
    ],
    prevention: [
      'Kumpulkan kelompok telur dan ulat secara manual.',
      'Sanitasi buah jatuh dan pangkas cabang rapat.',
      'Konservasi predator dan parasitoid alami.',
    ],
    treatment: [
      'Semprot Bt atau insektisida nabati pada koloni muda.',
      'Buang buah busuk jauh dari lahan.',
    ],
  ),
  const PestInfo(
    id: 'layu-bakteri-sayuran',
    name: 'Layu Bakteri (Ralstonia)',
    emoji: '🦠',
    brief: 'Layu mendadak akibat bakteri tular tanah pada sayuran.',
    categories: ['Sayuran'],
    commodityIds: ['tomat', 'cabai', 'kentang', 'terong'],
    symptoms: [
      'Tanaman layu mendadak siang hari meski tanah lembap.',
      'Daun tetap hijau saat layu (beda dengan layu fusarium).',
      'Lendir putih keluar dari potongan batang yang direndam air.',
    ],
    prevention: [
      'Rotasi 2–3 musim dengan tanaman bukan inang (jagung/padi).',
      'Bedengan tinggi dan drainase baik; hindari luka akar.',
      'Bibit sehat dan sanitasi alat kerja antar bedengan.',
    ],
    treatment: [
      'Cabut dan bakar tanaman sakit beserta tanah sekitarnya.',
      'Bakterisida tembaga hanya menekan penularan, tidak menyembuhkan.',
    ],
    severe: true,
  ),
  const PestInfo(
    id: 'embun-bulu-timun',
    name: 'Embun Bulu (Downy Mildew)',
    emoji: '🍃',
    brief: 'Jamur embun bulu pada daun timun dan sayuran daun.',
    categories: ['Sayuran'],
    commodityIds: ['timun', 'melon', 'semangka', 'labu', 'sawi'],
    symptoms: [
      'Bercak kuning bersudut di permukaan daun, dibatasi tulang daun.',
      'Lapisan abu-ungu seperti bulu di balik daun saat lembap.',
      'Daun mengering dari tepi dan tanaman gundul sebelum panen.',
    ],
    prevention: [
      'Jarak tanam longgar dan ajir agar daun cepat kering.',
      'Irigasi ke tanah pagi hari, hindari daun basah sore.',
      'Rotasi 2 musim dengan tanaman beda famili.',
    ],
    treatment: [
      'Fungisida kontak + sistemik bergantian tiap 7 hari saat lembap.',
      'Buang daun terinfeksi berat dari lahan.',
    ],
  ),
];

final pestCategories = ['Semua', ...commodityCategories];
