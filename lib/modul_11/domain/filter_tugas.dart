import 'tugas_performa.dart';

/// Kriteria penyaringan daftar tugas.
///
/// [status] bernilai `null` berarti "semua status".
class KriteriaFilter {
  const KriteriaFilter({this.kueri = '', this.status});

  final String kueri;
  final StatusTugas? status;

  KriteriaFilter salinDengan({
    String? kueri,
    StatusTugas? status,
    bool hapusStatus = false,
  }) => KriteriaFilter(
    kueri: kueri ?? this.kueri,
    status: hapusStatus ? null : (status ?? this.status),
  );
}

/// Menyaring [sumber] tanpa mengubahnya.
///
/// Fungsi murni (tanpa Flutter) agar dapat diuji dengan unit test dan
/// dipanggil HANYA ketika kriteria berubah, bukan pada setiap `build()`.
List<TugasPerforma> saringTugas(
    List<TugasPerforma> sumber,
    KriteriaFilter kriteria,
    ) {
  final String kueri = kriteria.kueri.trim().toLowerCase();
  return sumber
      .where((TugasPerforma tugas) {
    final bool cocokStatus =
        kriteria.status == null || tugas.status == kriteria.status;
    final bool cocokTeks =
        kueri.isEmpty || tugas.kunciPencarian.contains(kueri);
    return cocokStatus && cocokTeks;
  })
      .toList(growable: false);
}