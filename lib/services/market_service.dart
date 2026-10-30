import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../core/i18n.dart';
import '../models/commodity.dart';
import 'supabase_gate.dart';

/// Asal-usul satu angka harga dari tabel `harga` di Supabase.
///
/// Kolom [sumber] diisi bebas oleh pihak yang menulis tabel, sehingga nilainya
/// dapat berupa 'Pasar Induk Kediri' (harga nyata) atau 'contoh' /
/// 'basis-simulasi' (angka bawaan yang masih menempati tabel). Aplikasi tidak
/// boleh menampilkan dirinya sebagai sumber nyata hanya karena angkanya datang
/// dari server.
class HargaAsal {
  final String sumber;
  final DateTime tanggal;
  const HargaAsal(this.sumber, this.tanggal);

  static const _pembawa = {'contoh', 'basis-simulasi', 'simulasi-harian'};
  bool get nyata =>
      sumber.isNotEmpty &&
      !_pembawa.contains(sumber.toLowerCase()) &&
      !kebijakan;

  /// Harga kebijakan pemerintah (HPP gabah untuk padi), bukan harga pasar.
  /// Sumbernya resmi, tetapi tanggalnya adalah tanggal kebijakan, sehingga
  /// layar tidak boleh memberinya warna yang sama dengan harga pasar yang
  /// diperbarui setiap hari.
  bool get kebijakan => sumber.toLowerCase().startsWith('hpp');

  /// Angka simulasi yang tetap bergerak setiap hari (diisi job harian di
  /// Supabase). Bukan harga pasar, tetapi tanggalnya nyata, sehingga layar boleh
  /// menulis keterangan "simulasi harian" tanpa menyatakannya sebagai harga
  /// pasar.
  bool get harian => sumber.toLowerCase() == 'simulasi-harian';
}

/// Satu titik pada grafik harga: nilainya dan kapan dicatat. Titik-titik ini
/// diambil dari tabel `harga_riwayat`, yang diisi otomatis oleh trigger di
/// Supabase setiap kali sebuah harga diubah.
class HargaTitik {
  final double harga;
  final DateTime waktu;
  const HargaTitik(this.harga, this.waktu);
}

/// Sumber data harga dan permintaan.
///
/// Tersusun atas tiga lapis, mulai dari yang paling dipercaya: harga catatan
/// pengguna ([manual]), harga dari Supabase ([live]) yang disegarkan melalui
/// [segarkan], lalu simulasi deterministik dari harga dasar komoditas. [liveAsal]
/// membedakan dua lapis tengah: baris 'contoh' / 'basis-simulasi' di Supabase
/// belum merupakan harga pasar, hanya angkanya yang melalui server. Bila tidak
/// ada jaringan atau Supabase kosong, [live] tetap kosong dan aplikasi berjalan
/// seperti sebelumnya, yaitu memakai simulasi.
class MarketService {
  static const sourceNote =
      'Harga dasar masih simulasi lokal. Ketuk "Atur harga sendiri" di layar '
      'Pasar untuk memakai harga panen Anda sendiri.';

  /// Harga hasil catatan pengguna (commodityId -> Rp/kg) beserta nilai
  /// sebelumnya.
  static Map<String, double> manual = {};
  static Map<String, double> manualPrev = {};

  /// Harga terbaru dari Supabase (commodityId -> Rp/kg). Kosong bila belum
  /// diambil atau pengambilan gagal.
  static Map<String, double> live = {};

  /// Asal tiap angka pada [live]. Komoditas dengan baris yang tidak memiliki
  /// tanggal absah tidak ikut tercatat, sehingga ditampilkan sebagai simulasi.
  static Map<String, HargaAsal> liveAsal = {};
  static bool liveSegar = false;

  /// Deret harga setiap komoditas (commodityId -> titik dari lama ke baru),
  /// diambil dari `harga_riwayat` lalu ditutup dengan angka yang berlaku sekarang
  /// di tabel `harga`. Kosong selama Supabase belum pernah dihubungi atau
  /// arsipnya belum tersedia; dalam keadaan itu grafik memakai kurva simulasi
  /// seperti sebelumnya.
  static Map<String, List<HargaTitik>> liveSeri = {};

