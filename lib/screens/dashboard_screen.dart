import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../services/field_tasks.dart';
import '../services/market_service.dart';
import '../state/app_state.dart';
import '../widgets/agri_scene.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common.dart';
import '../widgets/price_chart.dart';
import 'detail_screen.dart';
import 'calendar_screen.dart';
import 'field_mode_screen.dart';
import 'guide_list_screen.dart';
import 'input_screen.dart';
import 'ledger_screen.dart';
import 'market_screen.dart';
import 'misc_screens.dart';
import 'pest_screen.dart';
import 'profile_screen.dart';
import 'recommendation_screen.dart';
import 'simulation_screen.dart';
import 'fertilizer_screen.dart';
import 'weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _key = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _go(int i) => setState(() => _selectedIndex = i);
  void _menu() => _key.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: AppDrawer(
        selected: _selectedIndex,
        onTab: _go,
        onHistory: () => push(context, const HistoryScreen()),
        onSettings: () => push(context, const SettingsScreen()),
        onGuide: () => push(context, const GuideListScreen()),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardTab(onMenu: _menu, onGoTab: _go),
          RecommendationScreen(embedded: true, onMenu: _menu),
          MarketScreen(embedded: true, onMenu: _menu),
          ProfileScreen(onMenu: _menu),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _go,
        labelTextStyle: MaterialStatePropertyAll(
            TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.green),
              label: tr('Beranda')),
          NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon:
                  Icon(Icons.auto_awesome_rounded, color: AppColors.green),
              label: tr('Rekomendasi')),
          NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon:
                  Icon(Icons.storefront_rounded, color: AppColors.green),
              label: tr('Pasar')),
          NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.green),
              label: tr('Profil')),
        ],
      ),
    );
  }
}

