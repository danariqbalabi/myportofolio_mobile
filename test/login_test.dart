import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Login gagal lalu berhasil melanjutkan ke form yang dilindungi', (
    tester,
  ) async {
    var attempts = 0;
    final api = ApiClient(
      client: MockClient((request) async {
        attempts++;
        return attempts == 1
            ? http.Response('{"non_field_errors":["bad credentials"]}', 400)
            : http.Response('{"token":"session-token"}', 200);
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: api));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(attempts, 0);
    expect(find.text('Username wajib diisi.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Username atau password salah (400).'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(attempts, 2);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Logout'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Login'), findsNothing);
  });
}
