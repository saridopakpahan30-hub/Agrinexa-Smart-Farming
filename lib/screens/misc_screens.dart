import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../data/image_credits.dart';
import '../models/commodity.dart';
import '../services/market_service.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'login_screen.dart';
import 'market_screen.dart';
import 'simulation_screen.dart';

// ---------------------------------------------------------------- Notifikasi
class AppNotif {
  final IconData icon;
  final Color color;
  final String title, body;
  const AppNotif(this.icon, this.color, this.title, this.body);
}

List<AppNotif> buildNotifications(AppState s) {
  final list = <AppNotif>[];
  if (!s.notifOn) return list;
  if (s.priceAlert) {
    final moves = [for (final c in commodities) (c, MarketService.changePct(c))]
      ..sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));
    for (final m in moves.take(5)) {
      final c = m.$1;
      final ch = m.$2;
      if (ch.abs() >= 1.5) {
        list.add(AppNotif(
          ch >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          ch >= 0 ? AppColors.green : AppColors.down,
          tpl('Harga {0} {1} {2}',
              [tr(c.name), tr(ch >= 0 ? 'naik' : 'turun'), pct(ch.abs())]),
          tpl(
              ch >= 0
                  ? 'Sekarang {0}/kg. Pertimbangkan waktu panen/jual.'
                  : 'Sekarang {0}/kg. Tahan dulu jika memungkinkan.',
              [rp(MarketService.current(c))]),
        ));
      }
    }
  }
  final top = s.top;
  list.add(AppNotif(
    Icons.auto_awesome_rounded,
    AppColors.green,
    tpl('Rekomendasi hari ini: {0}', [tr(top.c.name)]),
    tpl('Proyeksi margin {0} untuk lahan {1} m².',
        [rp(top.margin), thousands(s.landArea)]),
  ));
  if (!s.hasInput) {
    list.add(AppNotif(
      Icons.edit_note_rounded,
      AppColors.sunInk,
      'Lengkapi data usaha tani',
      'Isi luas lahan dan modal agar rekomendasi sesuai kondisi Anda.',
    ));
  }
  return list;
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final items = buildNotifications(s);
    return Scaffold(
      appBar: AppBar(title: const UiText('Notifikasi')),
      body: items.isEmpty
          ? Center(
              child: UiText(
                  'Notifikasi dimatikan atau belum ada pemberitahuan.',
                  style: TextStyle(color: AppColors.muted)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final n = items[i];
                return Panel(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              color: n.color.o(0.12), shape: BoxShape.circle),
                          child: Icon(n.icon, color: n.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UiText(n.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(height: 3),
                                UiText(n.body,
                                    style: TextStyle(
                                        color: AppColors.muted, fontSize: 14)),
                              ]),
                        ),
                      ]),
                );
              },
            ),
    );
  }
}

// ------------------------------------------------------------------- Riwayat
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const UiText('Riwayat Simulasi'),
        actions: [
          if (s.history.isNotEmpty)
            IconButton(
              tooltip: tr('Hapus semua'),
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const UiText('Hapus semua riwayat?'),
                    content:
                        const UiText('Tindakan ini tidak bisa dibatalkan.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const UiText('Batal')),
                      TextButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const UiText('Hapus')),
                    ],
                  ),
                );
                if (ok == true) s.clearHistory();
              },
            ),
        ],
      ),
      body: s.history.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: EmptyState(
                icon: Icons.calculate_rounded,
                title: 'Belum ada simulasi',
                body: 'Jalankan simulasi untuk melihat riwayat.',
                actionLabel: 'Jalankan Simulasi',
                onAction: () => push(context, const SimulationScreen()),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: s.history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = s.history[i];
                final c = commodityById(r.commodityId);
                final d = DateTime.tryParse(r.date) ?? DateTime.now();
                return Panel(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: UiText(tpl('Simulasi {0}', [tr(c.name)])),
                      content: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          KeyValue('Tanggal', tanggalPanjang(d)),
                          KeyValue(
                              'Luas lahan', '${thousands(r.area.round())} m²'),
                          KeyValue('Modal', rp(r.capital)),
                          KeyValue('Skenario harga',
                              pct((r.priceFactor - 1) * 100, sign: true)),
                          KeyValue('Omzet', rp(r.omzet)),
                          KeyValue('Biaya', rp(r.cost)),
                          KeyValue('Margin', rp(r.margin), bold: true),
                          KeyValue('ROI', pct(r.roi)),
                        ]),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const UiText('Tutup'))
                      ],
                    ),
                  ),
                  child: Row(children: [
                    CommodityImage(c, size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiText(c.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                            UiText(tanggalPanjang(d),
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.muted)),
                          ]),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          UiText(rp(r.margin),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: r.margin >= 0
                                      ? AppColors.green
                                      : AppColors.down)),
                          UiText('ROI ${pct(r.roi)}',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.muted)),
                        ]),
                  ]),
                );
              },
            ),
    );
  }
}

