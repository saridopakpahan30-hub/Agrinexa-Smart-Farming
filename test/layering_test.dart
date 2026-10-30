import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Aturan lapisan: layar dan state bicara dengan [FarmRepository], tidak pernah
/// dengan penyimpanan konkret. Kalau tes ini merah, berarti ada kode baru yang
/// menyimpang dari jalur itu — bukan tes yang perlu diubah.
final paketPenyimpanan = [
  'cloud_firestore',
  'supabase_flutter',
  'firebase_core',
];

List<File> _dartFiles(String dir) => Directory('lib/$dir')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .toList();

void main() {
  test('layar dan state tidak mengimpor SDK penyimpanan apa pun', () {
    final pelanggar = <String>[];
    for (final dir in ['screens', 'state', 'widgets']) {
      for (final f in _dartFiles(dir)) {
        final impor = RegExp("^import 'package:([^/]+)/", multiLine: true)
            .allMatches(f.readAsStringSync())
            .map((m) => m.group(1))
            .where((p) => paketPenyimpanan.contains(p));
        for (final p in impor) {
          pelanggar.add('${f.path} -> $p');
        }
      }
    }
    expect(pelanggar, isEmpty,
        reason: 'Pindahkan akses data ini ke lapisan data/ (FarmRepository).');
  });

  test('layar tidak mengenal Firestore, meski lewat berkas data sendiri', () {
    final pelanggar = <String>[];
    for (final dir in ['screens', 'widgets']) {
      for (final f in _dartFiles(dir)) {
        if (f.readAsStringSync().contains('firestore')) {
          pelanggar.add(f.path);
        }
      }
    }
    expect(pelanggar, isEmpty,
        reason: 'Layar bicara dengan FarmRepository lewat AppState saja.');
  });

  test('model tidak mengenal Flutter maupun plugin', () {    final pelanggar = <String>[];
    for (final f in _dartFiles('models')) {
      final isi = f.readAsStringSync();
      final pakai = RegExp("^import 'package:([^/]+)/", multiLine: true)
              .allMatches(isi)
              .map((m) => m.group(1)!)
              .where((p) => p != 'flutter')
              .toList() +
          (isi.contains("import 'dart:ui'") ? ['dart:ui'] : []);
      if (pakai.isNotEmpty) pelanggar.add('${f.path} -> $pakai');
    }
    expect(pelanggar, isEmpty,
        reason: 'Model harus bisa dipakai di tes murni tanpa plugin.');
  });
}
