import 'package:flutter/services.dart';

import 'i18n.dart';

String thousands(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return v < 0 ? '-$b' : b.toString();
}

String rp(num v) =>
    v < 0 ? '-Rp ${thousands(v.round().abs())}' : 'Rp ${thousands(v.round())}';

String jt(num v) => Lang.inggris
    ? '${(v / 1000000).toStringAsFixed(1)}M'
    : '${(v / 1000000).toStringAsFixed(1)} jt';

int parseInt(String s) =>
    int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

String pct(double v, {bool sign = false}) =>
    '${sign && v >= 0 ? '+' : ''}${v.toStringAsFixed(1)}%';

String _desa(double v) {
  var t = v.toStringAsFixed(v >= 100 ? 0 : 1);
  if (t.endsWith('.0')) t = t.substring(0, t.length - 2);
  return t.replaceAll('.', Lang.inggris ? '.' : ',');
}

/// Memformat rentang dosis pupuk dengan satuan yang dipilih agar angka tetap
/// mudah dibaca: 800–1200 kg menjadi '0,8 sampai 1,2 ton', sedangkan 250 kg
/// tetap '250 kg'.
String rentangKg(double loKg, double hiKg) {
  final (div, unit) =
      hiKg >= 1000 ? (1000.0, 'ton') : (hiKg >= 1 ? (1.0, 'kg') : (0.001, 'g'));
  final a = _desa(loKg / div), b = _desa(hiKg / div);
  return a == b ? '$a $unit' : tpl('{0} sampai {1} {2}', [a, b, unit]);
}

/// Memformat dosis per tanaman: dalam gram bila di bawah 1 kg, dalam kilogram
/// bila 1 kg atau lebih.
String dosisPerTanaman(double kg) {
  if (kg <= 0) return '';
  return kg >= 1 ? '${_desa(kg)} kg' : '${_desa(kg * 1000)} g';
}

const _hariId = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _hariEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _bulanId = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des'
];
const _bulanEn = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

List<String> get _hari => Lang.inggris ? _hariEn : _hariId;
List<String> get _bulan => Lang.inggris ? _bulanEn : _bulanId;

String tanggalPanjang(DateTime d) =>
    '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]} ${d.year}';
String tanggalPendek(DateTime d) => '${d.day} ${_bulan[d.month - 1]}';
String namaBulan(DateTime d) => _bulan[d.month - 1];

String salam() {
  final h = DateTime.now().hour;
  if (h < 11) return tr('Selamat pagi');
  if (h < 15) return tr('Selamat siang');
  if (h < 18) return tr('Selamat sore');
  return tr('Selamat malam');
}

/// Memformat input angka dengan pemisah ribuan berupa titik:
/// 5000000 -> 5.000.000.
class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final f = thousands(int.parse(digits));
    return TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: f.length),
    );
  }
}
