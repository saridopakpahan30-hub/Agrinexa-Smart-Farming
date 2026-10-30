import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../screens/calendar_screen.dart';
import '../screens/field_mode_screen.dart';
import '../screens/ledger_screen.dart';
import '../screens/pest_screen.dart';
import '../screens/fertilizer_screen.dart';
import '../state/app_state.dart';
import 'agri_scene.dart';
import 'common.dart';

class AppDrawer extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTab;
  final VoidCallback onHistory, onSettings, onGuide;

  const AppDrawer({
    super.key,
    required this.selected,
    required this.onTab,
    required this.onHistory,
    required this.onSettings,
    required this.onGuide,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    Widget item(IconData icon, String label, bool sel, VoidCallback tap) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          child: Material(
            color: sel ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).pop();
                tap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 14),
                  UiText(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ),
        );

    return Drawer(
      width: 290,
      backgroundColor: AppColors.darkGreen,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 18),
              child: Row(children: [
                const AssetImg(Assets.logo,
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                    fallback:
                        Icon(Icons.eco_rounded, color: Colors.white, size: 32)),
                const SizedBox(width: 10),
                const Expanded(
                  child: UiText('Agrinexa',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Avatar(s.name, size: 42, emoji: s.avatarEmoji),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiText(s.name.isEmpty ? 'Petani' : s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                      UiText(s.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.o(0.7), fontSize: 13)),
                    ]),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Divider(color: Colors.white24, height: 1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                item(Icons.home_rounded, tr('Beranda'), selected == 0,
                    () => onTab(0)),
                item(Icons.record_voice_over_rounded, tr('Mode Ladang'), false,
                    () => push(context, const FieldModeScreen())),
                item(Icons.auto_awesome_rounded, tr('Rekomendasi'),
                    selected == 1, () => onTab(1)),
                item(Icons.menu_book_rounded, tr('Panduan Tanaman'), false,
                    onGuide),
                item(Icons.account_balance_wallet_rounded, tr('Buku Kas'),
                    false, () => push(context, const LedgerScreen())),
                item(Icons.event_note_rounded, tr('Kalender Tanam'), false,
                    () => push(context, const CalendarScreen())),
                item(Icons.bug_report_rounded, tr('Hama & Penyakit'), false,
                    () => push(context, const PestScreen())),
                item(Icons.eco_rounded, tr('Kalkulator Pupuk'), false,
                    () => push(context, const FertilizerScreen())),
                item(Icons.storefront_rounded, tr('Pasar'), selected == 2,
                    () => onTab(2)),
                item(Icons.history_rounded, tr('Riwayat'), false, onHistory),
                item(Icons.person_rounded, tr('Profil'), selected == 3,
                    () => onTab(3)),
                item(Icons.settings_rounded, 'Pengaturan', false, onSettings),
              ]),
            ),
          ),
          SizedBox(
            height: 190,
            child: AgriScene(
              hillHeight: 130,
              frontColor: AppColors.darkGreen,
              overlay: const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: UiText('Pertanian maju,\nmasa depan cerah',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
