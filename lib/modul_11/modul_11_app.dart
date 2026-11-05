import 'package:flutter/material.dart';

enum StatusTugas { aktif, selesai }

class TugasPerforma {
  const TugasPerforma({required this.nomor, required this.mataKuliah, required this.status});

  final int nomor;
  final String mataKuliah;
  final StatusTugas status;

  String get judul => 'Tugas praktikum ${nomor.toString().padLeft(4, '0')}';
}

class Modul11App extends StatelessWidget {
  const Modul11App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Modul 11 — Optimasi Daftar Tugas',
    theme: ThemeData(colorSchemeSeed: const Color(0xFF0E7490), useMaterial3: true),
    home: const LayarDaftarTugasPerforma(),
  );
}

class LayarDaftarTugasPerforma extends StatefulWidget {
  const LayarDaftarTugasPerforma({super.key});

  @override
  State<LayarDaftarTugasPerforma> createState() => _LayarDaftarTugasPerformaState();
}

class _LayarDaftarTugasPerformaState extends State<LayarDaftarTugasPerforma> {
  final TextEditingController _pencarian = TextEditingController();
  final List<TugasPerforma> _semuaTugas = List<TugasPerforma>.generate(
    1000,
        (index) => TugasPerforma(
      nomor: index + 1,
      mataKuliah: const [
        'Pemrograman Mobile',
        'Basis Data',
        'Jaringan Komputer',
        'Rekayasa Perangkat Lunak',
        'Sistem Operasi',
        'Kecerdasan Buatan',
        'Pemrograman Web',
        'Analisis dan Perancangan Sistem',
      ][index % 8],
      status: (index + 1) % 4 == 0 ? StatusTugas.selesai : StatusTugas.aktif,
    ),
  );
  StatusTugas? _filter;
  String _kueri = '';

  List<TugasPerforma> get _hasil {
    // Kueri cukup diubah ke huruf kecil sekali per build, bukan sekali per item.
    final kueri = _kueri.toLowerCase();
    return _semuaTugas.where((tugas) {
      final cocokStatus = _filter == null || tugas.status == _filter;
      final cocokTeks = '${tugas.judul} ${tugas.mataKuliah}'.toLowerCase().contains(kueri);
      return cocokStatus && cocokTeks;
    }).toList(growable: false);
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasil;
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Kuliah')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const ValueKey('task-search'),
              controller: _pencarian,
              onChanged: (value) => setState(() => _kueri = value),
              decoration: const InputDecoration(labelText: 'Cari tugas atau mata kuliah', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                _filterChip('Semua', null),
                _filterChip('Aktif', StatusTugas.aktif),
                _filterChip('Selesai', StatusTugas.selesai),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text('Menampilkan ${hasil.length} dari ${_semuaTugas.length} tugas', key: const ValueKey('result-count')),
          ),
          Expanded(
            child: hasil.isEmpty
                ? const Center(child: Text('Tidak ada tugas yang cocok.'))
                : ListView.builder(
              key: const ValueKey('task-list'),
              itemCount: hasil.length,
              itemBuilder: (context, index) => _KartuTugas(tugas: hasil[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, StatusTugas? status) => FilterChip(
    label: Text(label),
    selected: _filter == status,
    onSelected: (_) => setState(() => _filter = status),
  );
}

class _KartuTugas extends StatelessWidget {
  const _KartuTugas({required this.tugas});

  final TugasPerforma tugas;

  @override
  Widget build(BuildContext context) => Card(
    key: ValueKey('task-card-${tugas.nomor}'),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.assignment_outlined)),
      title: Text(tugas.judul),
      subtitle: Text(tugas.mataKuliah),
      trailing: Text(tugas.status == StatusTugas.selesai ? 'Selesai' : 'Aktif'),
    ),
  );
}
