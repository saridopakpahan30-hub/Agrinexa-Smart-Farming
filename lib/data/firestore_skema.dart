import '../models/farm_activity.dart';
import '../models/farm_settings.dart';
import '../models/ledger.dart';
import '../models/optimization_run.dart';
import '../models/planting.dart';
import '../models/plot.dart';
import '../models/sim_record.dart';
import 'farm_repository.dart';

/// Nama koleksi di Firestore. `users/{uid}` adalah satu dokumen inti
/// (pengaturan usaha tani, preferensi, lokasi, harga catatan), sedangkan
/// subkoleksi di bawahnya menyimpan data yang jumlahnya dapat bertambah.
///
/// Berkas ini tidak bergantung pada cloud_firestore: seluruh pemetaan di
/// bawah bersifat murni (model <-> peta kolom) sehingga dapat diuji tanpa
/// proyek Firebase.
class SkemaKebun {
  static const users = 'users';
  static const kebun = 'kebun';
  static const penanaman = 'penanaman';
  static const keuangan = 'keuangan';
  static const aktivitas = 'aktivitas';
  static const riwayatSimulasi = 'riwayatSimulasi';
  static const riwayatOptimasi = 'riwayatOptimasi';
  static const konflik = 'konflik';

  static const daftarKoleksi = [
    kebun,
    penanaman,
    keuangan,
    aktivitas,
    riwayatSimulasi,
    riwayatOptimasi,
  ];
}

/// Isi satu dokumen: nama kolom -> nilainya.
typedef Kolom = Map<String, Object?>;

/// Isi satu koleksi: id dokumen -> isinya.
typedef IsiKoleksi = Map<String, Kolom>;
Kolom petaInti(FarmSnapshot s) => {
      'diubahMs': s.diubahMs,
      'pengaturan': {
        'luasLahanM2': s.settings.landArea,
        'modalRp': s.settings.capital,
        'jenisLahan': s.settings.landType,
        'tujuan': s.settings.goal,
        'komoditasAktif': s.settings.activeId,
        'sudahMengisiData': s.settings.hasInput,
      },
      'preferensi': {
        'notifikasi': s.settings.notifOn,
        'peringatanHarga': s.settings.priceAlert,
      },
      'lokasi': {
        'lintang': s.settings.farmLat,
        'bujur': s.settings.farmLon,
        'kota': s.settings.farmCity,
        'dipilihSendiri': s.settings.locationChosen,
      },
      'hargaCatatan': s.settings.manualPrices,
      'hargaSebelumnya': s.settings.manualPricesPrev,
    };

/// Membangun isi setiap koleksi: id dokumen -> datanya. Id dokumen Firestore
/// diambil dari id model, sehingga satu baris data selalu menulis ke dokumen
/// yang sama.
Map<String, IsiKoleksi> petaKoleksi(FarmSnapshot s) => {
      SkemaKebun.kebun: {for (final p in s.plots) p.id: p.toJson()},
      SkemaKebun.penanaman: {
        for (final p in s.plantings)
          p.id: {
            'id': p.id,
            'komoditas': p.commodityId,
            'mulaiMs': p.startMs,
            'tahapSelesai': p.done,
          }
      },
      SkemaKebun.keuangan: {
        for (final e in s.ledger)
          e.id: {
            'id': e.id,
            'waktuMs': e.timeMs,
            'jenis': e.income ? 'masuk' : 'keluar',
            'kategori': e.category,
            'jumlahRp': e.amount,
            'catatan': e.note,
            'komoditas': e.commodityId,
          }
      },
      SkemaKebun.aktivitas: {for (final a in s.activities) a.id: a.toJson()},
      SkemaKebun.riwayatSimulasi: {
        for (final h in s.history)
          h.kunci: {
            'id': h.kunci,
            'komoditas': h.commodityId,
            'tanggal': h.date,
            'luasM2': h.area,
            'modalRp': h.capital,
            'omzet': h.omzet,
            'biaya': h.cost,
            'margin': h.margin,
            'roi': h.roi,
            'faktorHarga': h.priceFactor,
          }
      },
      SkemaKebun.riwayatOptimasi: {
        for (final o in s.optimizations) o.id: o.toJson()
      },
    };

/// Versi yang kalah saat terjadi konflik disimpan utuh sebagai satu dokumen,
/// termasuk seluruh barisnya, agar masih dapat dibaca dan dipulihkan secara
/// manual.
Map<String, Object?> petaKonflik(FarmSnapshot s, String penyebab) => {
      ...petaInti(s),
      'penyebab': penyebab,
      'jumlahData': s.jumlahData,
      'isi': {
        for (final bagian in petaKoleksi(s).entries)
          bagian.key: [for (final d in bagian.value.values) d],
      },
    };

