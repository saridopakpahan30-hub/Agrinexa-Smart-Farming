import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../services/market_service.dart';
import '../services/recommendation.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/plot_map.dart';
import '../widgets/price_chart.dart';

class SimulationScreen extends StatefulWidget {
  final String? initialId;
  const SimulationScreen({super.key, this.initialId});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

/// Satu baris rencana tanam: tanaman beserta kolom luasannya sendiri.
class _Baris {
  final String id;
  final TextEditingController luas = TextEditingController();

  _Baris(this.id, String luasAwal) {
    luas.text = luasAwal;
  }

  Commodity get c => commodityById(id);
  double get area => parseInt(luas.text).toDouble();

  void dispose() => luas.dispose();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final _cap = TextEditingController();
  final _area = TextEditingController();
  final List<_Baris> _rencana = [];
  double _pf = 0; // skenario harga dalam persen
  double _maxShare = 0.35; // batas porsi satu tanaman pada optimasi
  bool _auto = false; // true = kombinasi terbaik, LP yang membagi lahan
  bool _init = false;
  String? _error;
  String? _lpPesan;
  PlanResult? _hasil;
  Saran? _saran;
  List<Reco> _semua = [];

  static const _barColors = [
    Color(0xFF1B7F3B),
    Color(0xFFFFB300),
    Color(0xFF3B82F6),
    Color(0xFF8E44AD),
    Color(0xFFE5533D),
  ];
  static const _warnaPembanding = Color(0xFFB9C6BC);

  /// Luas lahan untuk simulasi ini. Diisi dari data lahan pada Input Lahan
  /// tetapi tidak menimpanya — pengguna boleh menguji ukuran lain di sini.
  int get _lahan => parseInt(_area.text);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final s = AppScope.of(context);
    final luas = s.landArea < 1 ? 1000 : s.landArea;
    _cap.text = thousands(s.capital);
    _area.text = thousands(luas);
    _rencana.add(_Baris(widget.initialId ?? s.active.id, thousands(luas)));
    _sinkronSaran();
  }

  @override
  void dispose() {
    _cap.dispose();
    _area.dispose();
    for (final b in _rencana) {
      b.dispose();
    }
    super.dispose();
  }

  int get _totalLuas => _rencana.fold<int>(0, (t, b) => t + b.area.round());

  bool _terpilih(String id) => _rencana.any((b) => b.id == id);

  /// Ketuk tanaman untuk memasukkannya ke dalam atau mengeluarkannya dari
  /// rencana. Baris baru memperoleh sisa lahan yang belum terpakai, sehingga
  /// menambah tanaman tidak perlu menebak angka luas. Pada mode kombinasi
  /// terbaik, daftar inilah yang menjadi kandidat optimasi; kolom luasnya
  /// tidak digunakan karena program linear yang membagi lahan.
  void _toggle(String id) {
    if (_terpilih(id)) {
      if (_rencana.length == 1) {
        setState(() => _error = 'Pilih minimal satu tanaman.');
        return;
      }
      final b = _rencana.firstWhere((e) => e.id == id);
      setState(() {
        _error = null;
        _rencana.remove(b);
        b.dispose();
        _sinkronSaran();
      });
      return;
    }
    final sisa = _lahan - _totalLuas;
    setState(() {
      _error = null;
      _rencana.add(_Baris(id, thousands(sisa >= 1 ? sisa : 100)));
      _sinkronSaran();
    });
  }

  /// Mode kombinasi terbaik: pemilihan tanaman diserahkan kepada aplikasi agar
  /// batas diversifikasi memiliki cukup banyak tanaman untuk dibagi.
  void _pilihSemua() {
    final rata = (_lahan / commodities.length).round().clamp(1, _lahan);
    for (final b in _rencana) {
      b.dispose();
    }
    setState(() {
      _rencana
        ..clear()
        ..addAll([for (final c in commodities) _Baris(c.id, thousands(rata))]);
      _hasil = null;
      _error = null;
      _sinkronSaran();
    });
  }

