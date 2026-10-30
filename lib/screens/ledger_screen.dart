import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../models/ledger.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/price_chart.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  int _filter = 0; // 0 semua, 1 masuk, 2 keluar

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final entries = [
      for (final e in s.ledger)
        if (_filter == 0 ||
            (_filter == 1 && e.income) ||
            (_filter == 2 && !e.income))
          e
    ];
    return Scaffold(
      // Judul sudah dipindahkan ke dalam banner foto; tombol kembali tetap
      // dibuat otomatis.
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'ledger-add',
        backgroundColor: AppColors.greenFill,
        foregroundColor: Colors.white,
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const UiText('Catat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          StaggerIn(
            index: 0,
            child: PhotoBanner(
              asset: commodityById('jagung').asset,
              height: 140,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UiText('Buku Kas',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 10)
                          ])),
                  SizedBox(height: 4),
                  UiText('Pemasukan dan pengeluaran usaha tani',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 8)
                          ])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          StaggerIn(
            index: 1,
            child: _Summary(
              balance: s.ledgerBalance,
              income: s.ledgerIn,
              expense: s.ledgerOut,
            ),
          ),
          const SizedBox(height: 14),
          if (s.ledger.length >= 2)
            StaggerIn(index: 2, child: _MonthlyChart(ledger: s.ledger)),
          StaggerIn(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Riwayat Catatan'),
                Segmented(
                  labels: const ['Semua', 'Pemasukan', 'Pengeluaran'],
                  index: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 10),
                if (entries.isEmpty)
                  s.ledger.isEmpty
                      ? EmptyState(
                          icon: Icons.receipt_long_rounded,
                          title: 'Belum ada catatan',
                          body: 'Ketuk "Catat" untuk menambah pengeluaran '
                              'atau pemasukan panen.',
                          actionLabel: 'Catat',
                          onAction: () => _openForm(context),
                        )
                      : const EmptyState(
                          icon: Icons.filter_alt_off_rounded,
                          title: 'Tidak ada hasil',
                          body: 'Tidak ada catatan pada filter ini.',
                        )
                else ...[
                  const GeserHapusHint(),
                  Panel(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Column(children: [
                      for (var i = 0; i < entries.length; i++) ...[
                        _EntryRow(entry: entries[i]),
                      ],
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final int balance, income, expense;
  const _Summary(
      {required this.balance, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.darkGreen, AppColors.green],
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiText('Saldo Kas',
              style: TextStyle(color: Colors.white.o(0.8), fontSize: 14)),
          const SizedBox(height: 4),
          UiText(rp(balance),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(children: [
            _Mini('Pemasukan', income, Icons.trending_up_rounded),
            const SizedBox(width: 10),
            _Mini('Pengeluaran', expense, Icons.trending_down_rounded),
          ]),
        ]),
      );
}

class _Mini extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  const _Mini(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.o(0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.o(0.25)),
          ),
          child: Row(children: [
            Icon(icon, size: 18, color: AppColors.sun),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(label,
                        style: TextStyle(
                            fontSize: 13, color: Colors.white.o(0.85))),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: UiText(rp(value),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                    ),
                  ]),
            ),
          ]),
        ),
      );
}

class _MonthlyChart extends StatelessWidget {
  final List<LedgerEntry> ledger;
  const _MonthlyChart({required this.ledger});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i, 1)
    ];
    final inc = List.filled(6, 0.0), exp = List.filled(6, 0.0);
    for (final e in ledger) {
      final idx =
          (e.date.year * 12 + e.date.month) - (now.year * 12 + now.month) + 5;
      if (idx >= 0 && idx < 6) {
        if (e.income) {
          inc[idx] += e.amount;
        } else {
          exp[idx] += e.amount;
        }
      }
    }
    final maxY = ([...inc, ...exp, 1].reduce((a, b) => a > b ? a : b)) * 1.15;
    const hide = AxisTitles(sideTitles: SideTitles(showTitles: false));
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const UiText('Arus Kas 6 Bulan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Wrap(spacing: 14, runSpacing: 6, children: [
          _Dot(color: AppColors.green, label: 'Uang masuk'),
          _Dot(color: AppColors.down, label: 'Uang keluar'),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: BarChart(BarChartData(
            maxY: maxY,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (v) =>
                  FlLine(color: AppColors.line, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: priceBarTouch(
                (v) => v >= 1000000 ? jt(v) : thousands(v.round())),
            titlesData: FlTitlesData(
              topTitles: hide,
              rightTitles: hide,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  interval: maxY / 4,
                  getTitlesWidget: (v, m) => UiText(v == 0 ? '0' : jt(v),
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (v, m) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: UiText(namaBulan(months[v.toInt()]),
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  ),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < 6; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: inc[i],
                    width: 10,
                    color: AppColors.green,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  BarChartRodData(
                    toY: exp[i],
                    width: 10,
                    color: AppColors.down.o(0.85),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ]),
            ],
          )),
        ),
      ]),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        UiText(label, style: TextStyle(fontSize: 13, color: AppColors.muted)),
      ]);
}

