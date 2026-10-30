import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import 'agri_scene.dart';

void push(BuildContext c, Widget w) =>
    Navigator.of(c).push(MaterialPageRoute(builder: (_) => w));

void toast(BuildContext c, String m) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: UiText(m),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkGreen,
    ));
}

/// Pesan singkat yang dapat dibatalkan. Menghapus dengan geser lebih cepat
/// daripada dialog konfirmasi dan tetap aman, karena satu ketukan mengembalikan
/// data yang baru saja dihapus.
void toastUndo(BuildContext c, String m, VoidCallback onUndo) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: UiText(m),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkGreen,
      action: SnackBarAction(label: tr('Urungkan'), onPressed: onUndo),
    ));
}

/// Pengguna tidak akan mengetahui bahwa sebuah kartu dapat digeser bila tidak
/// diberi tahu sekali. Petunjuk ini ditempatkan di atas daftar yang hapusnya
/// menggunakan geser.
class GeserHapusHint extends StatelessWidget {
  const GeserHapusHint({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(Icons.swipe_rounded, size: 16, color: AppColors.muted),
          const SizedBox(width: 6),
          Expanded(
              child: UiText(
                  'Geser kartu ke kiri untuk menghapus — bisa diurungkan.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted))),
        ]),
      );
}

/// Gambar dari assets dengan tampilan cadangan bila berkas belum tersedia.
class AssetImg extends StatelessWidget {
  final String path;
  final double? width, height;
  final BoxFit fit;
  final Widget fallback;

  const AssetImg(this.path,
      {super.key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      required this.fallback});

  static const _exts = ['.png', '.jpg', '.jpeg', '.webp'];

  /// Mencoba .png, kemudian .jpg, .jpeg, dan .webp dengan nama berkas yang
  /// sama.
  @override
  Widget build(BuildContext context) {
    final dot = path.lastIndexOf('.');
    final base = dot < 0 ? path : path.substring(0, dot);
    Widget attempt(int i) {
      if (i >= _exts.length) return fallback;
      return Image.asset(
        '$base${_exts[i]}',
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => attempt(i + 1),
      );
    }

    return attempt(0);
  }
}

class CommodityImage extends StatelessWidget {
  final Commodity c;
  final double size, radius;
  final String? heroTag;
  const CommodityImage(this.c,
      {super.key, this.size = 56, this.radius = 12, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final img = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AssetImg(
        c.asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        fallback: Container(
          width: size,
          height: size,
          color: AppColors.aksen(c.color).o(AppColors.gelap ? 0.26 : 0.14),
          alignment: Alignment.center,
          child: UiText(c.emoji, style: TextStyle(fontSize: size * 0.5)),
        ),
      ),
    );
    if (heroTag == null) return img;
    return Hero(tag: heroTag!, child: img);
  }
}

/// Banner foto lebar dengan gradasi gelap di bagian bawah untuk teks putih.
/// Bila foto belum tersedia, otomatis memakai pemandangan AgriScene.
class PhotoBanner extends StatelessWidget {
  final String asset;
  final double height;
  final Widget child;
  final double radius;
  final String? heroTag;

  const PhotoBanner({
    super.key,
    required this.asset,
    required this.height,
    this.child = const SizedBox.shrink(),
    this.radius = 18,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget img = AssetImg(
      asset,
      fallback: AgriScene(
        hillHeight: height * 0.45,
        frontColor: AppColors.darkGreen,
      ),
    );
    if (heroTag != null) img = Hero(tag: heroTag!, child: img);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 6))
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            img,
            // Veil merata: meredam foto bergaris ramai agar teks tetap terbaca
            const ColoredBox(color: Color(0x3A000000)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x40000000),
                    Color(0x14000000),
                    Color(0x80000000),
                    Color(0xD9000000)
                  ],
                  stops: [0.0, 0.30, 0.62, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kapsul gelap semi-transparan — satu-satunya cara aman menempatkan teks atau
/// angka berwarna di atas foto, karena kecerahan foto tidak dapat dijamin.
class GlassChip extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color bg;
  const GlassChip(this.child,
      {super.key,
      this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      this.bg = const Color(0x73000000)});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.o(0.22)),
        ),
        child: Padding(padding: padding, child: child),
      );
}

/// Placeholder berdenyut selama data dimuat. Lebih tenang daripada spinner dan
/// susunannya meniru layar sebenarnya, sehingga konten tidak "melompat" ketika
/// data siap.
class Skeleton extends StatefulWidget {
  final double height, radius, width;
  const Skeleton(
      {super.key, this.height = 16, this.radius = 8, this.width = 0});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween(begin: 0.45, end: 0.95).animate(_c),
        child: Container(
          width: widget.width > 0 ? widget.width : double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.line,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      );
}

/// Pengganti teks abu-abu "Belum ada …" yang polos.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, body;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.body,
      this.actionLabel,
      this.onAction});

  @override
  Widget build(BuildContext context) => Panel(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
        child: Column(children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.green.o(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.green.o(0.16)),
            ),
            child: Icon(icon, size: 27, color: AppColors.green),
          ),
          const SizedBox(height: 14),
          UiText(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          UiText(body,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.muted, height: 1.45)),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: UiText(actionLabel!),
            ),
          ],
        ]),
      );
}

