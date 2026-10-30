import 'package:flutter/material.dart';

/// Kumpulan warna untuk satu mode tampilan.
///
/// Dua token hijau dipisah secara sengaja: [green] digunakan sebagai warna
/// teks, ikon, dan garis, sedangkan [greenFill] digunakan sebagai latar
/// dengan teks putih. Pada mode gelap tidak ada satu warna hijau pun yang
/// aman untuk kedua penggunaan tersebut.
class Palette {
  const Palette({
    required this.green,
    required this.greenFill,
    required this.deepGreen,
    required this.darkGreen,
    required this.leaf,
    required this.mint,
    required this.onMint,
    required this.bg,
    required this.card,
    required this.text,
    required this.muted,
    required this.line,
    required this.down,
    required this.downInk,
    required this.sun,
    required this.sunInk,
    required this.sunTint,
    required this.sunTintLine,
    required this.downTint,
    required this.downTintLine,
  });

  final Color green;
  final Color greenFill;
  final Color deepGreen;
  final Color darkGreen;
  final Color leaf;
  final Color mint;

  /// Warna teks di atas latar [mint]. Terpisah dari [deepGreen] karena pada
  /// mode gelap mint sudah gelap, sehingga tinta hijaunya perlu lebih terang.
  final Color onMint;
  final Color bg;
  final Color card;
  final Color text;
  final Color muted;
  final Color line;
  final Color down;
  final Color downInk;
  final Color sun;
  final Color sunInk;

  /// Kapsul peringatan (kuning/merah muda): latar dan garis tepi.
  final Color sunTint;
  final Color sunTintLine;
  final Color downTint;
  final Color downTintLine;
}

/// Mode terang: kontras teks 13:1, semua teks kecil minimal 13 px.
const paletTerang = Palette(
  green: Color(0xFF1B7F3B),
  greenFill: Color(0xFF1B7F3B),
  deepGreen: Color(0xFF0E5A2B),
  darkGreen: Color(0xFF0B3D20),
  leaf: Color(0xFF4CAF50),
  mint: Color(0xFFE8F5EC),
  onMint: Color(0xFF0E5A2B),
  bg: Color(0xFFF6F8F5),
  card: Color(0xFFFFFFFF),
  text: Color(0xFF1F2A24),
  muted: Color(0xFF5F6E62),
  line: Color(0xFFE3E8E4),
  // Merah "harga turun": sedikit lebih dalam dari merah sebelumnya agar tetap
  // mencapai 4,5:1 di dalam kapsul mint, dan teks putih di atasnya tetap aman.
  down: Color(0xFFC4343A),
  downInk: Color(0xFF8A3B2E),
  sun: Color(0xFFFFC94D),

  /// Warna teks kuning-cokelat. Terpisah dari [sun] (yang digunakan untuk ikon
  /// dan sorotan) karena kuning murni pada latar gelap menimbulkan efek halo,
  /// sedangkan pada latar krem di mode terang kuning murni tidak terbaca.
  sunInk: Color(0xFF8A6600),
  sunTint: Color(0xFFFFF7E0),
  sunTintLine: Color(0xFFC9AE55),
  downTint: Color(0xFFFFF3F0),
  downTintLine: Color(0xFFE2A79C),
);

/// Mode gelap dirancang untuk penglihatan pengguna lapangan usia 40 tahun ke
/// atas: latar bukan hitam murni (teks putih di atas hitam menimbulkan efek
/// bergetar), teks bukan putih murni, dan kontras dinaikkan dibanding mode
/// terang karena latar gelap menyamarkan teks berukuran tipis.
const paletGelap = Palette(
  green: Color(0xFF5FC97F),
  greenFill: Color(0xFF1B7F3B),
  deepGreen: Color(0xFF0E5A2B),
  darkGreen: Color(0xFF082A16),
  leaf: Color(0xFF79D99A),

  // Latar "sedang terpilih" (chip, indikator navigasi, panel halus). Pada mode
  // gelap harus lebih terang daripada kartu, bukan sekadar sedikit lebih
  // terang, agar pilihan benar-benar terlihat.
  mint: Color(0xFF24382C),
  onMint: Color(0xFF6FD493),
  bg: Color(0xFF0E1512),
  card: Color(0xFF16201B),
  text: Color(0xFFEAF2E8),
  muted: Color(0xFFA9BCB1),
  line: Color(0xFF33453B),
  down: Color(0xFFEF8B7F),
  downInk: Color(0xFFF2A79E),
  sun: Color(0xFFF5C451),
  sunInk: Color(0xFFF5C451),
  // Kapsul peringatan: warna latar dan teks di dalamnya harus lolos 4,5:1.
  // Nilai di bawah merupakan campuran 15% dan 40% warna aksen di atas kartu
  // gelap.
  sunTint: Color(0xFF383823),
  sunTintLine: Color(0xFF6F6231),
  downTint: Color(0xFF36302A),
  downTintLine: Color(0xFF6C4B43),
);