// ------------------------------------------------------------------ Pengaturan
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const UiText('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.sell_outlined),
                title: const UiText('Harga catatan sendiri'),
                subtitle: UiText(
                    MarketService.manualCount() == 0
                        ? 'Belum ada — semua harga masih simulasi'
                        : tpl('{0} komoditas memakai harga Anda',
                            [MarketService.manualCount().toString()]),
                    style: const TextStyle(fontSize: 13)),
                trailing:
                    Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                onTap: () => push(context, const MarketScreen()),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: [
              SwitchListTile(
                value: s.notifOn,
                onChanged: (v) => s.setNotif(on: v),
                title: const UiText('Notifikasi'),
              ),
              SwitchListTile(
                value: s.priceAlert,
                onChanged: s.notifOn ? (v) => s.setNotif(price: v) : null,
                title: const UiText('Peringatan harga'),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: UiText('Tampilan layar',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
          ),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: [
              for (final m in AppState.themeModes)
                _TampilanTile(
                    mode: m, aktif: s.themeMode, onPick: s.setThemeMode),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: UiText('Bahasa aplikasi',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
          ),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: [
              for (final b in AppState.bahasaYangDidukung)
                _BahasaTile(bahasa: b, aktif: s.bahasa, onPick: s.setBahasa),
            ]),
          ),
          const SizedBox(height: 16),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.history_toggle_off_rounded),
                title: const UiText('Hapus riwayat simulasi'),
                onTap: () {
                  s.clearHistory();
                  toast(context, 'Riwayat simulasi dihapus.');
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt_rounded),
                title: const UiText('Reset data usaha tani'),
                onTap: () {
                  s.resetFarm();
                  toast(context, 'Data usaha tani dikembalikan ke awal.');
                },
              ),
            ]),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => logoutAndExit(context),
            icon: const Icon(Icons.logout_rounded),
            label: const UiText('Keluar'),
          ),
        ],
      ),
    );
  }
}

/// Satu baris pilihan mode tampilan. Ditulis sebagai kartu penuh yang dapat
/// diketuk (tinggi 64 ke atas) karena pilihan kecil seperti radio sulit dijangkau
/// jari pengguna.
class _TampilanTile extends StatelessWidget {
  final String mode, aktif;
  final Future<void> Function(String) onPick;
  const _TampilanTile(
      {required this.mode, required this.aktif, required this.onPick});

  static const _isi = {
    'system': (
      Icons.brightness_auto_rounded,
      'Ikut setelan HP',
      'Terang atau gelap sama seperti pengaturan di HP Anda'
    ),
    'light': (
      Icons.wb_sunny_rounded,
      'Terang',
      'Paling jelas dibaca di bawah matahari, saat di ladang'
    ),
    'dark': (
      Icons.nightlight_round,
      'Gelap',
      'Tidak menyilaukan di malam hari, huruf tetap besar dan tebal'
    ),
  };

  @override
  Widget build(BuildContext context) {
    final isi = _isi[mode]!;
    final on = mode == aktif;
    return ListTile(
      selected: on,
      selectedTileColor: AppColors.mint,
      minVerticalPadding: 12,
      onTap: () => onPick(mode),
      leading:
          Icon(isi.$1, color: on ? AppColors.green : AppColors.muted, size: 26),
      title: UiText(isi.$2,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text)),
      trailing: on
          ? Icon(Icons.check_circle_rounded, color: AppColors.green, size: 26)
          : Icon(Icons.circle_outlined, color: AppColors.line, size: 26),
    );
  }
}

/// Satu baris pilihan bahasa. Nama bahasa tidak diberi padanan Inggris di tabel:
/// kuncinya dibiarkan kosong sehingga 'Bahasa Indonesia' tetap tampil sama pada
/// kedua mode, sedangkan 'Bahasa Inggris' memiliki kunci sendiri.
class _BahasaTile extends StatelessWidget {
  final String bahasa, aktif;
  final Future<void> Function(String) onPick;
  const _BahasaTile(
      {required this.bahasa, required this.aktif, required this.onPick});

  static const _isi = {
    'sistem': (
      Icons.smartphone_rounded,
      'Ikut bahasa HP',
      'Sama seperti pengaturan bahasa di HP Anda'
    ),
    'id': (
      Icons.language_rounded,
      'Bahasa Indonesia',
      'Bahasanya aplikasi ini dibuat, istilah pertanian memakai kata sehari-hari'
    ),
    'en': (
      Icons.public_rounded,
      'Bahasa Inggris',
      'Untuk presentasi dan penilai yang tidak membaca bahasa Indonesia'
    ),
  };