// =============================================================== BERANDA
class DashboardTab extends StatelessWidget {
  final VoidCallback onMenu;
  final ValueChanged<int> onGoTab;
  const DashboardTab({super.key, required this.onMenu, required this.onGoTab});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final top = s.top;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DashboardHeader(onMenu: onMenu, onGoTab: onGoTab),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldModeCard(state: s),
                const SizedBox(height: 14),
                if (!s.hasInput) ...[
                  Panel(
                    color: AppColors.sunTint,
                    border: AppColors.sunTintLine,
                    onTap: () => push(context, const InputScreen()),
                    child: Row(children: [
                      Icon(Icons.edit_note_rounded, color: AppColors.sunInk),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: UiText(
                            'Data masih bawaan. Ketuk untuk mengisi luas lahan & modal Anda.',
                            style: TextStyle(fontSize: 14)),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ]),
                  ),
                ],
                const SectionTitle('Menu Cepat'),
                Row(children: [
                  _Quick(
                      Icons.grid_view_rounded,
                      'Input Lahan',
                      () => push(context, const InputScreen()),
                      const Color(0xFF8D6E63)),
                  _Quick(
                      Icons.calculate_rounded,
                      'Simulasi',
                      () => push(context, const SimulationScreen()),
                      const Color(0xFF1565C0)),
                  _Quick(
                      Icons.eco_rounded,
                      'Pupuk',
                      () => push(context, const FertilizerScreen()),
                      const Color(0xFF2E7D32)),
                  _Quick(
                      Icons.notifications_rounded,
                      'Notifikasi',
                      () => push(context, const NotificationScreen()),
                      const Color(0xFFB88A00)),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  _Quick(
                      Icons.account_balance_wallet_rounded,
                      'Buku Kas',
                      () => push(context, const LedgerScreen()),
                      const Color(0xFF00796B)),
                  _Quick(
                      Icons.event_note_rounded,
                      'Kalender Tanam',
                      () => push(context, const CalendarScreen()),
                      const Color(0xFF3949AB)),
                  _Quick(
                      Icons.bug_report_rounded,
                      'Hama & Penyakit',
                      () => push(context, const PestScreen()),
                      const Color(0xFFC62828)),
                  _Quick(
                      Icons.menu_book_rounded,
                      'Panduan',
                      () => push(context, const GuideListScreen()),
                      const Color(0xFF1B7F3B)),
                ]),
                const SectionTitle('Rekomendasi Hari Ini'),
                StaggerIn(
                  index: 0,
                  child: ScaleTap(
                    onTap: () => push(context, DetailScreen(id: top.c.id)),
                    child: PhotoBanner(
                      asset: top.c.asset,
                      height: 232,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.sun,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: UiText('★ PILIHAN TERBAIK',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkGreen)),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UiText(top.c.fullName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      shadows: [
                                        Shadow(
                                            color: Color(0x99000000),
                                            blurRadius: 10)
                                      ])),
                              const SizedBox(height: 3),
                              UiText(
                                  s.goal == 'Kestabilan'
                                      ? 'Paling stabil & menguntungkan'
                                      : 'Potensi keuntungan tertinggi',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Color(0x99000000),
                                            blurRadius: 8)
                                      ])),
                              const SizedBox(height: 8),
                              GlassChip(
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(11, 5, 11, 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const UiText('Keuntungan potensial',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                              color: Colors.white)),
                                      const SizedBox(height: 1),
                                      UiText(rp(top.margin),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.sun)),
                                    ],
                                  ),
                                ),
                                bg: const Color(0x80000000),
                              ),
                              const SizedBox(height: 10),
                              Row(children: [
                                SizedBox(
                                  height: 34,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        // Di atas foto, kartu putih menjadi kontras;
                                        // pada mode gelap tombol gelap justru hilang
                                        // di balik foto, sehingga digunakan hijau
                                        // solid.
                                        backgroundColor: AppColors.gelap
                                            ? AppColors.greenFill
                                            : AppColors.card,
                                        foregroundColor: AppColors.gelap
                                            ? Colors.white
                                            : AppColors.green,
                                        minimumSize: const Size(0, 34),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14)),
                                    onPressed: () => push(
                                        context, DetailScreen(id: top.c.id)),
                                    child: const UiText('Lihat Detail',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: ScaleTap(
                                    onTap: () => push(
                                        context,
                                        DetailScreen(
                                            id: top.c.id, initialTab: 1)),
                                    child: const GlassChip(
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 6, 10, 6),
                                        child: UiText('Panduan tanam  →',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SectionTitle(
                  'Harga Pasar Terkini',
                  trailing: GestureDetector(
                    onTap: () => onGoTab(2),
                    child: UiText('Lihat Semua',
                        style: TextStyle(
                            color: AppColors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                StaggerIn(
                  index: 1,
                  child: Panel(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Column(children: [
                      for (var i = 0; i < 5; i++) ...[
                        _PriceRow(commodities[i], onTap: () => onGoTab(2)),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pintu masuk Mode Ladang: kartu gelap satu-satunya di Beranda agar fitur ini
/// terasa berbeda dari menu biasa, sekaligus menunjukkan berapa kerja yang telah
/// menunggu hari ini.
class _FieldModeCard extends StatelessWidget {
  final AppState state;
  const _FieldModeCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final tugas = buildFieldTasks(
      plantings: state.plantings,
      today: state.weather?.today,
      activeCrop: state.active,
    );
    final terlewat = tugas.where((t) => t.overdue).length;
    return ScaleTap(
      onTap: () => push(context, const FieldModeScreen()),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepGreen, AppColors.darkGreen],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.o(0.16)),
          boxShadow: [
            BoxShadow(
                color: AppColors.gelap
                    ? Colors.black.o(0x8C)
                    : const Color(0x330B3D20),
                blurRadius: 18,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.sun.o(0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.sun.o(0.5)),
            ),
            child: Icon(Icons.record_voice_over_rounded,
                color: AppColors.sun, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const UiText('Mode Ladang',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              UiText(
                  terlewat > 0
                      ? tpl('{0} kerja terlewat • dipandu suara', ['$terlewat'])
                      : tpl('{0} kerja hari ini • dipandu suara',
                          ['${tugas.length}']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white.o(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              UiText(tpl('Terdekat: {0}', [tr(tugas.first.title)]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.sun,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.sun,
              borderRadius: BorderRadius.circular(12),
            ),
            child: UiText('Mulai',
                maxLines: 1,
                style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Quick(this.icon, this.label, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    // Aksen menu cepat diterangkan pada mode gelap agar tidak tenggelam.
    final warna = AppColors.aksen(color);
    return Expanded(
      child: ScaleTap(
        onTap: onTap,
        child: Column(children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: warna.o(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: warna.o(0.30)),
            ),
            child: Icon(icon, color: warna, size: 25),
          ),
          const SizedBox(height: 6),
          // Tinggi label dikunci: tanpa batasan ini baris kedua tampak miring
          // karena sebagian label membutuhkan dua baris dan sebagian tidak.
          SizedBox(
            height: 30,
            child: UiText(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text)),
          ),
        ]),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final Commodity c;
  final VoidCallback onTap;
  const _PriceRow(this.c, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final up = MarketService.changePct(c) >= 0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          CommodityImage(c, size: 54, radius: 13),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(c.fullName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 1),
              UiText('${rp(MarketService.current(c))}/kg',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ]),
          ),
          SparkLine(MarketService.history(c, 12),
              color: up ? AppColors.green : AppColors.down),
          const SizedBox(width: 10),
          ChangeText(MarketService.changePct(c)),
        ]),
      ),
    );
  }
}

// ================================================ KEPALA HIJAU BERTEMA TANI
class _DashboardHeader extends StatelessWidget {
  final VoidCallback onMenu;
  final ValueChanged<int> onGoTab;
  const _DashboardHeader({required this.onMenu, required this.onGoTab});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final alerts = buildNotifications(s).length;
    final today = s.weather?.today;
    return AgriScene(
      hillHeight: 62,
      frontColor: AppColors.bg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                _Glass(
                    onTap: onMenu,
                    child: const Icon(Icons.menu_rounded, color: Colors.white)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Avatar(s.name, size: 40, emoji: s.avatarEmoji),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiText('${salam()},',
                            style: TextStyle(
                                color: Colors.white.o(0.85), fontSize: 13)),
                        UiText(s.name.isEmpty ? 'Petani' : s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800)),
                      ]),
                ),
                Stack(clipBehavior: Clip.none, children: [
                  _Glass(
                    onTap: () => push(context, const NotificationScreen()),
                    child: const Icon(Icons.notifications_rounded,
                        color: Colors.white),
                  ),
                  if (alerts > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColors.sun, shape: BoxShape.circle),
                        child: UiText('$alerts',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkGreen)),
                      ),
                    ),
                ]),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                UiText('Ringkasan Usaha Tani',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => push(context, const WeatherScreen()),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.o(0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.o(0.28)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                          today == null
                              ? (s.weatherBusy
                                  ? Icons.cloud_outlined
                                  : Icons.location_on_outlined)
                              : weatherIcon(today.condition),
                          size: 13,
                          color: AppColors.sun),
                      const SizedBox(width: 4),
                      Flexible(
                        child: UiText(
                            today != null
                                ? '${today.maxTemp.round()}° • ${tr(today.label)}'
                                : (s.weatherBusy
                                    ? 'Mengambil prakiraan cuaca…'
                                    : 'Ubah lokasi kebun'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.o(0.9), fontSize: 13)),
                      ),
                      const SizedBox(width: 8),
                      UiText(tanggalPendek(DateTime.now()),
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white.o(0.9), fontSize: 13)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _Stat(
                    Icons.crop_square_rounded,
                    'Luas Lahan',
                    '${thousands(s.landArea)} m²',
                    () => push(context, const InputScreen())),
                const SizedBox(width: 8),
                _Stat(Icons.account_balance_wallet_rounded, 'Modal Tersedia',
                    rp(s.capital), () => push(context, const InputScreen())),
                const SizedBox(width: 8),
                _Stat(Icons.grass_rounded, 'Komoditas Aktif', s.active.name,
                    () => push(context, DetailScreen(id: s.active.id))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Glass({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.o(0.16),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.o(0.28)),
          ),
          child: child,
        ),
      );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final VoidCallback onTap;
  const _Stat(this.icon, this.label, this.value, this.onTap);

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
            decoration: BoxDecoration(
              // Isi gelap solid: bila tetap transparan, matahari dan awan pada
              // latar AgriScene menembus kartu dan membuat teks tampak keruh.
              color: AppColors.darkGreen.o(0x4D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.o(0.30)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x2E000000),
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, size: 18, color: AppColors.sun),
              const SizedBox(height: 6),
              UiText(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.o(0.92), fontSize: 11)),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: UiText(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
        ),
      );
}
