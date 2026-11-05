/// Status sebuah tugas pada daftar Modul 11.
enum StatusTugas { aktif, selesai }

/// Model data satu tugas. Bersifat immutable agar aman dipakai ulang
/// oleh daftar yang dibangun secara lazy.
class TugasPerforma {
  TugasPerforma({
    required this.nomor,
    required this.mataKuliah,
    required this.status,
  }) : kunciPencarian = '${_judulDari(nomor)} $mataKuliah'.toLowerCase();

  final int nomor;
  final String mataKuliah;
  final StatusTugas status;

  /// Teks huruf kecil yang dihitung SEKALI saat objek dibuat.
  /// Tanpa field ini, `toLowerCase()` dijalankan ulang untuk setiap
  /// tugas pada setiap ketikan di kotak pencarian.
  final String kunciPencarian;

  String get judul => _judulDari(nomor);

  bool get selesai => status == StatusTugas.selesai;

  static String _judulDari(int nomor) =>
      'Tugas praktikum ${nomor.toString().padLeft(4, '0')}';
}