  /// Alasan teknis bila pengambilan harga terakhir dari Supabase gagal, sudah
  /// dipendekkan agar muat pada satu baris layar Pasar.
  static String? liveError;

  /// Bertambah setiap kali isi [live] benar-benar berubah. Layar yang
  /// menampilkan harga cukup mendengarkan nilai ini untuk ikut diperbarui saat
  /// ada baris diubah di Supabase, tanpa perlu mengetahui urusan jaringan.
  static final versi = ValueNotifier<int>(0);

  static bool isManual(Commodity c) => manual.containsKey(c.id);
  static int manualCount() => manual.length;
  static bool get adaLive => live.isNotEmpty;

  /// Jumlah komoditas yang angkanya benar-benar catatan pasar, bukan nilai
  /// bawaan tabel. Bernilai nol selama Supabase masih berisi
  /// 'contoh'/'basis-simulasi'.
  static int nyataCount() => liveAsal.values.where((a) => a.nyata).length;

  /// Jumlah komoditas yang angkanya merupakan harga kebijakan pemerintah (HPP),
  /// bukan harga pasar. Saat ini hanya padi, karena belum ada harga gabah
  /// harian.
  static int acuanCount() => liveAsal.values.where((a) => a.kebijakan).length;

  /// Ambil harga terbaru dari tabel `harga` di Supabase. Mengisi [live] dan
  /// [liveAsal], serta mengembalikan true bila berhasil. Aman dipanggil
  /// berulang; bila Supabase belum siap (luring atau mode tes), langsung
  /// mengembalikan false tanpa efek samping.
  static Future<bool> segarkan() async {
    if (!SupabaseGate.siap) {
      liveError = 'Supabase belum siap';
      debugPrint('[harga] Supabase belum siap, tetap simulasi');
      return false;
    }
    try {
      final rows = await SupabaseGate.client
          .from('harga')
          .select('commodity_id,harga_rp_kg,sumber,tanggal')
          .order('tanggal', ascending: false)
          .order('created_at', ascending: false)
          .limit(500);
      final hasil = <String, double>{};
      final asal = <String, HargaAsal>{};
      for (final r in rows) {
        final id = r['commodity_id'] as String?;
        final harga = (r['harga_rp_kg'] as num?)?.toDouble();
        if (id == null || harga == null || harga <= 0) continue;
        // Baris pertama untuk satu komoditas adalah tanggal (lalu created_at)
        // terbaru, sehingga tidak boleh ditimpa oleh baris lama di bawahnya.
        if (hasil.containsKey(id)) continue;
        hasil[id] = harga;
        final tgl = DateTime.tryParse(r['tanggal'] as String? ?? '');
        final src = (r['sumber'] as String?)?.trim() ?? '';
        if (tgl != null) asal[id] = HargaAsal(src, tgl);
      }
      debugPrint('[harga] ${rows.length} baris, ${hasil.length} komoditas, '
          '${asal.values.where((a) => a.nyata).length} bersumber nyata');
      if (hasil.isEmpty) {
        liveSegar = false;
        liveSeri = {};
        liveError = 'tabel harga kosong';
        return false;
      }
      final lama = live, asalLama = liveAsal, titikLama = jumlahTitik;
      live = hasil;
      liveAsal = asal;
      try {
        await _muatSeri();
      } catch (e) {
        // Tabel arsip belum tersedia (harga_riwayat.sql belum dijalankan):
        // harga tetap berjalan, hanya grafiknya yang masih memakai kurva
        // simulasi.
        liveSeri = {};
        debugPrint('[harga] arsip belum tersedia: $e');
      }
      liveSegar = true;
      liveError = null;
      // Hanya bertambah bila angkanya memang berubah, agar layar tidak dibangun
      // ulang untuk event realtime yang tidak mengubah apa pun.
      final berganti = !mapEquals(lama, hasil) ||
          !mapEquals(asalLama, asal) ||
          titikLama != jumlahTitik;
      if (berganti) versi.value++;
      return true;
    } catch (e) {
      final s = e.toString().split(', uri=')[0];
      liveError = s.length > 110 ? '${s.substring(0, 110)}…' : s;
      debugPrint('[harga] query gagal: $e');
      liveSegar = false;
      return false;
    }
  }

