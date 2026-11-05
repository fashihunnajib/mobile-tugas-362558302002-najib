import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poliwangi_mobile_starter/modul_11/modul_11_app.dart';

void main() {
  testWidgets('daftar memakai builder dan tidak membuat seribu kartu sekaligus', (tester) async {
    await tester.pumpWidget(const Modul11App());
    expect(find.text('Menampilkan 1000 dari 1000 tugas'), findsOneWidget);
    expect(find.byKey(const ValueKey('task-card-1')), findsOneWidget);
    expect(find.byType(Card).evaluate().length, lessThan(1000));
  });

  testWidgets('pencarian membatasi daftar tanpa mengubah sumber data', (tester) async {
    await tester.pumpWidget(const Modul11App());
    await tester.enterText(find.byKey(const ValueKey('task-search')), 'tugas praktikum 0002');
    await tester.pump();
    expect(find.text('Menampilkan 1 dari 1000 tugas'), findsOneWidget);
    expect(find.text('Tugas praktikum 0002'), findsOneWidget);
  });

  testWidgets('filter status menampilkan hanya tugas selesai', (tester) async {
    await tester.pumpWidget(const Modul11App());
    await tester.tap(find.widgetWithText(FilterChip, 'Selesai'));
    await tester.pump();
    expect(find.text('Menampilkan 250 dari 1000 tugas'), findsOneWidget);
    expect(find.text('Tugas praktikum 0004'), findsOneWidget);
  });
}