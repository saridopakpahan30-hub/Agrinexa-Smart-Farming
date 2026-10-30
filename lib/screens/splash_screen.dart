import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/build.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/agri_scene.dart';
import '../widgets/common.dart';
import 'login_screen.dart';

// ---------------------------------------------------------------------------
// Pelukis partikel
// ---------------------------------------------------------------------------
class _Particle {
  double x, y, size, speed;
  _Particle(this.x, this.y, this.size, this.speed);
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // Nilai animasi dari 0 sampai 1
  _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xAAFFD54F)
      ..style = PaintingStyle.fill;

    for (final p in particles) {
      final dy = (p.y + p.speed * progress * size.height) % size.height;
      canvas.drawCircle(Offset(p.x * size.width, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------
// Layar pembuka
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..forward();

  late final AnimationController _glowC = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat(reverse: true);

  late final AnimationController _particleC = AnimationController(
      vsync: this, duration: const Duration(seconds: 6))
    ..repeat();

  // 15 partikel dengan seed tetap agar susunannya selalu sama pada setiap
  // pembangunan ulang layar.
  final List<_Particle> _particles = List.generate(15, (i) {
    final rng = math.Random(i * 7 + 13);
    return _Particle(
      rng.nextDouble(),
      rng.nextDouble(),
      rng.nextDouble() * 2.5 + 1.0,
      rng.nextDouble() * 0.4 + 0.2,
    );
  });

  @override
  void dispose() {
    _c.dispose();
    _glowC.dispose();
    _particleC.dispose();
    super.dispose();
  }

  Widget _rise(int i, Widget child) => AnimatedBuilder(
        animation: _c,
        child: child,
        builder: (_, w) {
          final d = i * 0.15;
          final t = Curves.easeOutCubic
              .transform(((_c.value - d) / (1 - d)).clamp(0.0, 1.0));
          return Opacity(
            opacity: t,
            child:
                Transform.translate(offset: Offset(0, 26 * (1 - t)), child: w),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    const shadow = [Shadow(color: Color(0x66000000), blurRadius: 8)];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar belakang
          AssetImg(
            Assets.splash,
            fallback:
                AgriScene(hillHeight: 260, frontColor: AppColors.darkGreen),
          ),

          // Gradasi peneduh — lebih pekat di bagian bawah
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Color(0x00000000),
                  Color(0xBB000000),
                ],
              ),
            ),
          ),

          // Partikel
          AnimatedBuilder(
            animation: _particleC,
            builder: (_, __) => CustomPaint(
              painter: _ParticlePainter(_particles, _particleC.value),
            ),
          ),

          // Konten
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo dan cincin cahaya
                  _rise(
                    0,
                    AnimatedBuilder(
                      animation: _glowC,
                      builder: (_, child) {
                        final glow = _glowC.value;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Cincin cahaya bagian luar
                            Container(
                              width: 120 + glow * 14,
                              height: 120 + glow * 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withOpacity(0.08 + glow * 0.08),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(0.12 + glow * 0.10),
                                    blurRadius: 24 + glow * 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            // Cincin cahaya bagian dalam
                            Container(
                              width: 106,
                              height: 106,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withOpacity(0.10 + glow * 0.06),
                              ),
                            ),
                            child!,
                          ],
                        );
                      },
                      child: AssetImg(
                        Assets.logo,
                        width: 96,
                        height: 96,
                        fit: BoxFit.contain,
                        fallback: const Icon(Icons.eco_rounded,
                            size: 92, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _rise(
                    1,
                    Column(children: [
                      const UiText(
                        'Agrinexa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          shadows: shadow,
                        ),
                      ),
                      const UiText(
                        'Data hari ini, panen esok 🌾',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          shadows: shadow,
                        ),
                      ),
                    ]),
                  ),

                  const Spacer(flex: 4),

                  // Tombol "Mulai"
                  _rise(
                    2,
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x661B5E20),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 22),
                          label: const UiText(
                            'Mulai',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Nomor build yang terpasang. Tiga APK sebelumnya tidak dapat
                  // dibedakan sama sekali, sehingga foto layar tidak berguna
                  // untuk mengetahui versi mana yang terpasang di perangkat.
                  const Text('build $buildNomor',
                      style: TextStyle(
                          color: Color(0x99FFFFFF), fontSize: 11)),

                  // Bila penyimpanan perangkat gagal dibuka, aplikasi tetap
                  // berjalan tetapi tidak menyimpan apa pun, dan kondisi itu
                  // harus terlihat. Menggunakan Flexible, bukan tinggi tetap:
                  // dua baris tambahan pernah membuat seluruh layar menjadi
                  // abu-abu pada perangkat kecil.
                  if (AppState.masalahSimpanan != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: UiText(
                          AppState.masalahSimpanan!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFFFFCDD2), fontSize: 11),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
