import 'package:flutter/material.dart';

import '../domain/tugas_performa.dart';

/// Kartu satu tugas. Bagian yang tidak bergantung pada data memakai
/// `const` karena nilainya memang konstan.
class KartuTugasPerforma extends StatelessWidget {
  const KartuTugasPerforma({required this.tugas, super.key});

  final TugasPerforma tugas;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey<String>('task-card-${tugas.nomor}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.assignment_outlined)),
        title: Text(tugas.judul),
        subtitle: Text(tugas.mataKuliah),
        trailing: Text(tugas.selesai ? 'Selesai' : 'Aktif'),
      ),
    );
  }
}