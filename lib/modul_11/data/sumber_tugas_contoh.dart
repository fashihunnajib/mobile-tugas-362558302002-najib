import '../domain/tugas_performa.dart';

/// Mata kuliah contoh yang dipakai bergiliran.
const List<String> daftarMataKuliahContoh = <String>[
  'Pemrograman Mobile',
  'Basis Data',
  'Jaringan Komputer',
  'Rekayasa Perangkat Lunak',
  'Sistem Operasi',
  'Kecerdasan Buatan',
  'Pemrograman Web',
  'Analisis dan Perancangan Sistem',
];

/// Membuat data sintetis untuk praktikum. Seperempat tugas ditandai selesai
/// (1.000 tugas → tepat 250 selesai) dan tersebar ke SEMUA mata kuliah,
/// sehingga kombinasi filter mata kuliah + status selalu memiliki hasil.
///
/// Data dibuat lokal dan tidak mewakili hasil benchmark perangkat nyata.
List<TugasPerforma> buatTugasContoh({int jumlah = 1000}) =>
    List<TugasPerforma>.generate(
      jumlah,
          (int index) => TugasPerforma(
        nomor: index + 1,
        mataKuliah:
        daftarMataKuliahContoh[index % daftarMataKuliahContoh.length],
        status: _selesai(index) ? StatusTugas.selesai : StatusTugas.aktif,
      ),
      growable: false,
    );

/// Pola selesai: posisi bergeser satu setiap putaran mata kuliah, agar
/// setiap mata kuliah mendapat bagian tugas selesai. Tugas nomor 4 selesai.
bool _selesai(int index) =>
    (index ~/ daftarMataKuliahContoh.length + index) % 4 == 3;