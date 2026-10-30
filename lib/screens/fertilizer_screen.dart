import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../data/fertilizers.dart';
import '../models/commodity.dart';
import '../models/crop_guide.dart';
import '../services/fert_calc.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

/// Kalkulator pupuk: berapa kilogram, jenis apa saja, diberikan kapan dan
/// dengan cara apa, apa akibatnya bila kurang atau berlebih, dan mengapa pupuk
/// tersebut sesuai untuk tanaman ini.
class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final _area = TextEditingController();
  String? _crop;
  final Set<int> _buka = {};
  int? _tanamanManual;

  List<Commodity> get _bisa =>
      [for (final c in commodities) if (guideFor(c.id) != null) c];

  Commodity get _c {
    final id = _crop ?? AppScope.of(context).activeId;
    return _bisa.firstWhere((c) => c.id == id,
        orElse: () => _bisa.firstWhere((c) => c.id == 'cabai'));
  }

  double get _luas {
    final v = double.tryParse(_area.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    return (v == null || v <= 0)
        ? AppScope.of(context).landArea.toDouble()
        : v;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() =>
          _area.text = thousands(AppScope.of(context).landArea));
    });
  }

  @override
  void dispose() {
    _area.dispose();
    super.dispose();
  }

  void _toggle(int i) =>
      setState(() => _buka.contains(i) ? _buka.remove(i) : _buka.add(i));

  @override
  Widget build(BuildContext context) {
    final c = _c;
    final g = guideFor(c.id)!;
    final luas = _luas;
    final plan = fertilizerPlan(g, luas);
    final tanaman = _tanamanManual ?? plantCount(c, g, luas);
    final tambahan = [for (final f in g.fertilizers) if (!f.hasAmount) f];

    return Scaffold(
      appBar: AppBar(title: const UiText('Kalkulator Pupuk')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _pilihTanaman(c),
          const SizedBox(height: 12),
          _ringkasan(c, g, luas, tanaman),
          if (plan.isEmpty) ...[
            const SizedBox(height: 12),
            Panel(
              child: UiText(
                'Panduan tanaman ini belum mencantumkan dosis angka, jadi '
                'hitungannya belum bisa dibuat. Lihat daftar tambahan di bawah.',
                style: TextStyle(fontSize: 14, color: AppColors.muted),
              ),
            ),
          ] else ...[
            SectionTitle(tpl('Rencana pupuk {0}', [tr(c.name)])),
            for (var i = 0; i < plan.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _kartu(plan[i], c, g, tanaman, i),
            ],
          ],
          if (tambahan.isNotEmpty) ...[
            const SectionTitle('Tambahan tanpa dosis tetap'),
            Panel(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final f in tambahan)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6, right: 10),
                                child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                        color: AppColors.leaf,
                                        shape: BoxShape.circle)),
                              ),
                              Expanded(
                                child: UiText('${tr(f.name)}: ${tr(f.detail)}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.45,
                                        color: AppColors.text)),
                              ),
                            ]),
                      ),
                  ]),
            ),
          ],
          const SizedBox(height: 14),
          Panel(
            color: AppColors.mint,
            child: UiText(
              'Angka ini dihitung dari dosis anjuran umum dan luas lahan Anda. '
              'Uji tanah dan penyuluh (PPL) setempat lebih akurat karena mereka '
              'melihat tanah Anda langsung. Beri lebih sedikit daripada '
              'membuang pupuk: kelebihan tidak membuat panen lebih banyak.',
              style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.onMint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pilihTanaman(Commodity c) {
    final bisa = _bisa;
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiText('Tanaman',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.muted)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          key: ValueKey('tanaman:${c.id}'),
          isDense: true,
          isExpanded: true,
          initialValue: c.id,
          items: [
            for (final x in bisa)
              DropdownMenuItem(
                value: x.id,
                child: UiText('${x.emoji} ${x.name}',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) => setState(() {
            _crop = v;
            _buka.clear();
            _tanamanManual = null;
          }),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _area,
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsFormatter()],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: tr('Luas lahan (m²)'),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.number,
          onSubmitted: (_) => setState(() {}),
          onChanged: (v) => setState(() {
            final n = int.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
            _tanamanManual = (n == null || n <= 0) ? null : n;
          }),
          decoration: InputDecoration(
            labelText: tr('Jumlah tanaman (opsional)'),
            helperText: tr('kosongkan untuk hitung dari jarak tanam'),
            isDense: true,
          ),
        ),
      ]),
    );
  }

  Widget _ringkasan(Commodity c, CropGuide g, double luas, int tanaman) {
    final ha = luas / 10000;
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.eco_rounded, size: 20, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: UiText(
              tpl('{0} m² = {1} ha', [
                thousands(luas.round()),
                ha.toStringAsFixed(ha < 0.1 ? 3 : 2).replaceAll('.', Lang.inggris ? '.' : ','),
              ]),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        KeyValue(
            tr('Jumlah tanaman'),
            tanaman > 0
                ? tpl('{0} batang', [thousands(tanaman)])
                : tr('belum tentu dari jarak tanam')),
        KeyValue(tr('Jarak tanam'), g.spacing),
        KeyValue(tr('pH tanah ideal'),
            tpl('{0} sampai {1}', [_desa(g.phMin), _desa(g.phMax)])),
        KeyValue(tr('Umur panen'), tpl('{0} hari', [thousands(c.growDays)])),
      ]),
    );
  }

  Widget _kartu(
      FertAmount a, Commodity c, CropGuide g, int tanaman, int index) {
    final kind = kindFor(a.fert.name);
    final buka = _buka.contains(index);
    final perTanaman = dosisPerTanaman(gramsPerPlant(a.highKg, tanaman) / 1000);
    final karung = a.highKg >= 25 && !a.fert.unit.contains('pohon')
        ? tpl('sekitar {0} karung @50 kg', ['${(a.highKg / 50).ceil()}'])
        : null;

    return Panel(
      onTap: kind == null ? null : () => _toggle(index),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(a.fert.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              UiText(kind?.unsur ?? a.fert.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ]),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            UiText(rentangKg(a.lowKg, a.highKg),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green)),
            if (perTanaman.isNotEmpty)
              UiText('$perTanaman / ${tr('batang')}',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ]),
        ]),
        if (karung != null) ...[
          const SizedBox(height: 8),
          Pill(karung, bg: AppColors.mint, fg: AppColors.onMint),
        ],
        if (kind != null) ...[
          const SizedBox(height: 8),
          UiText(buka ? tr('Tutup penjelasan') : tr('Kenapa dan bagaimana'),
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
        ],
        if (buka && kind != null) ...[
          const Divider(height: 24),
          _blok(Icons.schedule_rounded, tr('Jadwal pemberian'),
              _jadwal(g, kind, c.growDays), AppColors.green),
          _blok(Icons.water_drop_rounded, tr('Cara aplikasi'), kind.method,
              AppColors.aksen(const Color(0xFF1565C0))),
          _blok(Icons.error_outline_rounded, tr('Bila kekurangan'),
              kind.deficiency, AppColors.down),
          _blok(Icons.trending_up_rounded, tr('Bila terlalu banyak'),
              kind.excess, AppColors.down),
          if (kind.split.isNotEmpty)
            _blok(Icons.rule_rounded, tr('Batas aman'), kind.split, AppColors.muted),
          for (final r in fertAlasan(c: c, g: g, k: kind))
            _blok(
                r.caution
                    ? Icons.warning_amber_rounded
                    : Icons.lightbulb_outline_rounded,
                r.title,
                r.text,
                r.caution ? AppColors.sunInk : AppColors.leaf),
        ],
      ]),
    );
  }

  String _jadwal(CropGuide g, FertKind kind, int growDays) {
    final parts = <String>[];
    for (final w in fertSchedule(g, kind, growDays)) {
      if (w.beforePlanting) {
        parts.add(tr('sebelum tanam'));
      } else {
        parts.add(tpl('minggu ke-{0}–{1}', ['${w.fromWeek}', '${w.toWeek}']));
      }
    }
    return '${parts.join(', ')} — ${kind.phases.map((id) => FertPhase.byId(id).name).map(tr).join(', ')}';
  }

  Widget _blok(IconData icon, String judul, String isi, Color warna) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 16, color: warna),
            const SizedBox(width: 8),
            UiText(judul,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800, color: warna)),
          ]),
          const SizedBox(height: 4),
          UiText(isi,
              style: TextStyle(fontSize: 14, height: 1.45, color: AppColors.text)),
        ]),
      );
}

String _desa(double v) =>
    v.toStringAsFixed(v % 1 == 0 ? 0 : 1).replaceAll('.', ',');
