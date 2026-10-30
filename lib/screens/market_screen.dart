import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../services/market_service.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/price_chart.dart';

class MarketScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onMenu;
  const MarketScreen({super.key, this.embedded = false, this.onMenu});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _ci = 0, _range = 0;
  String _q = '';
  static const _ranges = ['7H', '1B', '3B', '6B', '1T'];
  static const _days = [7, 30, 90, 180, 365];

  @override
  void initState() {
    super.initState();
    // Sekali pada awal: mengambil harga dari Supabase bila tersedia. Tanpa
    // jaringan atau bila Supabase belum siap, panggilan ini tidak melakukan
    // apa pun dan layar tetap menggunakan simulasi.
    WidgetsBinding.instance.addPostFrameCallback((_) => _muat());
    // Harga yang berubah di Supabase dilaporkan melalui MarketService.versi,
    // sehingga layar ini ikut diperbarui tanpa perlu dibuka ulang.
    MarketService.versi.addListener(_hargaBerubah);
  }

  @override
  void dispose() {
    MarketService.versi.removeListener(_hargaBerubah);
    super.dispose();
  }

  void _hargaBerubah() {
    if (mounted) setState(() {});
  }

  Future<void> _muat() async {
    await MarketService.segarkan();
    if (mounted) setState(() {});
  }

  /// Baris kecil di bawah nama komoditas: dari mana angkanya berasal. Urutannya
  /// sama dengan prioritas harga, yaitu catatan sendiri, lalu Supabase, lalu
  /// simulasi lokal (yang tidak diberi label karena sudah dijelaskan banner).
  Widget? _asal(Commodity c) {
    if (MarketService.isManual(c)) {
      return UiText('harga catatan Anda',
          style: TextStyle(fontSize: 12, color: AppColors.green));
    }
    final a = MarketService.liveAsal[c.id];
    if (a == null) return null;
    if (a.kebijakan) {
      // HPP: angka resmi pemerintah, tetapi bukan harga pasar dan tidak
      // bergerak setiap hari. Warnanya netral, bukan hijau harga pasar.
      return UiText(tpl('{0} · {1}', [a.sumber, tanggalPendek(a.tanggal)]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: AppColors.text));
    }
    if (a.nyata) {
      return UiText(tpl('{0} · {1}', [a.sumber, tanggalPendek(a.tanggal)]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: AppColors.green));
    }
    if (a.harian) {
      // Simulasi yang diperbarui setiap hari: tanggalnya berguna (pengguna tahu
      // angkanya segar), tetapi warnanya sengaja bukan hijau harga pasar.
      return UiText(tpl('simulasi harian · {0}', [tanggalPendek(a.tanggal)]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: AppColors.sunInk));
    }
    return UiText('masih simulasi',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: AppColors.sunInk));
  }

  /// Banner penjelas: jangan menyebut "harga terkini" apabila isi tabel
  /// masih angka bawaan yang belum diganti dengan harga pasar.
  String _catatanSumber() {
    final nyata = MarketService.nyataCount();
    final own = MarketService.manualCount();
    final acuan = MarketService.acuanCount();
    String isi;
    if (!MarketService.adaLive) {
      isi = own > 0
          ? tpl('{0} komoditas memakai harga catatan Anda; sisanya simulasi.',
              [own.toString()])
          : MarketService.sourceNote;
    } else if (nyata == 0) {
      isi = own > 0
          ? tpl(
              '{0} komoditas memakai harga catatan Anda; sisanya masih contoh di Supabase.',
              [own.toString()])
          : 'Semua angka dari Supabase masih contoh, belum harga pasar nyata — '
              'tarik ke bawah untuk menyegarkan.';
    } else {
      isi = own > 0
          ? tpl(
              '{0} komoditas memakai harga catatan Anda; {1} lainnya harga pasar nyata dari Supabase.',
              [
                  own.toString(),
                  nyata.toString()
                ])
          : tpl(
              '{0} komoditas memakai harga pasar nyata dari Supabase; sisanya masih simulasi.',
              [nyata.toString()]);
    }
    if (acuan > 0) {
      isi = '$isi '
          '${tr('Gabah memakai HPP pemerintah (acuan), bukan harga pasar harian.')}';
    }
    return isi;
  }

  @override
  Widget build(BuildContext context) {
    final shown = [
      for (var i = 0; i < commodities.length; i++)
        if (_q.isEmpty ||
            commodities[i].fullName.toLowerCase().contains(_q) ||
            commodities[i].category.toLowerCase().contains(_q))
          i
    ];
    final ci = shown.contains(_ci) ? _ci : (shown.isEmpty ? 0 : shown.first);
    final c = commodities[ci];
    return Scaffold(
      appBar: AppBar(
        leading: widget.embedded
            ? IconButton(
                icon: const Icon(Icons.menu_rounded), onPressed: widget.onMenu)
            : null,
        title: const UiText('Informasi Pasar'),
      ),
      body: RefreshIndicator(
        onRefresh: _muat,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: tr('Cari komoditas (nama atau kategori)'),
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final i in shown)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: UiText(commodities[i].emoji),
                      label: UiText(commodities[i].name),
                      selected: ci == i,
                      onSelected: (_) => setState(() => _ci = i),
                      selectedColor: AppColors.mint,
                      backgroundColor: AppColors.card,
                      showCheckmark: false,
                      side: BorderSide(
                          color: ci == i ? AppColors.green : AppColors.line),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 14),
            PhotoBanner(
              asset: c.asset,
              height: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UiText(c.fullName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Color(0x55000000), blurRadius: 6)
                          ])),
                  const SizedBox(height: 4),
                  Row(children: [
                    Flexible(
                      child: UiText('${rp(MarketService.current(c))}/kg',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(color: Color(0x66000000), blurRadius: 6)
                              ])),
                    ),
                    const SizedBox(width: 8),
                    ChangeText(MarketService.changePct(c), onPhoto: true),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: UiText('sejak kemarin',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white.o(0.88), fontSize: 13)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ..._price(c),
            const SectionTitle('Data Harga Terbaru'),
            Panel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(children: [
                for (var k = 0; k < shown.length; k++) ...[
                  InkWell(
                    onTap: () => setState(() => _ci = shown[k]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Row(children: [
                        CommodityImage(commodities[shown[k]],
                            size: 34, radius: 7),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              UiText(commodities[shown[k]].fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              if (_asal(commodities[shown[k]]) case final sub?)
                                sub,
                            ])),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UiText(
                                  '${rp(MarketService.current(commodities[shown[k]]))}/kg',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              ChangeText(MarketService.changePct(
                                  commodities[shown[k]])),
                            ]),
                      ]),
                    ),
                  ),
                ],
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: UiText('Komoditas tidak ditemukan.',
                        style: TextStyle(color: AppColors.muted)),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            Panel(
              color: AppColors.mint,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                          child: UiText(_catatanSumber(),
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.green))),
                    ]),
                    if (!MarketService.adaLive) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: UiText(
                            tpl('Sebab harga Supabase belum terpakai: {0}',
                                [MarketService.liveError ?? 'belum dicoba']),
                            style: TextStyle(
                                fontSize: 12, color: AppColors.green.o(0.75))),
                      ),
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.green,
                            side: BorderSide(color: AppColors.green)),
                        onPressed: () => _editOwnPrices(context, c),
                        icon: const Icon(Icons.edit_note_rounded, size: 20),
                        label: UiText(MarketService.isManual(c)
                            ? tpl('Ubah harga catatan — {0} sudah diisi',
                                [tr(c.name)])
                            : 'Atur harga sendiri'),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editOwnPrices(BuildContext context, Commodity c) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PriceSheet(initial: c.id),
    );
    if (mounted) setState(() {});
  }

  List<Widget> _price(Commodity c) {
    final points = MarketService.historyPoints(c, _days[_range]);
    final data = [for (final p in points) p.harga];
    return [
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiText(tpl('Harga {0} (Rp/kg)', [tr(c.fullName)]),
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(children: [
            for (var i = 0; i < _ranges.length; i++)
              GestureDetector(
                onTap: () => setState(() => _range = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _range == i ? AppColors.mint : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: UiText(_ranges[i],
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color:
                              _range == i ? AppColors.green : AppColors.muted)),
                ),
              ),
          ]),
          const SizedBox(height: 14),
          PriceChart(data: data, dates: [for (final p in points) p.waktu]),
          if (data.isNotEmpty) ...[
            const SizedBox(height: 8),
            KeyValue(
                'Terendah', '${rp(data.reduce((a, b) => a < b ? a : b))}/kg'),
            KeyValue(
                'Tertinggi', '${rp(data.reduce((a, b) => a > b ? a : b))}/kg'),
          ],
        ]),
      ),
    ];
  }
}

