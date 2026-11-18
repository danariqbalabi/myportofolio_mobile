import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> tapSave(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Save'));
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Drawer mengganti halaman dan menutup menu navigasi', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(ProjectFormPage))).canPop(),
      isFalse,
    );
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(MyHomePage))).canPop(),
      isFalse,
    );
  });

  testWidgets('Nama dan deskripsi wajib diisi termasuk input spasi', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.enterText(find.byType(TextFormField).at(1), '   ');
    await tapSave(tester);

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Dialog memuat semua input lalu reset field dan kategori', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Portofolio Mobile',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Aplikasi portofolio pribadi',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter, Django');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com',
    );
    await tapSave(tester);

    for (final text in [
      'Proyek berhasil ditambahkan!',
      'Nama Proyek: Portofolio Mobile',
      'Deskripsi: Aplikasi portofolio pribadi',
      'Kategori: Mobile Development',
      'Teknologi: Flutter, Django',
      'Tautan: https://example.com',
    ]) {
      expect(find.text(text), findsOneWidget);
    }

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
    final category = tester.state<FormFieldState<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(category.value, 'Web Development');

    await tester.enterText(find.byType(TextFormField).at(0), 'Proyek Kedua');
    await tester.enterText(find.byType(TextFormField).at(1), 'Deskripsi kedua');
    await tapSave(tester);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Django'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Menutup dialog lewat back mempertahankan isian', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.enterText(find.byType(TextFormField).at(0), 'Belum direset');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Deskripsi proyek',
    );
    await tapSave(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Belum direset'), findsOneWidget);
    await tapSave(tester);
    expect(find.text('Nama Proyek: Belum direset'), findsOneWidget);
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets('Form bisa digulir dan disubmit di layar $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
      await tester.enterText(find.byType(TextFormField).at(0), 'Proyek');
      await tester.enterText(find.byType(TextFormField).at(1), 'Deskripsi');
      await tapSave(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.ensureVisible(find.text('OK'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
