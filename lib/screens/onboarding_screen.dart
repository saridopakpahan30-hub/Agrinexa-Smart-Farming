import 'package:flutter/material.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _idx = 0;
  int _prevIdx = 0;

  static const _slides = [
    (
      'assets/images/cabai.jpg',
      'Pilih komoditas cerdas',
      'Rekomendasi tanaman dan simulasi untung-rugi dihitung dari luas lahan, modal, dan harga pasar terkini.'
    ),
    (
      'assets/images/tomat.jpg',
      'Kelola musim tanam',
      'Catat pengeluaran & pendapatan di Buku Kas, lalu pantau tiap tanaman sampai panen lewat Kalender Tanam.'
    ),
    (
      'assets/images/jagung.jpg',
      'Waspadai hama & cuaca',
      'Panduan gejala dan penanganan hama-penyakit, plus saran aktivitas harian mengikuti prakiraan cuaca.'
    ),
    (
      'assets/images/cabai.jpg',
      'Aman & personal',
      'Login dengan akun Google atau email — data lahan, modal, dan riwayat Anda tersimpan aman per akun.'
    ),
  ];

  void _finish() {
    AppScope.of(context).finishOnboarding();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()), (r) => false);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final last = _idx == _slides.length - 1;

    return Scaffold(
      // Latar gradasi halus.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F7F2), Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // Tombol lewati
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: UiText('Lewati',
                    style: TextStyle(color: AppColors.muted)),
              ),
            ),

            // PageView dengan animasi silang
            Expanded(
              child: PageView.builder(
                controller: _page,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() {
                  _prevIdx = _idx;
                  _idx = i;
                }),
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: Padding(
                      key: ValueKey(i),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(children: [
                        const SizedBox(height: 8),
                        // Tinggi banner mengikuti sisa layar, bukan 320 piksel
                        // yang dipaksakan: judul dapat menjadi dua baris dan teks
                        // Inggris lebih panjang, sedangkan Column yang tidak muat
                        // membuat seluruh layar berubah menjadi abu-abu pada
                        // perangkat 360×740 (mode rilis).
                        Expanded(
                          child: PhotoBanner(
                              asset: s.$1, height: 320, radius: 24),
                        ),
                        const SizedBox(height: 20),
                        UiText(
                          s.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        UiText(
                          s.$3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, height: 1.55, color: AppColors.muted),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),

            // Indikator titik — ukuran besar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _idx == i ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _idx == i ? AppColors.green : AppColors.line,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),

            // Tombol aksi dengan ikon
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (last) {
                      _finish();
                    } else {
                      _page.nextPage(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOut);
                    }
                  },
                  icon: Icon(
                    last ? Icons.eco_rounded : Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                  label: UiText(last ? 'Mulai Bertani' : 'Lanjut'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
