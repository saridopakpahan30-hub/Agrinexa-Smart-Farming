import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../services/weather_service.dart';
import '../state/app_state.dart';

/// Cari nama kota, kecamatan, atau desa lalu simpan sebagai lokasi kebun.
Future<void> showLocationPicker(BuildContext context) async {
  final s = AppScope.of(context);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _LocationSheet(state: s),
  );
}

class _LocationSheet extends StatefulWidget {
  final AppState state;
  const _LocationSheet({required this.state});

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  final _q = TextEditingController();
  List<Place> _results = [];
  bool _busy = false, _detect = false;
  String? _err;

  Future<void> _search() async {
    if (_q.text.trim().length < 2) {
      setState(() => _err = 'Ketik minimal 2 huruf, mis. "Kediri".');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final r = await WeatherService.searchPlace(_q.text);
      if (!mounted) return;
      setState(() {
        _results = r;
        _busy = false;
        if (r.isEmpty) _err = 'Nama tempat tidak ditemukan.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _err = 'Pencarian gagal — periksa koneksi internet.';
      });
    }
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _detect = true;
      _err = null;
    });
    try {
      // GPS diprioritaskan; bila ditolak atau tidak terkunci, alamat IP yang
      // digunakan.
      final p = await WeatherService.lokasiPerangkat();
      await widget.state.setFarmLocation(
          city: p.full.isEmpty ? p.name : p.full, lat: p.lat, lon: p.lon);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _detect = false;
        _err = tr('Lokasi tidak terbaca. Izinkan lokasi, nyalakan GPS, atau '
            'ketik nama daerah Anda.');
      });
    }
  }

  Future<void> _pick(Place p) async {
    await widget.state.setFarmLocation(city: p.name, lat: p.lat, lon: p.lon);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UiText('Lokasi kebun',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            UiText('Cuaca, saran tanam, dan kalender mengikuti daerah ini.',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: BorderSide(color: AppColors.green)),
                onPressed: _detect ? null : _useMyLocation,
                icon: _detect
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location_rounded, size: 18),
                label: const UiText('Pakai lokasi perangkat saya'),
              ),
            ),
            const SizedBox(height: 10),
            // Kotak pencarian selebar layar dengan tombol di bawahnya.
            // ElevatedButton tidak boleh ditempatkan di dalam Row: tema aplikasi
            // memberikan lebar minimum tak terhingga (Size.fromHeight), dan di
            // dalam Row lebar tersebut tidak dapat dihitung, sehingga tata
            // letak gagal dan kotak isian tidak pernah tergambar.
            TextField(
              controller: _q,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: tr('Atau cari: desa / kecamatan / kota'),
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _search,
                child: const UiText('Cari'),
              ),
            ),
            if (_err != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: UiText(_err!,
                    style: TextStyle(fontSize: 13, color: AppColors.down)),
              ),
            const SizedBox(height: 8),
            if (_busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final r in _results)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            Icon(Icons.place_outlined, color: AppColors.green),
                        title: UiText(r.name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        subtitle: UiText(
                            r.region.isEmpty
                                ? '${r.lat.toStringAsFixed(3)}, ${r.lon.toStringAsFixed(3)}'
                                : '${r.region} • ${r.lat.toStringAsFixed(2)}, ${r.lon.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13)),
                        onTap: () => _pick(r),
                      ),
                    if (_results.isEmpty && _err == null && !_busy)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: UiText(
                            'Seluruh Indonesia — coba "Cisoka, Tangerang" '
                            'atau nama dusun Anda.',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.muted)),
                      ),
                  ],
                ),
              ),
            if (widget.state.farmCity.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: UiText(
                    'Tersimpan: ${widget.state.farmCity}'
                    '${widget.state.locationChosen ? '' : ' (deteksi otomatis)'}',
                    style: TextStyle(fontSize: 13, color: AppColors.muted)),
              ),
            // Kewajiban lisensi: alamat berasal dari OpenStreetMap (ODbL).
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: UiText('Alamat: © OpenStreetMap contributors',
                  style: TextStyle(fontSize: 11, color: AppColors.muted)),
            ),
          ],
        ),
      );
}
