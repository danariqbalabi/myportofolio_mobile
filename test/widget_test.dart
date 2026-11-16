import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Setiap tombol punya warna berbeda dengan teks yang kontras', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final cards = tester.widgetList<ItemCard>(find.byType(ItemCard)).toList();

    expect(cards.length, 3);
    expect(cards.map((card) => card.item.color).toSet().length, 3);
    for (final card in cards) {
      final material = tester.widget<Material>(
        find.descendant(
          of: find.widgetWithText(ItemCard, card.item.name),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, card.item.color);
      final contrast = 1.05 / (card.item.color.computeLuminance() + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5));
    }
  });

  testWidgets('Home displays the tutorial profile and all menu actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (final text in [
      'MyPortfolio',
      'NPM',
      '2406000001',
      'Name',
      'Burhan',
      'Class',
      'PBP A',
      'Selamat datang di MyPortfolio Mobile!',
      'Lihat Proyek',
      'Tambah Proyek',
      'Logout',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Each menu action displays its matching SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (final action in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $action!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets('Menu fits and remains usable at $size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      await tester.ensureVisible(find.text('Tambah Proyek'));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();

      expect(
        find.text('Kamu telah menekan tombol Tambah Proyek!'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
