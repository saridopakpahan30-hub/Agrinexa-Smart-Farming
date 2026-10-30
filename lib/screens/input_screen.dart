import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'recommendation_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _area = TextEditingController();
  final _cap = TextEditingController();
  String _type = landTypes.first, _goal = 'Keuntungan';
  bool _init = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final s = AppScope.of(context);
    _area.text = thousands(s.landArea);
    _cap.text = thousands(s.capital);
    _type = s.landType;
    _goal = s.goal;
  }

  @override
  void dispose() {
    _area.dispose();
    _cap.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final area = parseInt(_area.text), cap = parseInt(_cap.text);
    if (area < 1) return setState(() => _error = 'Luas lahan minimal 1 m².');
    if (cap < 100000) {
      return setState(() => _error = 'Modal minimal Rp 100.000.');
    }
    final s = AppScope.of(context);
    final nav = Navigator.of(context);
    await s.saveFarm(area: area, cap: cap, type: _type, goalValue: _goal);
    nav.pushReplacement(MaterialPageRoute(
        builder: (_) => const RecommendationScreen(embedded: false)));
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: UiText(t,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const UiText('Input Lahan & Modal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _title('Data Lahan'),
          NumField(label: 'Luas Lahan', controller: _area, suffix: 'm²'),
          const SizedBox(height: 14),
          UiText('Jenis Tanah',
              style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: DropdownButton<String>(
              value: _type,
              isExpanded: true,
              underline: const SizedBox(),
              items: [
                for (final t in landTypes)
                  DropdownMenuItem(value: t, child: UiText(t))
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
          ),
          _title('Modal Tersedia'),
          NumField(
              label: 'Jumlah Modal',
              controller: _cap,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _next()),
          _title('Preferensi'),
          UiText('Tujuan Utama',
              style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 8),
          Segmented(
            labels: const ['Keuntungan', 'Kestabilan'],
            index: _goal == 'Keuntungan' ? 0 : 1,
            onChanged: (i) =>
                setState(() => _goal = i == 0 ? 'Keuntungan' : 'Kestabilan'),
          ),
          const SizedBox(height: 8),
          UiText(
            _goal == 'Keuntungan'
                ? 'Mengurutkan komoditas dari margin terbesar.'
                : 'Memprioritaskan komoditas dengan harga lebih stabil.',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: UiText(_error!,
                  style: TextStyle(color: AppColors.down, fontSize: 14)),
            ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _next, child: const UiText('Lanjut')),
        ],
      ),
    );
  }
}
