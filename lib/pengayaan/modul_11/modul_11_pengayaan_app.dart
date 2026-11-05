import 'package:flutter/material.dart';

import 'data/sumber_tugas_berhalaman.dart';
import 'presentation/pengendali_halaman.dart';
import 'screens/daftar_berhalaman_screen.dart';

/// Composition root Modul 11 Fase B — pagination.
///
/// Halaman 3 sengaja gagal sekali agar state galat dan "Coba lagi" dapat
/// diamati. Pengendali dibuat sekali dan dibuang bersama widget ini.
class Modul11PengayaanApp extends StatefulWidget {
  const Modul11PengayaanApp({super.key});

  @override
  State<Modul11PengayaanApp> createState() => _Modul11PengayaanAppState();
}

class _Modul11PengayaanAppState extends State<Modul11PengayaanApp> {
  late final PengendaliHalaman _pengendali = PengendaliHalaman(
    SumberTugasSimulasi(gagalPadaHalaman: const <int>{3}),
  );

  @override
  void dispose() {
    _pengendali.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Modul 11 Fase B — Pagination',
    theme: ThemeData(
      colorSchemeSeed: const Color(0xFF0E7490),
      useMaterial3: true,
    ),
    home: LayarDaftarBerhalaman(pengendali: _pengendali),
  );
}