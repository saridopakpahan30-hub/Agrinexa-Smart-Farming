import 'package:flutter/material.dart';

import 'translations_en.dart';

/// Penerjemah bergaya gettext: teks bahasa Indonesia berfungsi sebagai kunci,
/// sedangkan tabel bahasa Inggris hanya sebagai pelengkap.
///
/// Alasan tidak menggunakan gen_l10n/AppRenderer: seluruh aplikasi sudah
/// ditulis dengan kalimat bahasa Indonesia langsung di tempatnya. Memindahkan
/// ~1500 kalimat ke berkas .arb berarti menulis ulang setiap layar dan memberi
/// nama kunci untuk setiap kalimat. Dengan pendekatan ini, kunci berupa kalimat
/// aslinya, sehingga penambahan bahasa tidak akan pernah menyebabkan teks
/// hilang: kunci yang belum ada di tabel Inggris ditampilkan dalam bahasa
/// Indonesia, bukan kosong.
class Lang {
  Lang._();

  /// Daftar pilihan bahasa yang ditampilkan di Pengaturan. 'id' selalu ada
  /// karena bahasa Indonesia adalah bahasa asal aplikasi.
  static const daftar = ['id', 'en'];

  static String _kode = 'id';
  static const Map<String, String> _tabel = tabelInggris;

  static String get kode => _kode;
  static bool get inggris => _kode == 'en';

  static void pakai(String kode) => _kode = daftar.contains(kode) ? kode : 'id';

  /// Terjemahan [id] sesuai bahasa aktif.
  static String t(String id) => inggris ? (_tabel[id] ?? id) : id;

  /// Jumlah kunci yang belum memiliki padanan bahasa Inggris — dibaca oleh tes
  /// agar penerjemahan tidak berhenti tanpa diketahui.
  static int jumlahKunciKurang(List<String> kunci) =>
      kunci.where((k) => !_tabel.containsKey(k)).length;
}

/// Versi singkat agar nyaman digunakan di antara argumen widget.
String tr(String id) => Lang.t(id);

/// Teks yang disusun dari nilai dinamis, misalnya 'Rencana {0} dihapus'.
///
/// Kalimat utuh tidak dapat menjadi kunci tabel karena sisipannya berubah pada
/// setiap eksekusi. Yang menjadi kunci adalah templatenya; slot {0}, {1} diisi
/// setelah penerjemahan, sehingga urutan kata bahasa Inggris dapat berbeda dari
/// bahasa Indonesia.
String tpl(String template, List<String> args) {
  var out = Lang.t(template);
  for (var i = 0; i < args.length; i++) {
    out = out.replaceAll('{$i}', args[i]);
  }
  return out;
}

/// Pengganti [Text] untuk semua tulisan milik aplikasi.
///
/// Konstruktornya `const`, sehingga `const UiText('Menu Cepat')` tetap semurah
/// `const Text(...)`: penerjemahan terjadi di [build], bukan di tempat string
/// ditulis. Membungkus setiap string dengan `tr()` akan merusak `const` di
/// ratusan tempat, dan daftar bahasa tidak akan pernah dapat diaudit.
/// Sisa [Text] polos di dalam `lib/` hanya untuk teks yang memang tidak
/// diterjemahkan: angka, satuan, dan tanda panah.
class UiText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  const UiText(this.data,
      {super.key,
      this.style,
      this.maxLines,
      this.overflow,
      this.textAlign,
      this.softWrap});

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Text(Lang.t(data),
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        softWrap: softWrap);
  }
}
