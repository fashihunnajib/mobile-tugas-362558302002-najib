import 'package:flutter/material.dart';

import '../../../modul_11/widgets/kartu_tugas_performa.dart';
import '../presentation/pengendali_halaman.dart';

/// Daftar yang memuat halaman berikutnya ketika pengguna mendekati akhir.
///
/// Berbeda dari Fase A: di sini data juga dimuat bertahap, bukan hanya
/// widget-nya yang dibangun secara lazy.
class LayarDaftarBerhalaman extends StatefulWidget {
  const LayarDaftarBerhalaman({required this.pengendali, super.key});

  final PengendaliHalaman pengendali;

  @override
  State<LayarDaftarBerhalaman> createState() => _LayarDaftarBerhalamanState();
}

class _LayarDaftarBerhalamanState extends State<LayarDaftarBerhalaman> {
  /// Jarak (piksel) dari akhir daftar yang memicu pemuatan berikutnya.
  static const double _ambangPemicu = 400;

  @override
  void initState() {
    super.initState();
    widget.pengendali.muatBerikutnya();
  }

  bool _saatGulir(ScrollNotification notifikasi) {
    if (notifikasi.metrics.extentAfter < _ambangPemicu) {
      widget.pengendali.muatBerikutnya();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Kuliah — Berhalaman')),
      body: ListenableBuilder(
        listenable: widget.pengendali,
        builder: (BuildContext context, Widget? _) {
          final PengendaliHalaman p = widget.pengendali;
          if (p.item.isEmpty && p.sedangMemuat) {
            return const Center(child: CircularProgressIndicator());
          }
          if (p.item.isEmpty && p.galat != null) {
            return _PanelGalat(
              pesan: p.galat ?? '',
              onCobaLagi: p.muatBerikutnya,
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: _saatGulir,
            child: ListView.builder(
              key: const ValueKey<String>('paged-list'),
              // Satu baris tambahan di akhir untuk indikator/galat/penutup.
              itemCount: p.item.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < p.item.length) {
                  return KartuTugasPerforma(tugas: p.item[index]);
                }
                if (p.galat != null) {
                  return _PanelGalat(
                    pesan: p.galat ?? '',
                    onCobaLagi: p.muatBerikutnya,
                  );
                }
                if (p.adaBerikutnya) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text('Semua ${p.item.length} tugas sudah dimuat.'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PanelGalat extends StatelessWidget {
  const _PanelGalat({required this.pesan, required this.onCobaLagi});

  final String pesan;
  final VoidCallback onCobaLagi;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(pesan, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onCobaLagi, child: const Text('Coba lagi')),
      ],
    ),
  );
}