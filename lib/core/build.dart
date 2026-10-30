/// Nomor build, diisi saat proses build melalui `--dart-define=BUILD=6`.
///
/// Tanpa nomor ini, tiga APK yang terpasang di perangkat tidak dapat
/// dibedakan: `version:` di pubspec tidak pernah berubah dan tidak ada angka
/// apa pun yang ditampilkan di layar. Dengan menampilkan nomor ini pada splash,
/// satu tangkapan layar sudah cukup untuk mengetahui build yang terpasang.
const String buildNomor = String.fromEnvironment('BUILD', defaultValue: 'dev');