  /// Ambil arsip perubahan harga dan susun menjadi deret per komoditas, urut
  /// dari lama ke baru. Titik terakhir selalu angka yang berlaku sekarang pada
  /// tabel `harga`, agar kurva berakhir pada angka yang juga tampil di layar.
  static Future<void> _muatSeri() async {
    final rows = await SupabaseGate.client
        .from('harga_riwayat')
        .select('commodity_id,harga_rp_kg,direkam_pada')
        .order('direkam_pada', ascending: true)
        .limit(800);
    final seri = <String, List<HargaTitik>>{};
    for (final r in rows) {
      final id = r['commodity_id'] as String?;
      final harga = (r['harga_rp_kg'] as num?)?.toDouble();
      final mentah = DateTime.tryParse(r['direkam_pada'] as String? ?? '');
      if (id == null || harga == null || harga <= 0 || mentah == null) continue;
      // Stempel waktu Supabase diterima dalam UTC. Tanggal yang dibaca petani
      // adalah tanggal waktu dindingnya (WIB), sehingga dikonversi ke waktu
      // lokal sebelum titik ini dikelompokkan per hari.
      (seri[id] ??= []).add(HargaTitik(harga, mentah.toLocal()));
    }
    final sekarang = DateTime.now();
    for (final e in live.entries) {
      (seri[e.key] ??= []).add(HargaTitik(e.value, sekarang));
    }
    liveSeri = seri;
    debugPrint('[harga] arsip ${rows.length} baris -> ${seri.length} deret');
  }

  /// Total titik pada seluruh deret — digunakan untuk memutuskan apakah layar
  /// perlu dibangun ulang setelah suatu perubahan harga masuk.
  static int get jumlahTitik => liveSeri.values.fold(0, (a, s) => a + s.length);

  /// Deret yang dapat digambar apa adanya: arsip memiliki minimal dua titik,
  /// yang berarti benar-benar pernah terjadi perubahan harga di Supabase. Satu
  /// titik belum dapat dinyatakan sebagai naik-turun, sehingga grafik tetap
  /// memakai simulasi.
  static List<HargaTitik>? seriTercatat(Commodity c) {
    final s = liveSeri[c.id];
    return (s == null || s.length < 2) ? null : s;
  }

  /// Harga yang berlaku pada setiap tanggal, dari catatan pertama sampai hari
  /// ini — satu titik per tanggal, tanpa tanggal yang terlewat.
  ///
  /// `harga_riwayat` hanya menyimpan harga LAMA sesaat sebelum sebuah perubahan,
  /// sehingga nilai yang berlaku sesudah perubahan itu adalah nilai titik
  /// berikutnya. Tanggal tanpa perubahan mewarisi harga tanggal sebelumnya,
  /// karena harga memang tidak berubah sampai ada yang menggantinya; mengosongkan
  /// tanggal tersebut justru menyatakan bahwa tidak ada harga pada hari itu.
  static List<HargaTitik> harian(Commodity c, {DateTime? now}) {
    final raw = liveSeri[c.id];
    if (raw == null || raw.length < 2) return const [];
    final akhir = now ?? DateTime.now();
    final hariIni = DateTime(akhir.year, akhir.month, akhir.day);
    final perHari = <DateTime, HargaTitik>{};
    void taruh(HargaTitik t) {
      final day = DateTime(t.waktu.year, t.waktu.month, t.waktu.day);
      final lama = perHari[day];
      if (lama == null || !t.waktu.isBefore(lama.waktu)) perHari[day] = t;
    }

    for (var i = 0; i < raw.length - 1; i++) {
      taruh(HargaTitik(raw[i + 1].harga, raw[i].waktu));
    }
    taruh(raw.last);
    final awal = perHari.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final out = <HargaTitik>[];
    for (var d = awal;
        !d.isAfter(hariIni);
        d = d.add(const Duration(days: 1))) {
      final t = perHari[d];
      if (t != null) {
        out.add(t);
      } else if (out.isNotEmpty) {
        out.add(HargaTitik(out.last.harga, d));
      }
    }
    return out;
  }

