import '../models/farm_activity.dart';
import '../models/farm_settings.dart';
import '../models/ledger.dart';
import '../models/optimization_run.dart';
import '../models/planting.dart';
import '../models/plot.dart';
import '../models/sim_record.dart';

/// Identitas pemilik data kebun.
///
/// [akun] merupakan kunci penyimpanan di perangkat (email yang sama dengan
/// yang digunakan sebelum backend tersedia), sedangkan [uid] merupakan
/// identitas Firebase yang sebenarnya. Keduanya sengaja dipisahkan agar data
/// yang telah tersimpan di ponsel tidak hilang hanya karena akun yang sama
/// baru memperoleh uid.
class PemilikData {
  const PemilikData(this.akun, {this.uid = ''});

  final String akun;
  final String uid;

  bool get punyaUid => uid.isNotEmpty;

  @override
  String toString() => akun;
}

/// Seluruh data kebun milik satu akun yang diambil atau disimpan sekaligus.
///
/// Strukturnya sengaja dibuat datar sehingga penyimpanan lokal dan cloud hanya
/// berbeda dalam cara memindahkan objek ini, bukan dalam isinya.
class FarmSnapshot {
  final FarmSettings settings;
  final List<SimRecord> history;
  final List<LedgerEntry> ledger;
  final List<Planting> plantings;
  final List<Plot> plots;
  final List<FarmActivity> activities;
  final List<OptimizationRun> optimizations;

  /// Waktu perubahan terakhir data ini (milidetik). Nilai ini menentukan versi
  /// yang berlaku ketika dua perangkat mengirim perubahan untuk akun yang sama.
  final int diubahMs;

  const FarmSnapshot({
    required this.settings,
    this.history = const [],
    this.ledger = const [],
    this.plantings = const [],
    this.plots = const [],
    this.activities = const [],
    this.optimizations = const [],
    this.diubahMs = 0,
  });

  factory FarmSnapshot.kosong() =>
      FarmSnapshot(settings: FarmSettings.kosong());

  int get jumlahData =>
      history.length +
      ledger.length +
      plantings.length +
      plots.length +
      activities.length +
      optimizations.length;

  FarmSnapshot denganWaktu(int ms) => FarmSnapshot(
        settings: settings,
        history: history,
        ledger: ledger,
        plantings: plantings,
        plots: plots,
        activities: activities,
        optimizations: optimizations,
        diubahMs: ms,
      );
}

/// Satu-satunya jalur baca dan tulis data kebun. Layar dan state tidak pernah
/// mengakses SharedPreferences maupun Firestore secara langsung.
abstract class FarmRepository {
  /// Memuat snapshot milik [pemilik]. Bernilai `null` bila akun tersebut belum
  /// pernah menyimpan data apa pun di penyimpanan ini.
  Future<FarmSnapshot?> muat(PemilikData pemilik);

  Future<void> simpan(PemilikData pemilik, FarmSnapshot snapshot);
}
