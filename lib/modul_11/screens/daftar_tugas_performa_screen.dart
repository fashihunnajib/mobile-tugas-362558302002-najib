import 'package:flutter/material.dart';

import '../data/sumber_tugas_contoh.dart';
import '../domain/filter_tugas.dart';
import '../domain/tugas_performa.dart';
import '../widgets/kartu_tugas_performa.dart';

/// Layar daftar 1.000 tugas dengan pencarian dan filter status.
///
/// Dua keputusan performa yang dapat dijelaskan:
/// 1. Hasil penyaringan disimpan di state dan dihitung ulang hanya saat
///    kriteria berubah, bukan di dalam `build()`.
/// 2. Kartu dibangun secara lazy dengan `ListView.builder`.
class LayarDaftarTugasPerforma extends StatefulWidget {
  const LayarDaftarTugasPerforma({this.sumber, super.key});

  /// Sumber data opsional untuk pengujian; bawaan: 1.000 tugas contoh.
  final List<TugasPerforma>? sumber;

  @override
  State<LayarDaftarTugasPerforma> createState() =>
      _LayarDaftarTugasPerformaState();
}

class _LayarDaftarTugasPerformaState extends State<LayarDaftarTugasPerforma> {
  final TextEditingController _pencarian = TextEditingController();
  late final List<TugasPerforma> _semuaTugas =
      widget.sumber ?? buatTugasContoh();
  KriteriaFilter _kriteria = const KriteriaFilter();
  late List<TugasPerforma> _hasil = _semuaTugas;

  void _terapkan(KriteriaFilter kriteria) {
    setState(() {
      _kriteria = kriteria;
      _hasil = saringTugas(_semuaTugas, kriteria);
    });
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Kuliah')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const ValueKey<String>('task-search'),
              controller: _pencarian,
              onChanged:
                  (String nilai) =>
                  _terapkan(_kriteria.salinDengan(kueri: nilai)),
              decoration: const InputDecoration(
                labelText: 'Cari tugas atau mata kuliah',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                _chipStatus('Semua', null),
                _chipStatus('Aktif', StatusTugas.aktif),
                _chipStatus('Selesai', StatusTugas.selesai),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              'Menampilkan ${_hasil.length} dari ${_semuaTugas.length} tugas',
              key: const ValueKey<String>('result-count'),
            ),
          ),
          Expanded(
            child:
            _hasil.isEmpty
                ? const Center(child: Text('Tidak ada tugas yang cocok.'))
                : ListView.builder(
              key: const ValueKey<String>('task-list'),
              itemCount: _hasil.length,
              itemBuilder:
                  (BuildContext context, int index) =>
                  KartuTugasPerforma(tugas: _hasil[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipStatus(String label, StatusTugas? status) => FilterChip(
    label: Text(label),
    selected: _kriteria.status == status,
    onSelected:
        (_) => _terapkan(
      status == null
          ? _kriteria.salinDengan(hapusStatus: true)
          : _kriteria.salinDengan(status: status),
    ),
  );
}