/// Muncul dengan efek pudar dan geser, berjenjang menurut [index].
class StaggerIn extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration delay;
  const StaggerIn(
      {super.key,
      required this.index,
      required this.child,
      this.delay = const Duration(milliseconds: 70)});

  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 420));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay * widget.index, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (_, child) {
          final t = Curves.easeOutCubic.transform(_c.value);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 26),
              child: child,
            ),
          );
        },
      );
}

/// Kartu yang sedikit mengecil saat ditekan.
class ScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const ScaleTap({super.key, required this.child, this.onTap});

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _down = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _down ? 0.96 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      );
}

class Avatar extends StatelessWidget {
  final String name;
  final double size;
  final String? emoji;
  const Avatar(this.name, {super.key, this.size = 44, this.emoji});

  @override
  Widget build(BuildContext context) {
    if (emoji != null && emoji!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration:
            BoxDecoration(color: AppColors.mint, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: UiText(emoji!, style: TextStyle(fontSize: size * 0.52)),
      );
    }
    return ClipOval(
      child: AssetImg(
        Assets.avatar,
        width: size,
        height: size,
        fallback: Container(
          width: size,
          height: size,
          color: AppColors.leaf,
          alignment: Alignment.center,
          child: UiText(
            name.isEmpty ? '?' : name.trim()[0].toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.45,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  /// Null berarti warna kartu pada palet aktif (putih di mode terang,
  /// hijau-arang di mode gelap).
  final Color? color;
  final Color? border;
  final VoidCallback? onTap;
  final double radius;

  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
    this.border,
    this.onTap,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    final gelap = AppColors.gelap;
    return Material(
      color: color ?? AppColors.card,
      borderRadius: r,
      child: InkWell(
        onTap: onTap,
        borderRadius: r,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: r,
            // Mode terang: tanpa garis tepi, kartu dipisahkan oleh bayangan dan
            // warna halaman. Mode gelap: bayangan hampir tidak terlihat di latar
            // hitam, sehingga garis tepi setipis rambut yang memisahkan kartu.
            border: border != null
                ? Border.all(color: border!)
                : (gelap ? Border.all(color: AppColors.line) : null),
            boxShadow: [
              BoxShadow(
                  color: gelap ? Colors.black.o(0x59) : const Color(0x141F2A24),
                  blurRadius: gelap ? 12 : 16,
                  offset: Offset(0, gelap ? 3 : 4))
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: UiText(text,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface)),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final Color? bg, fg;
  const Pill(this.text, {super.key, this.bg, this.fg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: bg ?? AppColors.greenFill,
            borderRadius: BorderRadius.circular(8)),
        child: UiText(text,
            style: TextStyle(
                color: fg ?? Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      );
}

class ChangeText extends StatelessWidget {
  final double value;

  /// Di atas foto, angka hijau/merah yang biasa menjadi tidak terbaca —
  /// gunakan kapsul kaca.
  final bool onPhoto;
  const ChangeText(this.value, {super.key, this.onPhoto = false});

  @override
  Widget build(BuildContext context) {
    final up = value >= 0;
    if (onPhoto) {
      return GlassChip(Row(mainAxisSize: MainAxisSize.min, children: [
        UiText(up ? '▲' : '▼',
            style: TextStyle(
                fontSize: 13,
                height: 1.1,
                color: up ? AppColors.leaf : const Color(0xFFFF8A80))),
        const SizedBox(width: 4),
        UiText(pct(value, sign: true),
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ]));
    }
    return UiText(
      '${up ? '▲' : '▼'} ${pct(value, sign: true)}',
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: up ? AppColors.green : AppColors.down),
    );
  }
}

class Segmented extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  const Segmented(
      {super.key,
      required this.labels,
      required this.index,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  margin:
                      EdgeInsets.only(right: i == labels.length - 1 ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.green : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: i == index ? AppColors.green : AppColors.line),
                  ),
                  child: UiText(labels[i],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: i == index ? Colors.white : AppColors.muted)),
                ),
              ),
            ),
        ],
      );
}

class KeyValue extends StatelessWidget {
  final String k, v;
  final bool bold;
  final Color? color;
  final int? maxLines;
  const KeyValue(this.k, this.v,
      {super.key, this.bold = false, this.color, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: UiText(k,
                  maxLines: maxLines,
                  overflow: maxLines == null
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: AppColors.muted)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: UiText(v,
                  maxLines: maxLines,
                  overflow: maxLines == null
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                      color: color ?? AppColors.text)),
            ),
          ],
        ),
      );
}

class NumField extends StatelessWidget {
  final String label, suffix;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  const NumField(
      {super.key,
      required this.label,
      required this.controller,
      this.suffix = '',
      this.onChanged,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted});

  /// Kolom terakhir memakai [onSubmitted]; sisanya berpindah ke kolom
  /// berikutnya agar jari tidak perlu meninggalkan papan ketik.
  void _kirim(BuildContext c, String v) =>
      onSubmitted != null ? onSubmitted!(v) : FocusScope.of(c).nextFocus();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiText(label, style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsFormatter()],
            onChanged: onChanged,
            textInputAction: textInputAction,
            onSubmitted: (v) => _kirim(context, v),
            decoration: InputDecoration(
              suffixText: suffix.isEmpty ? null : suffix,
              prefixText: suffix.isEmpty ? 'Rp ' : null,
            ),
          ),
        ],
      );
}