  Future<void> _run() async {
    // Dijalankan dari tombol "Selesai" pada papan ketik: tutup papan ketik
    // lebih dulu agar hasil simulasi tidak tertutup.
    FocusScope.of(context).unfocus();
    final cap = parseInt(_cap.text);
    if (cap < 100000) {
      setState(() => _error = 'Isi modal (min Rp 100.000).');
      return;
    }
    if (_lahan < 1) {
      setState(() => _error = 'Isi luas lahan minimal 1 m².');
      return;
    }
    final s = AppScope.of(context);
    final pf = 1 + _pf / 100;
    final PlanResult res;
    if (_auto) {
      final sa = _saran;
      if (sa == null) {
        setState(
            () => _error = _lpPesan ?? 'Kombinasi terbaik belum tersedia.');
        return;
      }
      // Rencana pengguna memang hasil optimasi, sehingga tidak dihitung ulang.
      res = sa.hasil;
    } else {
      final dihitung = Engine.mix(
        [for (final b in _rencana) PlanLine(b.id, b.area)],
        capital: cap,
        landType: s.landType,
        goal: s.goal,
        priceFactor: pf,
        landArea: _lahan,
      );
      if (dihitung.kosong) {
        setState(() => _error = 'Isi luas tiap tanaman minimal 1 m².');
        return;
      }
      res = dihitung;
    }
    final luasRencana = res.requestedArea.round();
    setState(() {
      _error = null;
      _hasil = res;
      _semua = [
        for (final c in commodities)
          Engine.evaluate(c,
              area: luasRencana,
              capital: cap,
              landType: s.landType,
              goal: s.goal,
              priceFactor: pf)
      ];
    });
    // Satu catatan per tanaman agar Riwayat jujur mengenai apa yang dihitung.
    for (final r in res.items) {
      await s.addRecord(SimRecord(
        commodityId: r.c.id,
        date: DateTime.now().toIso8601String(),
        area: r.effArea,
        capital: cap,
        omzet: r.omzet,
        cost: r.cost,
        margin: r.margin,
        roi: r.roi,
        priceFactor: pf,
      ));
    }
  }

  List<PlotZone> get _zonaRencana => [
        for (final b in _rencana)
          PlotZone(
              name: b.c.name,
              area: b.area,
              color: AppColors.aksen(b.c.color),
              emoji: b.c.emoji),
      ];

  List<PlotZone> _zona(PlanResult p) => [
        for (final r in p.items)
          PlotZone(
              name: r.c.name,
              area: r.effArea,
              color: AppColors.aksen(r.c.color),
              emoji: r.c.emoji),
        if (_lahan > p.usedArea + 0.5)
          PlotZone(
              name: 'Lahan tidak terpakai',
              area: _lahan - p.usedArea,
              color: AppColors.card),
      ];

  /// Hitung ulang saran program linear dari lahan, modal, harga, dan batas
  /// diversifikasi yang berlaku saat ini. Tidak memanggil setState: pemanggilnya
  /// yang memutuskan, sehingga fungsi ini aman digunakan pada build pertama.
  ///
  /// Dijalankan setiap kali salah satu masukan berubah karena simplex pada layar
  /// ini hanya memakan beberapa milidetik, sehingga peta boleh ikut bergeser.
  void _sinkronSaran() {
    _hasil = null;
    final s = AppScope.of(context);
    final cap = parseInt(_cap.text);
    if (cap < 100000) {
      _saran = null;
      _lpPesan = 'Isi modal (min Rp 100.000) lebih dulu.';
      return;
    }
    if (_lahan < 1) {
      _saran = null;
      _lpPesan = 'Isi luas lahan minimal 1 m².';
      return;
    }
    final sa = Engine.optimize(
        landArea: _lahan,
        capital: cap,
        landType: s.landType,
        goal: s.goal,
        priceFactor: 1 + _pf / 100,
        maxShare: _maxShare,
        hanya: _auto ? [for (final b in _rencana) b.id] : null);
    _lpPesan = sa.hasil.kosong
        ? tpl('Belum ada kombinasi: {0}.', [tr(sa.pembatas)])
        : null;
    _saran = sa.hasil.kosong ? null : sa;
  }

