import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;

  /// Waktu acuan untuk menghitung sisa masa berlaku.
  final DateTime sekarang;

  final VoidCallback? onKeluar;
  final bool sedangKeluar;

  /// Menampilkan token apa adanya. Default `false`.
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  /// Menyamarkan token: hanya 6 karakter awal yang terlihat.
  static String samarkanToken(String token) {
    if (token.isEmpty) return '(kosong)';
    if (token.length <= 6) return _titik(token.length);
    return '${token.substring(0, 6)}${_titik(12)}';
  }

  static String _titik(int jumlah) =>
      List<String>.filled(jumlah, '\u2022').join();

  /// Mengubah `2026-09-21T10:15:00.000` menjadi `21 Sep 2026, 10:15`.
  static String formatWaktu(String iso) {
    const List<String> bulan = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final DateTime? waktu = DateTime.tryParse(iso);
    if (waktu == null) return 'tidak diketahui';
    final String jam = waktu.hour.toString().padLeft(2, '0');
    final String menit = waktu.minute.toString().padLeft(2, '0');
    return '${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}, '
        '$jam:$menit';
  }

  /// Mengubah Duration menjadi `1 jam 5 menit` / `45 detik`.
  static String formatSisa(Duration sisa) {
    if (sisa.inSeconds <= 0) return 'sudah berakhir';
    if (sisa.inMinutes < 1) return '${sisa.inSeconds} detik';
    if (sisa.inHours < 1) return '${sisa.inMinutes} menit';
    final int menit = sisa.inMinutes.remainder(60);
    return menit == 0
        ? '${sisa.inHours} jam'
        : '${sisa.inHours} jam $menit menit';
  }

// build() menampilkan nama, email, peran (labelPeran), waktu masuk
// (formatWaktu), sisa waktu (formatSisa), token tersamar, dan
// tombol Keluar yang memanggil onKeluar. Versi lengkapnya ada di
// repositori starter.
  @override
  Widget build(BuildContext context) {
    final Duration sisa = sesi.sisaWaktu(sekarang);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'Nama: ${sesi.nama}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 4),
            Text('Email: ${sesi.email}'),
            Text('Peran: ${SesiPengguna.labelPeran(sesi.peran)}'),
            const Divider(height: 24),
            Text('Waktu Masuk: ${formatWaktu(sesi.masukPada)}'),
            Text(
                'Sisa Waktu: ${formatSisa(sisa)}',
                style: TextStyle(
                  color: sisa.inSeconds <= 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                )
            ),
            const SizedBox(height: 8),
            Text(
              'Token: ${tampilkanToken ? sesi.token : samarkanToken(sesi.token)}',
              style: const TextStyle(fontFamily: 'monospace', color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            if (onKeluar != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: sedangKeluar ? null : onKeluar,
                  icon: sedangKeluar
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.logout),
                  label: Text(sedangKeluar ? 'Keluar...' : 'Keluar'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}