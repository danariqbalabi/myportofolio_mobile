import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';

import 'support/test_app.dart';

Future<void> fillProject(WidgetTester tester) async {
  final values = [
    'Portofolio',
    'Deskripsi proyek',
    'Flutter, Django',
    'https://example.com',
    '',
  ];
  for (var i = 0; i < values.length; i++) {
    await tester.enterText(find.byType(TextFormField).at(i), values[i]);
  }
}

Future<void> save(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Save'));
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Input wajib dan format URL divalidasi sebelum POST', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(home: const ProjectFormPage()));
    await save(tester);
    expect(find.text('Title wajib diisi.'), findsOneWidget);
    expect(find.text('Description wajib diisi.'), findsOneWidget);
    expect(find.text('Tech Stack wajib diisi.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await fillProject(tester);
    await tester.enterText(find.byType(TextFormField).at(3), 'bukan-url');
    await save(tester);
    expect(find.text('Masukkan URL http/https yang valid.'), findsOneWidget);
  });
  testWidgets('POST berhasil menampilkan data server dan OK mereset form', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(home: const ProjectFormPage()));
    await fillProject(tester);
    await save(tester);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Title: Portofolio'), findsOneWidget);
    expect(find.text('Tech Stack: Flutter, Django'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
  });
  testWidgets('401 meminta login ulang dan mempertahankan isian', (
    tester,
  ) async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response('{}', 401)),
    );
    await tester.pumpWidget(testApp(home: const ProjectFormPage(), api: api));
    await fillProject(tester);
    await save(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Portofolio'), findsOneWidget);
  });
  testWidgets('Aksi tambah proyek meminta login dan bisa dibatalkan', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(token: null));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsNothing);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
  testWidgets('403 menampilkan pesan izin tanpa dialog sukses', (tester) async {
    final api = ApiClient(
      client: MockClient(
        (_) async => http.Response('<html>private error</html>', 403),
      ),
    );
    await tester.pumpWidget(testApp(home: const ProjectFormPage(), api: api));
    await fillProject(tester);
    await save(tester);
    expect(
      find.text('Akun ini tidak memiliki izin untuk mengubah proyek.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.textContaining('private error'), findsNothing);
  });
}