  @override
  Widget build(BuildContext context) {
    final isi = _isi[bahasa]!;
    final on = bahasa == aktif;
    return ListTile(
      selected: on,
      selectedTileColor: AppColors.mint,
      minVerticalPadding: 12,
      onTap: () => onPick(bahasa),
      leading:
          Icon(isi.$1, color: on ? AppColors.green : AppColors.muted, size: 26),
      title: UiText(isi.$2,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text)),
      trailing: on
          ? Icon(Icons.check_circle_rounded, color: AppColors.green, size: 26)
          : Icon(Icons.circle_outlined, color: AppColors.line, size: 26),
    );
  }
}

Future<void> logoutAndExit(BuildContext context) async {
  final s = AppScope.of(context);
  final nav = Navigator.of(context);
  await s.logout();
  nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
}

// ------------------------------------------------------------------------ FAQ
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faq = [
    (
      'Bagaimana rekomendasi komoditas dihitung?',
      'Aplikasi membandingkan tiap komoditas berdasarkan luas lahan, modal, jenis lahan, dan harga pasar terkini. Luas yang dihitung dibatasi modal Anda. Tujuan "Keuntungan" mengurutkan menurut margin, sedangkan "Kestabilan" menurunkan nilai komoditas yang harganya fluktuatif.'
    ),
    (
      'Apa arti ROI?',
      'ROI di sini adalah margin kotor dibagi biaya variabel, dalam persen. Semakin tinggi, semakin besar hasil per rupiah modal.'
    ),
    (
      'Dari mana data harga berasal?',
      'Dua sumber. Harga yang Anda catat sendiri (Pasar > Atur harga sendiri) selalu dipakai bila ada. Sisanya angka simulasi lokal — versi produksi perlu disambungkan ke panel harga resmi (PIHPS / Badan Pangan).'
    ),
    (
      'Dari mana data cuaca berasal?',
      'Prakiraan diambil dari Open-Meteo untuk lokasi kebun Anda (gratis, tanpa akun). Bila tidak ada jaringan, aplikasi memakai cache terakhir atau simulasi pola musim, dan labelnya berubah menjadi "belum terhubung".'
    ),
    (
      'Apakah hasil simulasi pasti terjadi?',
      'Tidak. Hasil adalah proyeksi berdasarkan asumsi rata-rata hasil panen dan biaya. Cuaca, hama, dan harga di lapangan bisa berbeda.'
    ),
    (
      'Bagaimana mengubah data lahan dan modal?',
      'Buka Beranda lalu ketuk kartu Ringkasan, atau lewat Profil > Data Usaha Tani.'
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const UiText('Bantuan & FAQ')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final f in _faq)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Panel(
                  padding: EdgeInsets.zero,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: UiText(f.$1,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiText(f.$2,
                            style: TextStyle(
                                color: AppColors.muted, height: 1.45)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}

// --------------------------------------------------------------------- Tentang
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const UiText('Tentang Aplikasi')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AssetImg(Assets.logo,
                  width: 84,
                  height: 84,
                  fit: BoxFit.contain,
                  fallback: Icon(Icons.eco_rounded,
                      size: 80, color: AppColors.green)),
              const SizedBox(height: 12),
              UiText('Agrinexa',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green)),
              UiText('Data hari ini, panen esok',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 18),
              const UiText(
                'Agrinexa membantu petani memilih komoditas, memantau harga pasar, dan mensimulasikan keuntungan usaha tani.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.45),
              ),
              const SizedBox(height: 18),
              UiText('Versi 1.0.0',
                  style: TextStyle(color: AppColors.muted, fontSize: 13)),
            ]),
          ),
        ),
      );
}

// ------------------------------------------------------- Sumber Gambar (CC)
class ImageCreditsScreen extends StatelessWidget {
  const ImageCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const UiText('Sumber gambar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const UiText(
            'Foto tanaman di aplikasi ini adalah foto asli, bukan gambar buatan. '
            'Sebagian besar adalah dokumentasi pribadi yang dibagikan ke Agrinexa, '
            'sebagian lain dari Pexels, dengan menyebut sumbernya di bawah ini.',
            style: TextStyle(height: 1.45),
          ),
          const SizedBox(height: 14),
          for (final k in imageCredits)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Panel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: UiText(k.crop,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text)),
                        ),
                        const SizedBox(width: 8),
                        UiText(k.license,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.muted)),
                      ]),
                      const SizedBox(height: 4),
                      UiText(tpl('Foto: {0}', [tr(k.artist)]),
                          style: TextStyle(
                              fontSize: 13, color: AppColors.muted)),
                      SelectableText(tr(k.page),
                          style: const TextStyle(fontSize: 11, height: 1.4)),
                    ]),
              ),
            ),
        ],
      ),
    );
  }
}