  /// Salin hasil optimasi ke rencana tanam agar dapat disimulasikan dan
  /// disimpan ke riwayat.
  void _pakaiSaran() {
    final sa = _saran;
    if (sa == null) return;
    for (final b in _rencana) {
      b.dispose();
    }
    setState(() {
      _rencana
        ..clear()
        ..addAll([
          for (final r in sa.hasil.items)
            _Baris(r.c.id, thousands(r.effArea.round()))
        ]);
      _hasil = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lebihLahan = _totalLuas > _lahan;
    // Porsi yang benar-benar digunakan optimasi. Dapat lebih lebar dari nilai
    // penggeser apabila mode kombinasi terbaik hanya memilih satu atau dua
    // tanaman.
    final efektif = _saran?.maxShare ?? _maxShare;
    final melebar = efektif > _maxShare + 1e-9;
    return Scaffold(
      // Judul dipindahkan ke dalam banner foto; tombol kembali tetap otomatis.
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StaggerIn(
            index: 0,
            child: PhotoBanner(
              asset: commodityById('tebu').asset,
              height: 152,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UiText('Simulasi Usaha Tani',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 10)
                          ])),
                  SizedBox(height: 4),
                  UiText('Beberapa tanaman dalam satu simulasi',
                      maxLines: 2,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Parameter'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: NumField(
                            label: 'Luas Lahan',
                            controller: _area,
                            suffix: 'm²',
                            onChanged: (_) => setState(_sinkronSaran))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: NumField(
                            label: 'Modal Tersedia',
                            controller: _cap,
                            onChanged: (_) => setState(_sinkronSaran))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: UiText('Berlaku hanya untuk simulasi ini.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ),
              ],
            ),
          ),
          StaggerIn(
            index: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('Rencana Tanam',
                    trailing: UiText(
                        _auto
                            ? tpl('{0} dipilih', ['${_rencana.length}'])
                            : tpl('{0} tanaman', ['${_rencana.length}']),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800))),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                        value: false,
                        label: UiText('Rencana sendiri',
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ButtonSegment(
                        value: true,
                        label: UiText('Kombinasi terbaik',
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                  selected: {_auto},
                  showSelectedIcon: false,
                  onSelectionChanged: (v) => setState(() {
                    _auto = v.first;
                    // Hasil yang tampil di layar berasal dari rencana mode
                    // sebelumnya.
                    _hasil = null;
                    _sinkronSaran();
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: UiText(
                      _auto
                          ? 'Aplikasi yang membagi luas untuk margin terbesar.'
                          : 'Anda atur sendiri. Saran tampil di bawah.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ),
                _chips(),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: UiText(
                      _auto
                          ? 'Ketuk tanaman yang boleh ditanam.'
                          : 'Ketuk untuk menambah atau mengeluarkan.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ),
                if (_auto) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _pilihSemua,
                      icon: const Icon(Icons.playlist_add_check_rounded,
                          size: 18),
                      label: const UiText('Pilih semua'),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4)),
                    ),
                  ),
                  if (_rencana.length == 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: UiText(
                          'Pilih lebih banyak tanaman agar lahan terbagi.',
                          style:
                              TextStyle(fontSize: 13, color: AppColors.muted)),
                    ),
                ] else ...[
                  const SizedBox(height: 12),
                  for (var i = 0; i < _rencana.length; i++)
                    _baris(_rencana[i], terakhir: i == _rencana.length - 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: UiText(
                      tpl('Total direncanakan {0} m²', [thousands(_totalLuas)]),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: lebihLahan ? AppColors.down : AppColors.text),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Peta ikut berubah saat luas diketik: luas tiap warna
                  // sebanding dengan luas tanaman yang diwakilinya.
                  PlotMap(zones: _zonaRencana, height: 178),
                  const SizedBox(height: 10),
                  PlotLegend(zones: _zonaRencana),
                ],
              ],
            ),
          ),
          StaggerIn(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                    _auto
                        ? 'Kombinasi Terbaik — rencana Anda'
                        : 'Kombinasi Terbaik — saran'),
                Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UiText(
                          _auto
                              ? 'Luas dibagi otomatis untuk margin terbesar.'
                              : 'Campuran tanaman dengan margin terbesar untuk '
                                  'lahan dan modal Anda.',
                          style:
                              TextStyle(fontSize: 14, color: AppColors.muted)),
                      const SizedBox(height: 12),
                      Row(children: [
                        const Expanded(
                            child: UiText('Satu tanaman maksimal',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14))),
                        UiText(
                            tpl('{0}% lahan', ['${(efektif * 100).round()}']),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w800)),
                      ]),
                      Slider(
                        value: _maxShare,
                        min: 0.15,
                        max: 0.7,
                        divisions: 11,
                        label: '${(_maxShare * 100).round()}%',
                        // Saran dihitung ulang ketika jari masih berada pada
                        // penggeser, sehingga kotak lahan benar-benar ikut
                        // bergeser.
                        onChanged: (v) => setState(() {
                          _maxShare = v;
                          _sinkronSaran();
                        }),
                      ),
                      if (melebar)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: UiText(
                              tpl('Melebar jadi {0}% agar lahan terpakai penuh.',
                                  ['${(efektif * 100).round()}']),
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.muted)),
                        ),
                      if (_lpPesan != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: UiText(_lpPesan!,
                              style: TextStyle(
                                  color: AppColors.down, fontSize: 14)),
                        ),
                    ],
                  ),
                ),
                if (_saran != null) ..._saranPanel(_saran!),
              ],
            ),
          ),
          StaggerIn(
            index: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle('Skenario Harga'),
                Panel(
                  child: Column(children: [
                    Row(children: [
                      const Expanded(
                          child: UiText('Perubahan harga jual',
                              style: TextStyle(fontSize: 14))),
                      UiText(pct(_pf, sign: true),
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color:
                                  _pf >= 0 ? AppColors.green : AppColors.down)),
                    ]),
                    Slider(
                      value: _pf,
                      min: -30,
                      max: 30,
                      divisions: 60,
                      onChanged: (v) => setState(() {
                        _pf = v;
                        _sinkronSaran();
                      }),
                    ),
                  ]),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: UiText(_error!,
                        style: TextStyle(color: AppColors.down, fontSize: 14)),
                  ),
                const SizedBox(height: 14),
                ElevatedButton(
                    onPressed: _run, child: const UiText('Jalankan Simulasi')),
              ],
            ),
          ),
          if (_hasil != null)
            StaggerIn(
              index: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _results(_hasil!),
              ),
            ),
        ],
      ),
    );
  }

  /// Deretan pilihan tanaman. Digunakan oleh kedua mode: pada mode rencana
  /// sendiri setiap pilihan menambah baris luas, sedangkan pada mode kombinasi
  /// terbaik pilihan hanya menentukan tanaman yang boleh dipilih program
  /// linear.
  Widget _chips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (final c in commodities)
          SizedBox(
            key: ValueKey('chip:${c.id}'),
            width: 84,
            child: GestureDetector(
              onTap: () => _toggle(c.id),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _terpilih(c.id) ? AppColors.mint : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _terpilih(c.id) ? AppColors.green : AppColors.line,
                      width: _terpilih(c.id) ? 1.6 : 1),
                ),
                child: Column(children: [
                  CommodityImage(c, size: 40, radius: 10),
                  const SizedBox(height: 4),
                  UiText(c.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _terpilih(c.id)
                              ? AppColors.green
                              : AppColors.text)),
                ]),
              ),
            ),
          ),
      ]),
    );
  }

  /// Satu baris rencana: tanaman, biaya per m², kolom luas, dan tombol keluar.
  /// Baris terakhir menutup papan ketik lalu menjalankan simulasi; baris lainnya
  /// berpindah ke kolom berikutnya agar mengisi secara bertingkat tidak perlu
  /// mengetuk.
  Widget _baris(_Baris b, {bool terakhir = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        CommodityImage(b.c, size: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiText(b.c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800)),
              UiText(tpl('Biaya {0}/m²', [rp(b.c.costPerM2)]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 96,
          child: TextField(
            controller: b.luas,
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsFormatter()],
            style: const TextStyle(fontSize: 14),
            textInputAction:
                terakhir ? TextInputAction.done : TextInputAction.next,
            onSubmitted: (_) =>
                terakhir ? _run() : FocusScope.of(context).nextFocus(),
            onChanged: (_) => setState(() => _hasil = null),
            decoration: const InputDecoration(
              suffixText: 'm²',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
          ),
        ),
        _rencana.length > 1
            ? IconButton(
                onPressed: () => _toggle(b.id),
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.muted,
                constraints: const BoxConstraints.tightFor(width: 34),
                padding: EdgeInsets.zero,
              )
            : const SizedBox(width: 34),
      ]),
    );
  }

  List<Widget> _ringkasan(PlanResult res) {
    final s = AppScope.of(context);
    final cap = parseInt(_cap.text);
    final sources = <String>{
      for (final r in res.items)
        MarketService.isManual(r.c)
            ? tr('harga catatan Anda')
            : MarketService.liveAsal[r.c.id]?.sumber ?? tr('masih simulasi'),
    };
    final spare = (_lahan - res.usedArea).clamp(0.0, _lahan.toDouble());
    return [
      KeyValue('Strategi',
          tr(s.goal == 'Kestabilan' ? 'Kestabilan' : 'Profit Maksimal')),
      KeyValue('Perkiraan omzet setahun', rp(res.omzetSetahun), maxLines: null),
      KeyValue('Biaya produksi setahun', rp(res.biayaSetahun), maxLines: null),
      KeyValue('Margin kotor per siklus', rp(res.margin), maxLines: null),
      KeyValue('Luas tersedia', '${thousands(_lahan)} m²'),
      KeyValue('Luas terpakai', '${thousands(res.usedArea.round())} m²'),
      KeyValue('Pemanfaatan lahan', pct(res.usedArea / _lahan * 100)),
      KeyValue('Sisa lahan', '${thousands(spare.round())} m²'),
      KeyValue('Modal tersedia', rp(cap)),
      KeyValue('Modal per siklus', rp(res.cost), maxLines: null),
      KeyValue(
          'Sisa modal kerja', rp((cap - res.cost).clamp(0.0, cap.toDouble())),
          maxLines: null),
      KeyValue('Sumber harga', sources.join(' · '), maxLines: null),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: UiText(
            'Optimasi per siklus. Estimasi setahun: tanam berulang dengan harga tetap; tanaman tahunan setelah produktif.',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
      ),
    ];
  }

  /// Hasil optimasi: peta lahannya, rinciannya, dan tombol untuk memakainya.
  List<Widget> _saranPanel(Saran sa) {
    final h = sa.hasil;
    final zona = _zona(h);
    return [
      const SizedBox(height: 12),
      Panel(
        color: AppColors.mint,
        border: AppColors.leaf.o(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(
                child: UiText(
                    tpl('{0} tanaman optimal', ['${h.jumlahTanaman}']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              Flexible(
                  child: UiText(rp(h.marginSetahun),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.green))),
            ]),
            UiText('Margin kotor setahun (estimasi)',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: UiText('Margin kotor per siklus',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              Flexible(
                  child: UiText(rp(h.margin),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.green))),
            ]),
            const SizedBox(height: 12),
            PlotMap(zones: zona, height: 178),
            const SizedBox(height: 10),
            PlotLegend(zones: zona),
            const Divider(height: 24),
            ..._ringkasan(h),
            KeyValue('ROI setahun', pct(h.roiSetahun)),
            KeyValue(
                'Porsi terkecil dalam hasil',
                pct(h.items
                    .map((r) => r.effArea / _lahan * 100)
                    .reduce((a, b) => a < b ? a : b)),
                maxLines: null),
            KeyValue(
                'Batas porsi per tanaman', '${(sa.maxShare * 100).round()}%',
                maxLines: null),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: UiText(
                  tpl('Batas yang paling menekan: {0}.', [tr(sa.pembatas)]),
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Panel(
        child: Column(children: [for (final r in h.items) _rincian(r)]),
      ),
      const SizedBox(height: 14),
      if (_auto)
        UiText('Rencana ini yang dihitung tombol Jalankan Simulasi.',
            style: TextStyle(fontSize: 13, color: AppColors.muted))
      else
        ElevatedButton(
            onPressed: _pakaiSaran, child: const UiText('Pakai Rencana Ini')),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: UiText(
            tpl('Harga hari ini. Satu tanaman maksimal {0}% lahan.',
                ['${(sa.maxShare * 100).round()}']),
            style: TextStyle(fontSize: 13, color: AppColors.muted)),
      ),
    ];
  }

  List<Widget> _results(PlanResult res) {
    // Tanaman dalam rencana ditempatkan lebih dulu; sisanya diisi komoditas
    // bermargin tertinggi lain sebagai pembanding.
    final dalamRencana = [...res.items]
      ..sort((a, b) => b.margin.compareTo(a.margin));
    final idRencana = dalamRencana.map((e) => e.c.id).toSet();
    final pembanding = [
      for (final e in [..._semua]..sort((a, b) => b.margin.compareTo(a.margin)))
        if (!idRencana.contains(e.c.id)) e
    ];
    final jumlahRencana = dalamRencana.length.clamp(0, 5);
    final bars = [
      ...dalamRencana.take(5),
      ...pembanding.take((5 - jumlahRencana).clamp(0, 5)),
    ];
    final maxM = bars.fold<double>(1, (m, e) => e.margin > m ? e.margin : m);
    const hide = AxisTitles(sideTitles: SideTitles(showTitles: false));
    Color warnaBar(int i) => i < jumlahRencana
        ? AppColors.aksen(_barColors[i % _barColors.length])
        : _warnaPembanding;
    return [
      const SectionTitle('Hasil Simulasi'),
      Panel(
        color: AppColors.mint,
        border: AppColors.leaf.o(0.5),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiText(
                        tpl('{0} tanaman gabungan', ['${res.jumlahTanaman}']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    UiText('Margin kotor setahun (estimasi)',
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    UiText(rp(res.marginSetahun),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: res.margin >= 0
                                ? AppColors.green
                                : AppColors.down)),
                  ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              UiText('ROI setahun',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
              UiText(pct(res.roiSetahun),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
            ]),
          ]),
          const Divider(height: 22),
          KeyValue('Luas direncanakan',
              '${thousands(res.requestedArea.round())} m²'),
          ..._ringkasan(res),
          if (res.capitalLimited)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: UiText('Modal kurang — luas diperkecil merata.',
                  style: TextStyle(fontSize: 13, color: AppColors.down)),
            ),
          if (res.landOver)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: UiText('Melebihi lahan tercatat. Perbarui ukuran lahan.',
                  style: TextStyle(fontSize: 13, color: AppColors.down)),
            ),
        ]),
      ),
      const SectionTitle('Rincian per Tanaman'),
      Panel(
        child: Column(children: [
          for (final r in dalamRencana) _rincian(r),
        ]),
      ),
      const SectionTitle('Peta Lahan'),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlotMap(zones: _zona(res), height: 210),
            const SizedBox(height: 10),
            PlotLegend(zones: _zona(res)),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: UiText('Luas warna = luas yang terbiayai.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ),
          ],
        ),
      ),
      const SectionTitle('Perbandingan Margin Kotor'),
      Panel(
        child: Column(children: [
          SizedBox(
            height: 170,
            child: BarChart(BarChartData(
              maxY: maxM * 1.15,
              minY: 0,
              alignment: BarChartAlignment.spaceAround,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: priceBarTouch((v) => tpl('Margin {0}', [jt(v)])),
              titlesData: FlTitlesData(
                topTitles: hide,
                rightTitles: hide,
                leftTitles: hide,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (v, m) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: UiText(
                          bars[v.toInt().clamp(0, bars.length - 1).toInt()]
                              .c
                              .emoji,
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < bars.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: bars[i].margin < 0 ? 0 : bars[i].margin,
                      width: 30,
                      color: warnaBar(i),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ]),
              ],
            )),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < bars.length; i++)
                Expanded(
                  child: Column(children: [
                    UiText(jt(bars[i].margin),
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: warnaBar(i))),
                    UiText(bars[i].c.name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  ]),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 14,
              runSpacing: 4,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.square_rounded, size: 12, color: AppColors.green),
                  const SizedBox(width: 6),
                  UiText('Rencana Anda',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.square_rounded,
                      size: 12, color: _warnaPembanding),
                  const SizedBox(width: 6),
                  UiText('Pembanding',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ]),
              ],
            ),
          ),
        ]),
      ),
      const SizedBox(height: 8),
      UiText('Tiap tanaman tercatat otomatis di Riwayat Simulasi.',
          style: TextStyle(fontSize: 13, color: AppColors.muted)),
    ];
  }

  Widget _rincian(Reco r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        CommodityImage(r.c, size: 34, radius: 9),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiText(r.c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              UiText(tpl('{0} m² terhitung', [thousands(r.effArea.round())]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
              UiText(
                  r.c.growDays >= 365
                      ? 'Per tahun setelah produktif'
                      : tpl('{0} hari per siklus', ['${r.c.growDays}']),
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: UiText(rp(r.marginSetahun),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: r.margin >= 0 ? AppColors.green : AppColors.down)),
        ),
      ]),
    );
  }
}