/// Akses cepat ke palet aktif. Isinya mengikuti mode tampilan, bukan
/// konstanta tetap.
class AppColors {
  AppColors._();

  static Palette _p = paletTerang;
  static bool _gelap = false;

  static void pakai({required bool gelap}) {
    _gelap = gelap;
    _p = gelap ? paletGelap : paletTerang;
  }

  static bool get gelap => _gelap;
  static Palette get palet => _p;

  static Color get green => _p.green;
  static Color get greenFill => _p.greenFill;
  static Color get deepGreen => _p.deepGreen;
  static Color get darkGreen => _p.darkGreen;
  static Color get leaf => _p.leaf;
  static Color get mint => _p.mint;
  static Color get onMint => _p.onMint;
  static Color get bg => _p.bg;
  static Color get card => _p.card;
  static Color get text => _p.text;
  static Color get muted => _p.muted;
  static Color get line => _p.line;
  static Color get down => _p.down;
  static Color get downInk => _p.downInk;
  static Color get sun => _p.sun;
  static Color get sunInk => _p.sunInk;
  static Color get sunTint => _p.sunTint;
  static Color get sunTintLine => _p.sunTintLine;
  static Color get downTint => _p.downTint;
  static Color get downTintLine => _p.downTintLine;

  /// Warna aksen berukuran kecil (ikon menu cepat, badge): pada mode gelap
  /// diterangkan agar tidak tenggelam di latar gelap.
  static Color aksen(Color c) =>
      _gelap ? Color.lerp(c, Colors.white, 0.42)! : c;

  /// Warna teks di atas latar yang selalu gelap (foto hero, AgriScene, laci
  /// menu, Mode Ladang). Putih murni digunakan pada mode terang dan diturunkan
  /// sedikit pada mode gelap agar kontras tidak mencapai 21:1, yang membuat
  /// huruf terlihat bergetar.
  static Color get tintaFoto => _gelap ? _p.text : Colors.white;

  /// Versi transparan dari [tintaFoto] untuk teks sekunder di atas foto.
  static Color get tintaFotoLembut => tintaFoto.o(_gelap ? 0.86 : 0.92);
}

extension ColorX on Color {
  /// Pembantu opacity yang aman untuk seluruh versi Flutter.
  Color o(double v) => withAlpha((v * 255).round());
}

ThemeData buildTheme() => _data(paletTerang);

ThemeData buildDarkTheme() => _data(paletGelap);

ThemeData _data(Palette p) {
  final dark = identical(p, paletGelap);

  // Banyak widget Material (chip, menu dropdown, date picker, bottom sheet,
  // tooltip) tidak membaca warna dari palet, melainkan dari ColorScheme.
  // Bila dibiarkan, hasilnya tetap terang pada mode gelap. Karena itu slot
  // yang digunakan widget ikut diisi dari palet aktif.
  final scheme = ColorScheme.fromSeed(
    seedColor: p.green,
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: p.green,
    onPrimary: Colors.white,
    secondaryContainer: p.mint,
    onSecondaryContainer: p.onMint,
    error: p.down,
    surface: p.card,
    onSurface: p.text,
    onSurfaceVariant: p.muted,
    outline: p.line,
    outlineVariant: p.line,
    surfaceContainerLowest: p.bg,
    surfaceContainerLow: p.card,
    surfaceContainer: p.card,
    surfaceContainerHigh: p.mint,
    surfaceContainerHighest: p.mint,
    scrim: Colors.black,
  );
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c),
      );
  final base = ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    colorScheme: scheme,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: p.bg,

    // cardColor = warna pintu jatuh DropdownButton saat daftarnya terbuka.
    cardColor: p.card,
    canvasColor: p.card,
  );
  return base.copyWith(
    // Banyak widget Text tidak menyebutkan warna: tanpa baris ini teks tetap
    // hitam pada mode gelap.
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    appBarTheme: AppBarTheme(
      // Menyatu dengan halaman: tanpa garis pemisah, judul lebih besar (M3).
      backgroundColor: p.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: p.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: p.text,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: p.text),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(color: p.muted, fontSize: 14),
      border: border(p.line),
      enabledBorder: border(p.line),
      focusedBorder: border(p.green),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.greenFill,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.green,
        minimumSize: const Size.fromHeight(50),
        side: BorderSide(color: p.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: p.green),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: p.text,
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: TextStyle(color: p.muted, fontSize: 15),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.deepGreen,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      actionTextColor: p.sun,
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
    listTileTheme: ListTileThemeData(
      iconColor: p.green,
      textColor: p.text,
      subtitleTextStyle: TextStyle(color: p.muted),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.mint,
      labelStyle: TextStyle(color: p.text, fontSize: 14),
      side: BorderSide(color: p.line),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: p.green),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: dark ? p.line : p.deepGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 13),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.card,
      indicatorColor: p.mint,
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: s.contains(WidgetState.selected) ? p.green : p.muted,
          )),
    ),
  );
}
