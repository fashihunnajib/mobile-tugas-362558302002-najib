import 'dart:async';

import '../../../modul_11/data/sumber_tugas_contoh.dart';
import '../../../modul_11/domain/tugas_performa.dart';

/// Satu halaman hasil dari sumber data.
class HalamanTugas {
  const HalamanTugas({required this.item, required this.adaBerikutnya});

  final List<TugasPerforma> item;
  final bool adaBerikutnya;
}

/// Kontrak sumber data berhalaman (misalnya REST API dengan `?page=`).
abstract interface class SumberTugasBerhalaman {
  Future<HalamanTugas> ambil({required int halaman, required int ukuran});
}

/// Simulasi server lokal: data dikirim per halaman dengan jeda buatan.
///
/// [gagalPadaHalaman] dipakai untuk mempraktikkan state gagal dan tombol
/// "Coba lagi"; kegagalan terjadi SEKALI lalu permintaan berikutnya berhasil.
class SumberTugasSimulasi implements SumberTugasBerhalaman {
  SumberTugasSimulasi({
    int total = 1000,
    this.jeda = const Duration(milliseconds: 300),
    Set<int> gagalPadaHalaman = const <int>{},
  }) : _semua = buatTugasContoh(jumlah: total),
        _gagalTersisa = <int>{...gagalPadaHalaman};

  final List<TugasPerforma> _semua;
  final Duration jeda;
  final Set<int> _gagalTersisa;

  @override
  Future<HalamanTugas> ambil({
    required int halaman,
    required int ukuran,
  }) async {
    if (halaman < 1 || ukuran < 1) {
      throw ArgumentError('halaman dan ukuran harus >= 1');
    }
    await Future<void>.delayed(jeda);
    if (_gagalTersisa.remove(halaman)) {
      throw TimeoutException('Server tidak menjawab (simulasi).');
    }
    final int mulai = (halaman - 1) * ukuran;
    if (mulai >= _semua.length) {
      return const HalamanTugas(item: <TugasPerforma>[], adaBerikutnya: false);
    }
    final int akhir = (mulai + ukuran).clamp(0, _semua.length);
    return HalamanTugas(
      item: _semua.sublist(mulai, akhir),
      adaBerikutnya: akhir < _semua.length,
    );
  }
}