class _EntryRow extends StatelessWidget {
  final LedgerEntry entry;
  const _EntryRow({required this.entry});

  @override
  Widget build(BuildContext context) => Dismissible(
        key: ValueKey(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: AppColors.down.o(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.delete_rounded, color: AppColors.down),
        ),
        onDismissed: (_) {
          final s = AppScope.of(context);
          final posisi = s.ledger.indexWhere((e) => e.id == entry.id);
          s.removeLedger(entry.id);
          toastUndo(
            context,
            tpl('Catatan "{0}" dihapus', [tr(entry.category)]),
            () => s.restoreLedger(entry, posisi < 0 ? 0 : posisi),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color:
                    (entry.income ? AppColors.green : AppColors.down).o(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                entry.income
                    ? Icons.south_west_rounded
                    : Icons.north_east_rounded,
                size: 20,
                color: entry.income ? AppColors.green : AppColors.down,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.note.isEmpty
                          ? tr(entry.category)
                          : tpl('{0} · {1}', [tr(entry.category), entry.note]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    UiText(
                      '${tanggalPendek(entry.date)} ${entry.date.year}'
                      '${entry.commodityId != null ? ' • ${tr(commodityById(entry.commodityId!).name)}' : ''}',
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ]),
            ),
            UiText(
              '${entry.income ? '+' : '-'} ${rp(entry.amount)}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: entry.income ? AppColors.green : AppColors.down),
            ),
          ]),
        ),
      );
}

Future<void> _openForm(BuildContext context) async {
  final s = AppScope.of(context);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _LedgerForm(state: s),
  );
}

class _LedgerForm extends StatefulWidget {
  final AppState state;
  const _LedgerForm({required this.state});

  @override
  State<_LedgerForm> createState() => _LedgerFormState();
}

class _LedgerFormState extends State<_LedgerForm> {
  bool _income = false;
  String _category = expenseCategories.first;
  String? _commodityId;
  DateTime _date = DateTime.now();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String? _error;

  void _pickCategory(bool income) {
    setState(() {
      _income = income;
      final cats = income ? incomeCategories : expenseCategories;
      if (!cats.contains(_category)) _category = cats.first;
    });
  }

  Future<void> _save() async {
    final amount = parseInt(_amount.text);
    if (amount <= 0) {
      setState(() => _error = 'Isi jumlah lebih dari 0.');
      return;
    }
    await widget.state.addLedger(LedgerEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timeMs: _date.millisecondsSinceEpoch,
      income: _income,
      category: _category,
      amount: amount,
      note: _note.text.trim(),
      commodityId: _commodityId,
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cats = _income ? incomeCategories : expenseCategories;
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 14),
          UiText(tpl('Catat {0}', [tr(_income ? 'Pemasukan' : 'Pengeluaran')]),
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Segmented(
            labels: const ['Pengeluaran', 'Pemasukan'],
            index: _income ? 1 : 0,
            onChanged: (i) => _pickCategory(i == 1),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in cats)
                ChoiceChip(
                  label: UiText(c),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                ),
            ],
          ),
          const SizedBox(height: 14),
          NumField(label: 'Jumlah', controller: _amount, suffix: ''),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
                hintText: tr('Catatan (opsional), mis. beli pupuk urea')),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: _commodityId,
            decoration:
                InputDecoration(labelText: tr('Komoditas terkait (opsional)')),
            items: [
              const DropdownMenuItem(value: null, child: UiText('—')),
              for (final c in commodities)
                DropdownMenuItem(value: c.id, child: UiText(c.name)),
            ],
            onChanged: (v) => setState(() => _commodityId = v),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.event_rounded, color: AppColors.green),
            title: UiText(tpl('Tanggal: {0}', [tanggalPanjang(_date)]),
                style: const TextStyle(fontSize: 14)),
            trailing:
                Icon(Icons.edit_rounded, size: 18, color: AppColors.muted),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              );
              if (d != null) setState(() => _date = d);
            },
          ),
          if (_error != null)
            UiText(_error!,
                style: TextStyle(color: AppColors.down, fontSize: 14)),
          const SizedBox(height: 14),
          ElevatedButton(
              onPressed: _save, child: const UiText('Simpan Catatan')),
        ],
      ),
    );
  }
}
