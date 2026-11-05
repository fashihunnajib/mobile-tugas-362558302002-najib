import 'package:flutter/foundation.dart';

import '../../../modul_11/domain/tugas_performa.dart';
import '../data/sumber_tugas_berhalaman.dart';

/// Mengelola state daftar berhalaman: item yang sudah dimuat, sedang
/// memuat, galat, dan apakah masih ada halaman berikutnya.
class PengendaliHalaman extends ChangeNotifier {
  PengendaliHalaman(this._sumber, {this.ukuranHalaman = 50});

  final SumberTugasBerhalaman _sumber;
  final int ukuranHalaman;

  final List<TugasPerforma> _item = <TugasPerforma>[];
  int _halamanBerikutnya = 1;
  bool _sedangMemuat = false;
  bool _adaBerikutnya = true;
  String? _galat;
  bool _dibuang = false;

  List<TugasPerforma> get item => List<TugasPerforma>.unmodifiable(_item);
  bool get sedangMemuat => _sedangMemuat;
  bool get adaBerikutnya => _adaBerikutnya;
  String? get galat => _galat;

  /// Memuat halaman berikutnya. Panggilan ganda saat masih memuat,
  /// atau setelah data habis, diabaikan.
  Future<void> muatBerikutnya() async {
    if (_sedangMemuat || !_adaBerikutnya) return;
    _sedangMemuat = true;
    _galat = null;
    _beritahu();
    try {
      final HalamanTugas hasil = await _sumber.ambil(
        halaman: _halamanBerikutnya,
        ukuran: ukuranHalaman,
      );
      _item.addAll(hasil.item);
      _adaBerikutnya = hasil.adaBerikutnya;
      _halamanBerikutnya++;
    } on Object {
      // Halaman yang sama dicoba lagi pada panggilan berikutnya.
      _galat = 'Gagal memuat halaman $_halamanBerikutnya. Coba lagi.';
    } finally {
      _sedangMemuat = false;
      _beritahu();
    }
  }

  void _beritahu() {
    if (!_dibuang) notifyListeners();
  }

  @override
  void dispose() {
    _dibuang = true;
    super.dispose();
  }
}