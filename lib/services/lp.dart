/// Solver program linear berukuran kecil: memaksimumkan c·x dengan syarat
/// A·x <= b dan x >= 0.
///
/// Dibuat sendiri tanpa paket eksternal agar dapat berjalan luring baik di
/// web maupun di ponsel, dan hasilnya dapat diperiksa melalui tes. Aturan
/// Bland digunakan untuk memilih kolom yang masuk dan keluar sehingga proses
/// iterasi tidak pernah berputar tanpa akhir.
class LpSolution {
  final List<double> x;
  final double value;

  const LpSolution({required this.x, required this.value});
}

/// Mengembalikan `null` bila solusi tak terbatas atau tabel tidak konvergen.
/// Seluruh [b] harus tidak negatif, syarat yang selalu terpenuhi pada
/// pemanggilan di aplikasi ini.
LpSolution? solveLinearMax(
    List<double> c, List<List<double>> a, List<double> b) {
  final n = c.length, m = b.length;
  if (n == 0 || m == 0) return null;
  assert(b.every((v) => v >= 0), 'ruas kanan harus >= 0');

  // Susunan kolom: n variabel asli, m variabel slack, kemudian ruas kanan.
  final t = List.generate(m + 1, (_) => List.filled(n + m + 1, 0.0));
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n; j++) {
      t[i][j] = a[i][j];
    }
    t[i][n + i] = 1;
    t[i][n + m] = b[i];
  }
  for (var j = 0; j < n; j++) {
    t[m][j] = -c[j];
  }
  final basis = List<int>.generate(m, (i) => n + i);

  for (var iter = 0; iter < 4000; iter++) {
    var enter = -1;
    for (var j = 0; j < n + m; j++) {
      if (t[m][j] < -1e-9) {
        enter = j;
        break;
      }
    }
    if (enter < 0) {
      final x = List<double>.filled(n, 0);
      for (var i = 0; i < m; i++) {
        if (basis[i] < n) x[basis[i]] = t[i][n + m];
      }
      return LpSolution(x: x, value: t[m][n + m]);
    }

    var leave = -1, bestBasis = -1;
    var bestRatio = double.infinity;
    for (var i = 0; i < m; i++) {
      if (t[i][enter] <= 1e-12) continue;
      final r = t[i][n + m] / t[i][enter];
      if (r < bestRatio - 1e-12 ||
          (r <= bestRatio + 1e-12 && basis[i] < bestBasis)) {
        bestRatio = r;
        leave = i;
        bestBasis = basis[i];
      }
    }
    if (leave < 0) return null;

    final p = t[leave][enter];
    for (var j = 0; j <= n + m; j++) {
      t[leave][j] /= p;
    }
    for (var i = 0; i <= m; i++) {
      if (i == leave) continue;
      final f = t[i][enter];
      if (f.abs() < 1e-12) continue;
      for (var j = 0; j <= n + m; j++) {
        t[i][j] -= f * t[leave][j];
      }
    }
    basis[leave] = enter;
  }
  return null;
}