  /// Keterangan yang menemani grafik: garis ini catatan atau hasil simulasi.
  /// Grafik tanpa keterangan ini mudah disalahartikan sebagai riwayat pasar.
  ///
  /// [digambar] adalah titik yang benar-benar tampil pada periode terpilih, agar
  /// keterangan menyebut jumlah tanggal. Arsip dapat memuat beberapa baris dalam
  /// satu hari, sehingga jumlah baris bukan sama dengan jumlah tanggal.
  static String seriCaption(Commodity c, {List<HargaTitik>? digambar}) {
    final titik = digambar ?? harian(c);
    var ubah = 0;
    for (var i = 1; i < titik.length; i++) {
      if (titik[i].harga != titik[i - 1].harga) ubah++;
    }
    if (seriTercatat(c) != null) {
      // Yang dinilai adalah angka yang sedang berlaku, bukan titik terakhir
      // arsip: sumber pada baris itulah yang menentukan apakah catatan ini
      // merupakan harga pasar.
      if (liveAsal[c.id]?.nyata ?? false) {
        return tpl('{0} tanggal · {1} perubahan harga tercatat di Supabase',
            ['${titik.length}', '$ubah']);
      }
      return tpl(
          '{0} tanggal · {1} perubahan harga di Supabase, angkanya masih contoh',
          ['${titik.length}', '$ubah']);
    }
    if (titik.isNotEmpty) {
      return tr('Baru ada harga hari ini — riwayat perubahan belum tercatat');
    }
    return tr('Grafik masih simulasi — belum ada riwayat nyata');
  }

  static Timer? _tundaMuat;

  /// Harga ikut berubah begitu sebuah baris diubah di dashboard Supabase, tanpa
  /// perlu membuka ulang layar Pasar. Dipanggil sekali dari `main()`; bila
  /// Supabase tidak siap (luring atau mode tes) tidak melakukan apa pun.
  static void mulaiLive() {
    SupabaseLive.langganan('harga', () {
      // Perubahan massal mengirim satu event per baris, sehingga event
      // dikumpulkan selama 400 ms sebelum query diulang — hasilnya sama,
      // bebannya jauh lebih ringan.
      _tundaMuat?.cancel();
      _tundaMuat = Timer(const Duration(milliseconds: 400), segarkan);
    });
  }

  /// Angka simulasi hari ini, digunakan sebagai pembanding harga catatan.
  static double simulatedNow(Commodity c) =>
      priceOn(c, _dayIndex(DateTime.now()));

  static double _noise(int n) {
    final x = math.sin(n * 12.9898) * 43758.5453;
    return x - x.floorToDouble();
  }

  static int _dayIndex(DateTime d) => DateTime.utc(d.year, d.month, d.day)
      .difference(DateTime.utc(2024, 1, 1))
      .inDays;

  static int _seed(Commodity c) =>
      c.id.codeUnits.fold(0, (a, b) => (a * 31 + b) % 1000);

  static double priceOn(Commodity c, int day) {
    final s = _seed(c);
    final wave =
        math.sin(day / 7.0 + s) * 0.55 + math.sin(day / 23.0 + s * 0.5) * 0.45;
    final jitter = _noise(day + s * 101) - 0.5;
    final p = c.basePrice *
        (1 + c.volatility * 0.35 * wave + c.volatility * 0.08 * jitter);
    return (p / 50).round() * 50.0;
  }

  static double current(Commodity c) =>
      manual[c.id] ?? live[c.id] ?? simulatedNow(c);

