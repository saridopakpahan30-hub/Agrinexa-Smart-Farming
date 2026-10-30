import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Latar bertema pertanian yang hidup: langit hijau berpendar, matahari dengan
/// sinar berputar, awan melayang, perbukitan berlapis beserta barisan tanaman
/// (terasering), dan tunas padi yang bergoyang tertiup angin.
///
/// [child] diberi ruang di atas bukit, sedangkan [overlay] digambar menutupi
/// seluruh area.
class AgriScene extends StatefulWidget {
  final Widget? child;
  final Widget? overlay;
  final double hillHeight;

  /// Null berarti warna halaman pada palet aktif, agar bukit depan menyatu.
  final Color? frontColor;

  const AgriScene({
    super.key,
    this.child,
    this.overlay,
    this.hillHeight = 64,
    this.frontColor,
  });

  @override
  State<AgriScene> createState() => _AgriSceneState();
}

class _AgriSceneState extends State<AgriScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 60))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _ScenePainter(_c, widget.hillHeight,
                  widget.frontColor ?? AppColors.bg, AppColors.gelap),
            ),
          ),
        ),
        if (widget.child != null)
          Padding(
            padding: EdgeInsets.only(bottom: widget.hillHeight),
            child: widget.child,
          ),
        if (widget.overlay != null) Positioned.fill(child: widget.overlay!),
      ],
    );
  }
}

class _ScenePainter extends CustomPainter {
  final Animation<double> anim;
  final double hh;
  final Color front;

  /// Mode gelap: pemandangan ikut diredam. Langit hijau terang yang cocok pada
  /// siang hari menyilaukan dan menenggelamkan kartu di latar gelap.
  final bool gelap;

  _ScenePainter(this.anim, this.hh, this.front, this.gelap)
      : super(repaint: anim);

  Color redam(Color c, double f) => gelap ? Color.lerp(c, AppColors.bg, f)! : c;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height, t = anim.value;
    final rect = Offset.zero & size;
    final skyH = math.max(h - hh, 1.0);
    final s = (hh / 70).clamp(0.8, 2.2).toDouble();

    // langit hijau
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            redam(const Color(0xFF0B4F26), 0.30),
            redam(const Color(0xFF1B7F3B), 0.62),
            redam(const Color(0xFF5DB96B), 0.74),
          ],
        ).createShader(rect),
    );

    // matahari + sinar berputar
    final sunC = Offset(w * 0.80, skyH * 0.48);
    final pulse = 46 * s + 3 * math.sin(t * math.pi * 2 * 20);
    canvas.drawCircle(
      sunC,
      pulse,
      Paint()
        ..shader = RadialGradient(
          colors: [AppColors.sun.o(0.55), AppColors.sun.o(0)],
        ).createShader(Rect.fromCircle(center: sunC, radius: pulse)),
    );
    final ray = Paint()
      ..color = AppColors.sun.o(0.16)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final a = t * math.pi * 2 * 2 + i * math.pi / 6;
      canvas.drawLine(
        sunC + Offset(math.cos(a), math.sin(a)) * (22 * s),
        sunC + Offset(math.cos(a), math.sin(a)) * (36 * s),
        ray,
      );
    }
    canvas.drawCircle(sunC, 14 * s, Paint()..color = AppColors.sun.o(0.95));

    // Awan melayang (kecepatan dibulatkan agar pengulangan tampak mulus)
    final cloudP = Paint()..color = Colors.white.o(gelap ? 0.10 : 0.20);
    void cloud(double k, double phase, double yFrac, double sc) {
      final x = ((t * k + phase) % 1.0) * (w + 160) - 80;
      final o = Offset(x, skyH * yFrac);
      canvas.drawCircle(o, 10 * sc, cloudP);
      canvas.drawCircle(o + Offset(14 * sc, -6 * sc), 13 * sc, cloudP);
      canvas.drawCircle(o + Offset(30 * sc, 0), 10 * sc, cloudP);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(o.dx, o.dy - 2 * sc, 30 * sc, 12 * sc),
            Radius.circular(6 * sc)),
        cloudP,
      );
    }

    cloud(1, 0.10, 0.25, s);
    cloud(2, 0.55, 0.62, 0.8 * s);
    cloud(1, 0.80, 0.12, 0.65 * s);

    double ridge(double x, double base, double amp, double ph, double fr) =>
        base + amp * math.sin(x / w * math.pi * 2 * fr + ph);

    Path hill(double base, double amp, double ph, double fr) {
      final p = Path()..moveTo(0, h);
      for (double x = 0; x <= w; x += 4) {
        p.lineTo(x, ridge(x, base, amp, ph, fr));
      }
      p.lineTo(w, h);
      p.close();
      return p;
    }

    // bukit belakang
    canvas.drawPath(
      hill(h - hh * 0.92, hh * 0.14, 0.5, 1.1),
      Paint()..color = redam(const Color(0xFF0E5A2B), 0.45).o(0.55),
    );

    // bukit tengah + barisan tanaman
    final midBase = h - hh * 0.60, midAmp = hh * 0.12;
    final mid = hill(midBase, midAmp, 2.2, 1.4);
    canvas.drawPath(mid, Paint()..color = redam(const Color(0xFF2E9A4D), 0.68));
    canvas.save();
    canvas.clipPath(mid);
    final rows = Paint()
      ..color = Colors.white.o(gelap ? 0.06 : 0.10)
      ..strokeWidth = 1.6;
    final topY = h - hh * 0.78;
    for (double x = -w; x <= w * 2; x += 18 * s) {
      canvas.drawLine(
        Offset(w / 2 + (x - w / 2) * 0.25, topY),
        Offset(x, h),
        rows,
      );
    }
    canvas.restore();

    // Tunas yang bergoyang di punggung bukit
    final stem = Paint()
      ..color = gelap ? AppColors.green : const Color(0xFFB7E4BF)
      ..strokeWidth = 1.6 * s
      ..strokeCap = StrokeCap.round;
    final leaf = Paint()
      ..color = gelap ? AppColors.green.o(0.80) : const Color(0xFFD5F2DA);
    final leafPath = Path()
      ..moveTo(0, -8 * s)
      ..quadraticBezierTo(9 * s, -9 * s, 12 * s, -17 * s)
      ..quadraticBezierTo(3 * s, -16 * s, 0, -8 * s);
    for (double x = 14; x < w; x += 30 * s) {
      final y = ridge(x, midBase, midAmp, 2.2, 1.4);
      final sway = math.sin(t * math.pi * 2 * 30 + x * 0.05);
      canvas.save();
      canvas.translate(x, y + 1);
      canvas.rotate(sway * 0.14);
      canvas.drawLine(Offset.zero, Offset(0, -9 * s), stem);
      canvas.drawPath(leafPath, leaf);
      canvas.scale(-1, 1);
      canvas.drawPath(leafPath, leaf);
      canvas.restore();
    }

    // Bukit depan (menyatu dengan warna halaman)
    canvas.drawPath(
      hill(h - hh * 0.24, hh * 0.10, 4.0, 1.0),
      Paint()..color = front,
    );
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) =>
      old.hh != hh || old.front != front || old.gelap != gelap;
}
