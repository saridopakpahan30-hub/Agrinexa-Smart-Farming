/// Catatan arus kas sederhana per akun (Buku Kas).
class LedgerEntry {
  final String id;
  final int timeMs; // Waktu pencatatan
  final bool income; // true berarti pemasukan, false berarti pengeluaran
  final String category;
  final int amount; // Dalam rupiah
  final String note;
  final String? commodityId;

  const LedgerEntry({
    required this.id,
    required this.timeMs,
    required this.income,
    required this.category,
    required this.amount,
    this.note = '',
    this.commodityId,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timeMs);

  Map<String, dynamic> toJson() => {
        'id': id,
        't': timeMs,
        'i': income,
        'c': category,
        'a': amount,
        'n': note,
        'k': commodityId,
      };

  factory LedgerEntry.fromJson(Map<String, dynamic> j) => LedgerEntry(
        id: j['id'] as String,
        timeMs: (j['t'] as num).toInt(),
        income: j['i'] as bool,
        category: j['c'] as String,
        amount: (j['a'] as num).toInt(),
        note: (j['n'] as String?) ?? '',
        commodityId: j['k'] as String?,
      );
}

const expenseCategories = [
  'Bibit',
  'Pupuk',
  'Pestisida',
  'Tenaga kerja',
  'Sewa alat',
  'Lainnya',
];

const incomeCategories = ['Panen', 'Lainnya'];
