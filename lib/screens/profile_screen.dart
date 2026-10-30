import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/commodity.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'input_screen.dart';
import 'misc_screens.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onMenu;
  const ProfileScreen({super.key, this.onMenu});

  Future<void> _editName(BuildContext context) async {
    final s = AppScope.of(context);
    final ctrl = TextEditingController(text: s.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const UiText('Ubah nama'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => Navigator.pop(c, true),
          decoration: InputDecoration(hintText: tr('Nama lengkap')),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const UiText('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const UiText('Simpan')),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      await s.updateName(ctrl.text);
    }
    ctrl.dispose();
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final s = AppScope.of(context);
    final picked = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const UiText('Pilih avatar'),
        content: SizedBox(
          width: 300,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final e in AppState.avatarChoices)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(c, e),
                  child: Container(
                    decoration: BoxDecoration(
                      color: s.avatarEmoji == e
                          ? AppColors.mint
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: s.avatarEmoji == e
                              ? AppColors.green
                              : AppColors.line),
                    ),
                    alignment: Alignment.center,
                    child: UiText(e, style: const TextStyle(fontSize: 28)),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, ''),
              child: const UiText('Tanpa avatar')),
          TextButton(
              onPressed: () => Navigator.pop(c), child: const UiText('Tutup')),
        ],
      ),
    );
    if (picked != null) await s.setAvatarEmoji(picked);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    Widget item(IconData icon, String label, VoidCallback tap) => ListTile(
          leading: Icon(icon, color: AppColors.green),
          title: UiText(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          trailing: Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          onTap: tap,
        );

    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.menu_rounded), onPressed: onMenu),
        title: const UiText('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StaggerIn(
            index: 0,
            child: PhotoBanner(
              asset: Assets.splash,
              height: 160,
              child: Row(children: [
                GestureDetector(
                  onTap: () => _pickAvatar(context),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Avatar(s.name, size: 64, emoji: s.avatarEmoji),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UiText(s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      color: Color(0x99000000), blurRadius: 10)
                                ])),
                        const SizedBox(height: 2),
                        UiText(s.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      color: Color(0x99000000), blurRadius: 8)
                                ])),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            GlassChip(
                              UiText('${thousands(s.landArea)} m²',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                            GlassChip(
                              UiText(rp(s.capital),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ]),
                ),
                IconButton(
                  tooltip: tr('Ubah nama'),
                  icon: Icon(Icons.edit_rounded, color: AppColors.sun),
                  onPressed: () => _editName(context),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          StaggerIn(
            index: 1,
            child: Panel(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                item(Icons.agriculture_rounded, 'Data Usaha Tani',
                    () => push(context, const InputScreen())),
                item(Icons.history_rounded, 'Riwayat Simulasi',
                    () => push(context, const HistoryScreen())),
                item(Icons.notifications_rounded, 'Notifikasi',
                    () => push(context, const NotificationScreen())),
                item(Icons.settings_rounded, 'Pengaturan',
                    () => push(context, const SettingsScreen())),
                item(Icons.help_rounded, 'Bantuan & FAQ',
                    () => push(context, const FaqScreen())),
                item(Icons.photo_library_outlined, 'Sumber Gambar',
                    () => push(context, const ImageCreditsScreen())),
                item(Icons.info_rounded, 'Tentang Aplikasi',
                    () => push(context, const AboutScreen())),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          StaggerIn(
            index: 2,
            child: Panel(
              color: AppColors.mint,
              child: Row(children: [
                Icon(Icons.spa_rounded, color: AppColors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: UiText('Bersama Agrinexa,\npetani lebih kuat!',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: AppColors.green)),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          StaggerIn(
            index: 3,
            child: OutlinedButton.icon(
              onPressed: () => logoutAndExit(context),
              icon: const Icon(Icons.logout_rounded),
              label: const UiText('Keluar'),
            ),
          ),
        ],
      ),
    );
  }
}