Map<String, Object?> _m(dynamic v) =>
    Map<String, Object?>.from((v as Map?) ?? const {});

Map<String, double> _angka(dynamic v) => {
      for (final e in ((v as Map?) ?? const {}).entries)
        e.key.toString(): (e.value as num).toDouble()
    };

/// Membaca kembali: dokumen inti dan isi tiap subkoleksi disusun menjadi
/// snapshot. Koleksi yang tidak ada dianggap kosong, dan setiap kolom
/// memiliki nilai cadangan, karena dokumen dari versi aplikasi lama tidak
/// boleh menyebabkan pembacaan gagal.
FarmSnapshot snapshotDariDokumen(Kolom inti, Map<String, IsiKoleksi> koleksi) {
  final pengaturan = _m(inti['pengaturan']);
  final preferensi = _m(inti['preferensi']);
  final lokasi = _m(inti['lokasi']);
  for (final nama in SkemaKebun.daftarKoleksi) {
    koleksi.putIfAbsent(nama, () => const {});
  }
  List<Kolom> dokumen(String nama) => [for (final d in koleksi[nama]!.values) d];

  return FarmSnapshot(
    settings: FarmSettings(
      landArea: (pengaturan['luasLahanM2'] as num?)?.toInt() ?? 1000,
      capital: (pengaturan['modalRp'] as num?)?.toInt() ?? 5000000,
      landType:
          pengaturan['jenisLahan'] as String? ?? FarmSettings.jenisLahanBawaan,
      goal: pengaturan['tujuan'] as String? ?? 'Keuntungan',
      activeId: pengaturan['komoditasAktif'] as String?,
      hasInput: pengaturan['sudahMengisiData'] as bool? ?? false,
      notifOn: preferensi['notifikasi'] as bool? ?? true,
      priceAlert: preferensi['peringatanHarga'] as bool? ?? true,
      farmLat: (lokasi['lintang'] as num?)?.toDouble() ?? 0,
      farmLon: (lokasi['bujur'] as num?)?.toDouble() ?? 0,
      farmCity: lokasi['kota'] as String? ?? '',
      locationChosen: lokasi['dipilihSendiri'] as bool? ?? false,
      manualPrices: _angka(inti['hargaCatatan']),
      manualPricesPrev: _angka(inti['hargaSebelumnya']),
    ),
    history: [
      for (final j in dokumen(SkemaKebun.riwayatSimulasi))
        SimRecord(
          id: j['id'] as String? ?? '',
          commodityId: j['komoditas'] as String,
          date: j['tanggal'] as String,
          area: (j['luasM2'] as num?)?.toDouble() ?? 0,
          capital: (j['modalRp'] as num?)?.toInt() ?? 0,
          omzet: (j['omzet'] as num?)?.toDouble() ?? 0,
          cost: (j['biaya'] as num?)?.toDouble() ?? 0,
          margin: (j['margin'] as num?)?.toDouble() ?? 0,
          roi: (j['roi'] as num?)?.toDouble() ?? 0,
          priceFactor: (j['faktorHarga'] as num?)?.toDouble() ?? 1,
        )
    ],
    ledger: [
      for (final j in dokumen(SkemaKebun.keuangan))
        LedgerEntry(
          id: j['id'] as String,
          timeMs: (j['waktuMs'] as num?)?.toInt() ?? 0,
          income: j['jenis'] == 'masuk',
          category: j['kategori'] as String? ?? '',
          amount: (j['jumlahRp'] as num?)?.toInt() ?? 0,
          note: j['catatan'] as String? ?? '',
          commodityId: j['komoditas'] as String?,
        )
    ],
    plantings: [
      for (final j in dokumen(SkemaKebun.penanaman))
        Planting(
          id: j['id'] as String,
          commodityId: j['komoditas'] as String,
          startMs: (j['mulaiMs'] as num?)?.toInt() ?? 0,
          done: [
            for (final d in (j['tahapSelesai'] as List? ?? const []))
              (d as num).toInt()
          ],
        )
    ],
    plots: [
      for (final j in dokumen(SkemaKebun.kebun))
        Plot.fromJson(Map<String, dynamic>.from(j))
    ],
    activities: [
      for (final j in dokumen(SkemaKebun.aktivitas))
        FarmActivity.fromJson(Map<String, dynamic>.from(j))
    ],
    optimizations: [
      for (final j in dokumen(SkemaKebun.riwayatOptimasi))
        OptimizationRun.fromJson(Map<String, dynamic>.from(j))
    ],
    diubahMs: (inti['diubahMs'] as num?)?.toInt() ?? 0,
  );
}