  static double changePct(Commodity c) {
    final m = manual[c.id];
    if (m != null) {
      final p = manualPrev[c.id];
      if (p == null || p <= 0) return 0;
      return (m - p) / p * 100;
    }
    // Harga penutup kemarin dibandingkan dengan harga penutup hari ini.
    // Perbandingan dilakukan per tanggal, bukan per baris arsip: satu malam
    // dapat memuat beberapa perubahan, sehingga membandingkan dua baris terakhir
    // menghasilkan persentase yang tidak berdasar.
    final harianIni = harian(c);
    if (harianIni.length >= 2) {
      final p = harianIni[harianIni.length - 2].harga;
      if (p <= 0) return 0;
      return (harianIni.last.harga - p) / p * 100;
    }
    // Baris Supabase yang benar-benar harga pasar, tetapi arsipnya belum punya
    // pembanding: persentase tidak boleh dikarang.
    if (live.containsKey(c.id) && (liveAsal[c.id]?.nyata ?? false)) return 0;
    // Baris 'contoh'/'basis-simulasi' bukan observasi pasar: angkanya merupakan
    // simulasi yang melewati server, sehingga persennya memakai simulasi yang
    // sama.
    final d = _dayIndex(DateTime.now());
    final a = priceOn(c, d - 1);
    final b = priceOn(c, d);
    return (b - a) / a * 100;
  }

  /// Harga harian, dari terlama sampai hari ini. Nilai hari ini mengikuti harga
  /// catatan pengguna atau harga Supabase bila tersedia.
  ///
  /// Riwayat nyata diprioritaskan: apabila arsip memiliki dua titik atau lebih,
  /// grafik digambar dari harga yang berlaku pada setiap tanggal, bukan dari
  /// kurva simulasi.
  static List<double> history(Commodity c, int days) {
    final s = harian(c);
    if (s.isNotEmpty) {
      final ambil = s.length > days ? s.sublist(s.length - days) : s;
      final list = [for (final t in ambil) t.harga];
      // Ujung kurva adalah angka yang sedang tampil di layar.
      list[list.length - 1] = current(c);
      return list;
    }
    final d = _dayIndex(DateTime.now());
    final list = [for (var i = days - 1; i >= 0; i--) priceOn(c, d - i)];
    if (manual.containsKey(c.id) || live.containsKey(c.id)) {
      list[list.length - 1] = current(c);
    }
    return list;
  }

  static List<HargaTitik> historyPoints(Commodity c, int days,
      {DateTime? now}) {
    final end = now ?? DateTime.now();
    final start = DateTime(end.year, end.month, end.day - days + 1);
    final tercatat = harian(c, now: end);
    if (tercatat.isNotEmpty) {
      // Satu titik per tanggal dalam periode: tanggal tanpa perubahan harga
      // tetap ditampilkan dengan mewarisi harga tanggal sebelumnya.
      return [
        for (final t in tercatat)
          if (!t.waktu.isBefore(start)) t
      ];
    }
    if (manual.containsKey(c.id) || live.containsKey(c.id)) {
      return [HargaTitik(current(c), end)];
    }
    final d = _dayIndex(end);
    return [
      for (var i = days - 1; i >= 0; i--)
        HargaTitik(
            priceOn(c, d - i), DateTime(end.year, end.month, end.day - i)),
    ];
  }

  /// Indeks permintaan (30..95) untuk enam bulan terakhir.
  static List<double> demand(Commodity c) {
    final s = _seed(c);
    final m = DateTime.now().month;
    return [
      for (var i = 5; i >= 0; i--)
        (62 + 24 * math.sin((m - i) * 0.9 + s) - c.volatility * 10)
            .clamp(30, 95)
            .toDouble()
    ];
  }

  static List<String> demandMonths() {
    final now = DateTime.now();
    return [
      for (var i = 5; i >= 0; i--)
        namaBulanDari(DateTime(now.year, now.month - i, 1))
    ];
  }

  static String namaBulanDari(DateTime d) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ][d.month - 1];

  static String demandLabel(double v) =>
      tr(v >= 70 ? 'Tinggi' : (v >= 50 ? 'Sedang' : 'Rendah'));
}
