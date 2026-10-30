import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../services/field_tasks.dart';
import '../services/voice_guide.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'ledger_screen.dart';

/// Mode Ladang — satu kerja per layar, huruf besar, kontras tinggi, dan
/// dibacakan dengan suara. Dirancang untuk digunakan di lapangan: tangan
/// memakai sarung tangan, matahari menyilaukan, dan pengguna tidak ingin
/// membaca tabel. Tombol setinggi 64 piksel agar mudah ditekan sambil berdiri.
class FieldModeScreen extends StatefulWidget {
  const FieldModeScreen({super.key});

  @override
  State<FieldModeScreen> createState() => _FieldModeScreenState();
}

class _FieldModeScreenState extends State<FieldModeScreen> {
  final VoiceGuide _voice = VoiceGuide();
  late final AppState _state;
  late final List<FieldTask> _tasks;
  final Set<int> _handled = {};
  int _i = 0;
  int _done = 0;
  bool _sound = true;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    _state = AppScope.of(context);
    _tasks = buildFieldTasks(
      plantings: _state.plantings,
      today: _state.weather?.today,
      activeCrop: _state.active,
    );
    _speak();
  }

  @override
  void dispose() {
    _voice.stop();
    super.dispose();
  }

  bool get _finished => _i >= _tasks.length;

  void _speak() {
    if (!_sound) return;
    final teks = _finished
        ? tpl('Selesai. Kerja ladang hari ini {0} langkah.', ['$_done'])
        : _tasks[_i].spoken;
    _voice.speak(teks).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _markDone() async {
    final t = _tasks[_i];
    _handled.add(_i);
    _i++;
    _done++;
    if (t.linkable) await _state.toggleStage(t.plantingId!, t.stage!);
    if (!mounted) return;
    setState(() {});
    _speak();
  }

  void _skip() {
    _handled.add(_i);
    _i++;
    setState(() {});
    _speak();
  }

  void _restart() {
    setState(() {
      _handled.clear();
      _i = 0;
      _done = 0;
    });
    _speak();
  }

  void _toggleSound() {
    setState(() => _sound = !_sound);
    if (_sound) {
      // Daftar suara pada web sering baru terisi setelah halaman terbuka.
      _voice.ulangi();
      _speak();
    } else {
      _voice.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selesai = _finished;
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF113F24),
              AppColors.darkGreen,
              const Color(0xFF04150C)
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            _bar(),
            if (selesai)
              Expanded(child: _finishedView())
            else ...[
              _progress(),
              Expanded(child: _taskView(_tasks[_i])),
              _actions(),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _bar() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
        child: Row(children: [
          _round(
              Icons.close_rounded, 'Tutup', () => Navigator.maybePop(context)),
          const Expanded(
            child: Center(
              child: UiText('MODE LADANG',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          _round(_sound ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              'Suara', _toggleSound),
        ]),
      );

  Widget _round(IconData icon, String tip, VoidCallback onTap) => IconButton(
        onPressed: onTap,
        // Material membangun tooltip dengan Text buatan sendiri, sehingga
        // terjemahan harus diminta di sini, bukan melalui UiText.
        tooltip: tr(tip),
        iconSize: 26,
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.o(0.14),
          minimumSize: const Size(56, 56),
        ),
        icon: Icon(icon),
      );

  Widget _progress() {
    final tersisa = _tasks.length - _i;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Flexible(
            child: UiText(
                tpl('Tugas {0} dari {1}', ['${_i + 1}', '${_tasks.length}']),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.sun,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: UiText(tpl('Sisa {0} kerja', ['$tersisa']),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white.o(0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _tasks.isEmpty ? 1 : _handled.length / _tasks.length,
            minHeight: 12,
            backgroundColor: Colors.white.o(0.16),
            valueColor: AlwaysStoppedAnimation(AppColors.sun),
          ),
        ),
      ]),
    );
  }

  Widget _taskView(FieldTask t) {
    final musim = t.dayOfSeason >= 0
        ? tpl('{0} • hari ke-{1} dari {2}',
            [t.dueLabel, '${t.dayOfSeason}', '${t.crop.growDays}'])
        : t.dueLabel;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CommodityImage(t.crop, size: 56, radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiText(t.crop.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              UiText(musim,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: t.overdue ? AppColors.sun : Colors.white.o(0.72),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
        const SizedBox(height: 22),
        UiText(t.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                height: 1.15,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        UiText(t.detail,
            style: TextStyle(
                color: Colors.white.o(0.88),
                fontSize: 20,
                height: 1.45,
                fontWeight: FontWeight.w500)),
        if (t.caution != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sun.o(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.sun.o(0.55)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.sun, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: UiText(t.caution!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.4,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 16),
        _voiceNote(),
      ]),
    );
  }

  /// Status suara selalu terlihat: pengguna harus mengetahui apakah langkahnya
  /// dibacakan atau hanya tertulis.
  Widget _voiceNote() {
    final (IconData icon, Color warna, String teks) = switch (_voice.status) {
      VoiceStatus.siap => (
          Icons.graphic_eq_rounded,
          AppColors.sun,
          tpl(
              Lang.inggris
                  ? 'Suara Inggris aktif{0}'
                  : 'Suara Indonesia aktif{0}',
              [_voice.voiceName.isEmpty ? '' : ': ${_voice.voiceName}'])
        ),
      VoiceStatus.menunggu => (
          Icons.hourglass_top_rounded,
          Colors.white,
          'Menyiapkan suara…'
        ),
      VoiceStatus.tidakAdaSuaraBahasa => (
          Icons.translate_rounded,
          AppColors.sun,
          Lang.inggris
              ? 'This device has no English speech voice, so the work is only '
                  'shown as text. Add one in Android: Settings ▸ Sound & vibration '
                  '▸ Text-to-speech ▸ Install voice data. In Chrome/Windows: '
                  'Settings ▸ Languages ▸ Speech ▸ add English.'
              : 'Perangkat ini belum punya suara bahasa Indonesia, jadi kerja dibacakan '
                  'lewat teks saja. Tambahkan di Android: Setelan ▸ Suara & getaran ▸ '
                  'Teks-ke-ucapan ▸ Instal suara bahasa Indonesia. Di Chrome/Windows: '
                  'Setelan ▸ Waktu & bahasa ▸ Suara & ucapan ▸ tambah Bahasa Indonesia.'
        ),
      VoiceStatus.tidakAdaEngine => (
          Icons.hearing_disabled_rounded,
          Colors.white,
          'Suara tidak tersedia di peramban atau perangkat ini. '
              'Teks di layar tetap lengkap.'
        ),
    };
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: warna.o(0.85)),
      const SizedBox(width: 8),
      Expanded(
        child: UiText(teks,
            style: TextStyle(
                color: Colors.white.o(0.62), fontSize: 14, height: 1.4)),
      ),
    ]);
  }

  Widget _actions() => Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
        child: Column(children: [
          SizedBox(
            height: 78,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.darkGreen,
                  minimumSize: const Size.fromHeight(78),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              onPressed: _markDone,
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_rounded, size: 32),
                  SizedBox(width: 10),
                  UiText('Sudah dikerjakan',
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: _secondary(Icons.campaign_rounded, 'Baca lagi', _speak)),
            const SizedBox(width: 10),
            Expanded(
                child: _secondary(Icons.skip_next_rounded, 'Lewati', _skip)),
          ]),
        ]),
      );

  Widget _secondary(IconData icon, String label, VoidCallback onTap) =>
      SizedBox(
        height: 64,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(64),
              side: BorderSide(color: Colors.white.o(0.55), width: 1.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              UiText(label,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );

  Widget _finishedView() => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        child: Column(children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.sun.o(0.16),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.sun, width: 2.5),
            ),
            child: Icon(Icons.emoji_events_rounded,
                size: 44, color: AppColors.sun),
          ),
          const SizedBox(height: 16),
          UiText(
            _done == 0
                ? 'Lewat dulu hari ini'
                : tpl('{0} kerja ladang tercatat selesai', ['$_done']),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          UiText(
            _done == 0
                ? 'Tidak ada kerja yang ditandai selesai. Anda bisa mengulang '
                    'daftar tugas hari ini dari awal.'
                : 'Daftar perawatan di kalender tanam sudah diperbarui. '
                    'Catat hasil panen dan biaya hari ini supaya laporan '
                    'Anda benar.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.o(0.82), fontSize: 17, height: 1.4),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 68,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sun,
                  foregroundColor: AppColors.darkGreen,
                  minimumSize: const Size.fromHeight(68),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              onPressed: () => push(context, const LedgerScreen()),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: UiText('Catat hasil / biaya',
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
                child: _secondary(
                    Icons.refresh_rounded, 'Ulangi tugas', _restart)),
            const SizedBox(width: 10),
            Expanded(
                child: _secondary(Icons.close_rounded, 'Keluar',
                    () => Navigator.maybePop(context))),
          ]),
        ]),
      );
}
