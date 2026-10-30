import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/build.dart';
import 'core/i18n.dart';
import 'core/theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';
import 'services/firebase_gate.dart';
import 'services/market_service.dart';
import 'services/supabase_gate.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _tampilAlasanError();
  // Seluruh persiapan di bawah bersifat opsional, tetapi salah satunya dapat
  // menyebabkan aplikasi tidak pernah tampil tanpa pesan galat: bila ada yang
  // melempar exception atau menggantung, main() berhenti sebelum runApp dan
  // Android hanya menampilkan layar awal putih berlogo tanpa batas waktu.
  // Blok penjaga ini menjamin frame pertama selalu ditampilkan.
  final state = AppState();
  try {
    await _siapkan(state);
  } catch (e) {
    debugPrint('[main] penyalaan tidak lengkap, aplikasi tetap dibuka: $e');
  }
  runApp(AgrinexaApp(state: state));
}

/// Menampilkan penyebab galat di layar ketika widget gagal dibangun.
///
/// Pada mode rilis, widget yang gagal dibangun hanya tampil sebagai kotak
/// abu-abu tanpa keterangan, sehingga pengguna tidak memperoleh informasi dan
/// penyebabnya tidak pernah sampai ke pengembang.
void _tampilAlasanError() {
  if (kDebugMode) return;
  ErrorWidget.builder = (d) {
    final pesan = d.exception.toString().split('\n').take(6).join('\n').trim();
    return Material(
      color: const Color(0xFF241A12),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UiText('Layar ini gagal dibuka',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const UiText(
                  'Tutup lalu buka lagi Agrinexa. Kalau berulang, kirim foto '
                  'layar ini ke pengembang aplikasi.',
                  style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 13)),
              const SizedBox(height: 14),
              Text(pesan,
                  style: const TextStyle(
                      color: Color(0xFFFFB4A8), fontSize: 11, height: 1.35)),
              // Nomor build yang terpasang dan status penyimpanan perangkat:
              // dua informasi yang tidak dapat diperiksa tanpa kabel USB.
              const SizedBox(height: 10),
              Text('build $buildNomor · '
                  'penyimpanan: ${AppState.masalahSimpanan ?? 'terbuka'}',
                  style: const TextStyle(
                      color: Color(0xAAFFFFFF), fontSize: 11, height: 1.35)),
            ],
          ),
        ),
      ),
    );
  };
}

/// Menginisialisasi gerbang SDK dan memuat data perangkat, dengan batas waktu
/// akhir.
///
/// Setiap gerbang sudah memiliki batas waktu sendiri; batas di sini menutup
/// celah yang tersisa pada `state.load()` (membaca akun dan data kebun lama
/// dari perangkat).
Future<void> _siapkan(AppState state) async {
  // Penyimpanan perangkat dibuka paling awal dan tanpa jaringan: setiap layar
  // membacanya, sehingga tidak boleh menunggu Supabase/Firebase selesai. Bila
  // urutannya dibalik, penyimpanan baru terisi setelah 16 detik menunggu
  // jaringan dan aplikasi tampil tanpa penyimpanan -> semua layar tidak
  // berfungsi.
  await state.bukaSimpanan();
  // Harga nyata diambil dari Supabase bila tersedia; kegagalan jaringan di sini
  // tidak menghentikan aplikasi (MarketService otomatis kembali ke simulasi).
  await SupabaseGate.mulai();
  // Langganan realtime hanya boleh dijalankan setelah Supabase aktif.
  MarketService.mulaiLive();
  // Firebase digunakan untuk akun daring dan sinkronisasi kebun. Sama seperti
  // Supabase, bila tidak siap aplikasi tetap berjalan dalam mode lokal.
  await FirebaseGate.mulai();
  await state.load().timeout(const Duration(seconds: 25));
}

class AgrinexaApp extends StatefulWidget {
  final AppState state;
  const AgrinexaApp({super.key, required this.state});

  @override
  State<AgrinexaApp> createState() => _AgrinexaAppState();
}

class _AgrinexaAppState extends State<AgrinexaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.state.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.state.removeListener(_rebuild);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  void didChangePlatformBrightness() => setState(() {});

  @override
  void didChangeLocales(List<Locale>? locales) => setState(() {});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Langganan websocket dapat terputus saat tab atau perangkat dalam mode
    // tidur, dan event yang terlewat tidak dikirim ulang. Satu kali pengambilan
    // data saat aplikasi aktif kembali menutup celah tersebut.
    if (state == AppLifecycleState.resumed) MarketService.segarkan();
  }

  @override
  Widget build(BuildContext context) {
    final gelap = widget.state.gelapAktif;
    // Palet global diisi sebelum subtree apa pun dibangun, agar semua widget
    // yang membaca AppColors memperoleh mode yang benar.
    AppColors.pakai(gelap: gelap);
    // Sama seperti palet: bahasa digunakan tr() tanpa context, sehingga harus
    // diisi di sini.
    final kode = widget.state.bahasaAktif;
    Lang.pakai(kode);
    final locale = Locale(kode);
    return AppScope(
      state: widget.state,
      child: MaterialApp(
        title: 'Agrinexa',
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: const [Locale('id'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: gelap ? ThemeMode.dark : ThemeMode.light,
        // AppColors (palet global) berganti seketika; animasi tema 200 ms akan
        // membuat layar tampil separuh dengan warna lama dan separuh dengan
        // warna baru.
        themeAnimationDuration: Duration.zero,
        // Pada layar lebar (desktop/web) aplikasi ditampilkan seperti ponsel,
        // sehingga gambar tetap pada resolusi aslinya dan tidak pecah/buram.
        builder: (context, child) => ColoredBox(
          color: AppColors.darkGreen,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
        home: widget.state.loggedIn ? const MainScreen() : const SplashScreen(),
      ),
    );
  }
}
