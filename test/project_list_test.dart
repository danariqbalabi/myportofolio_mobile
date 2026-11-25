import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('Daftar gagal bisa dicoba lagi lalu membuka detail', (
    tester,
  ) async {
    var requests = 0;
    final api = ApiClient(
      client: MockClient((_) async {
        requests++;
        if (requests == 1) return http.Response('private traceback', 500);
        return http.Response(
          '[{"id":"uuid","title":"Proyek asli","description":"Deskripsi API","tech_stack":"Django","project_url":"https://example.com"}]',
          200,
        );
      }),
    );
    await tester.pumpWidget(
      testApp(home: const ProjectListScreen(), token: null, api: api),
    );
    await tester.pumpAndSettle();
    expect(find.text('Coba Lagi'), findsOneWidget);
    expect(find.textContaining('traceback'), findsNothing);
    await tester.tap(find.text('Coba Lagi'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    await tester.tap(find.text('Proyek asli'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('Tech Stack: Django'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
