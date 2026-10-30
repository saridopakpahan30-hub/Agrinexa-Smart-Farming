import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Hash dan verifikasi kata sandi akun lokal.
///
/// Menggunakan PBKDF2-HMAC-SHA256 dengan salt acak 16 byte per akun. Format
/// simpanan: `pbkdf2-sha256$<iterasi>$<salt base64>$<hash base64>`.
///
/// Jumlah iterasi (40.000) menjaga waktu derivasi di bawah ±0,4 detik pada
/// perangkat kelas bawah dan peramban. Tingkatkan nilainya bila target
/// perangkat minimum berubah.
class Password {
  static const _iter = 40000;
  static const _prefix = 'pbkdf2-sha256';

  /// Menghasilkan hash baru untuk [pass] dengan salt acak.
  static String hash(String pass) {
    final rnd = Random.secure();
    final salt = List<int>.generate(16, (_) => rnd.nextInt(256));
    return '$_prefix\$$_iter\$${base64Encode(salt)}\$'
        '${base64Encode(_derive(pass, salt))}';
  }

  /// Memverifikasi [pass] terhadap hash tersimpan [stored].
  ///
  /// Hash format lama (SHA-256 tanpa salt) tetap diterima agar akun yang
  /// dibuat sebelum migrasi masih dapat masuk.
  static bool verify(String pass, String stored) {
    final bagian = stored.split(r'$');
    if (bagian.length != 4 || bagian[0] != _prefix) {
      return _slowEquals(stored, sha256.convert(utf8.encode(pass)).toString());
    }
    final salt = base64Decode(bagian[2]);
    return _slowEquals(
        bagian[3], base64Encode(_derive(pass, salt, int.parse(bagian[1]))));
  }

  /// Bernilai `true` bila [stored] masih berformat lama dan perlu di-hash
  /// ulang saat pengguna berhasil masuk.
  static bool perluUpgrade(String stored) => !stored.startsWith('$_prefix\$');

  /// Derivasi kunci PBKDF2 (RFC 8018) dengan panjang keluaran 32 byte.
  static List<int> _derive(String pass, List<int> salt, [int? iter]) {
    final mac = Hmac(sha256, utf8.encode(pass));
    final out = <int>[];
    for (var blok = 1; out.length < 32; blok++) {
      var u = mac
          .convert([
            ...salt,
            (blok >> 24) & 0xff,
            (blok >> 16) & 0xff,
            (blok >> 8) & 0xff,
            blok & 0xff,
          ])
          .bytes
          .toList();
      final t = List<int>.from(u);
      for (var i = 1; i < (iter ?? _iter); i++) {
        u = mac.convert(u).bytes.toList();
        for (var j = 0; j < t.length; j++) {
          t[j] ^= u[j];
        }
      }
      out.addAll(t);
    }
    return out.sublist(0, 32);
  }

  /// Perbandingan waktu-konstan untuk mencegah serangan timing.
  static bool _slowEquals(String a, String b) {
    if (a.length != b.length) return false;
    var beda = 0;
    for (var i = 0; i < a.length; i++) {
      beda |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return beda == 0;
  }
}