/// Catat harga jual pengguna sendiri, menggantikan angka simulasi.
class _PriceSheet extends StatefulWidget {
  final String initial;
  const _PriceSheet({required this.initial});

  @override
  State<_PriceSheet> createState() => _PriceSheetState();
}

class _PriceSheetState extends State<_PriceSheet> {
  late String _id = widget.initial;
  late final TextEditingController _ctrl = TextEditingController(
      text: MarketService.manual[_id] == null
          ? ''
          : thousands(MarketService.manual[_id]!.round()));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _pick(String id) {
    setState(() {
      _id = id;
      final v = MarketService.manual[id];
      _ctrl.text = v == null ? '' : thousands(v.round());
    });
  }

  Future<void> _save() async {
    final v = parseInt(_ctrl.text).toDouble();
    if (v <= 0) {
      setState(() {});
      return;
    }
    await AppScope.of(context).setManualPrice(_id, v);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = commodityById(_id);
    final own = MarketService.manual[_id];
    final set = MarketService.manual.keys.toList();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UiText('Harga catatan sendiri',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            UiText(
                'Pakai harga yang Anda terima di lapangan. '
                'Rekomendasi, simulasi, dan buku kas ikut memakai angka ini.',
                style: TextStyle(
                    fontSize: 13, color: AppColors.muted, height: 1.4)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _id,
              decoration: InputDecoration(labelText: tr('Komoditas')),
              items: [
                for (final x in commodities)
                  DropdownMenuItem(value: x.id, child: UiText(x.fullName))
              ],
              onChanged: (v) => v == null ? null : _pick(v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsFormatter()],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: tr('Harga per kg (Rp)'),
                hintText: tr('mis. 12000'),
                helperText: tpl('Simulasi hari ini: {0}/kg',
                    [rp(MarketService.simulatedNow(c))]),
                helperMaxLines: 1,
                suffixText: '/kg',
              ),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: _save, child: const UiText('Simpan harga')),
              ),
              if (own != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.down,
                        side: BorderSide(color: AppColors.down)),
                    onPressed: () async {
                      await AppScope.of(context).setManualPrice(_id, null);
                      if (mounted) setState(() {});
                    },
                    child: const UiText('Hapus'),
                  ),
                ),
              ],
            ]),
            if (set.isNotEmpty) ...[
              const SizedBox(height: 16),
              UiText('Sudah dicatat',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.muted)),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 170),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final id in set)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: UiText(commodityById(id).fullName,
                            style: const TextStyle(fontSize: 14)),
                        subtitle: UiText(
                            id == _id
                                ? tpl('{0}/kg • sedang dipilih',
                                    [rp(MarketService.manual[id]!)])
                                : '${rp(MarketService.manual[id]!)}/kg',
                            style: const TextStyle(fontSize: 13)),
                        trailing: IconButton(
                          icon: Icon(Icons.undo_rounded,
                              size: 18, color: AppColors.muted),
                          onPressed: () async {
                            await AppScope.of(context).setManualPrice(id, null);
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ]),
    );
  }
}
