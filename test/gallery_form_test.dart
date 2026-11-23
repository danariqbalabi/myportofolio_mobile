import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/gallery_form.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

Future<void> saveGallery(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Simpan'));
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Drawer membuka Gallery dari Home dan form proyek', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Tambah Foto Gallery'));
    await tester.pumpAndSettle();
    expect(find.byType(GalleryFormPage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(GalleryFormPage))).canPop(),
      isFalse,
    );
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Tambah Foto Gallery'));
    await tester.pumpAndSettle();
    expect(find.byType(GalleryFormPage), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(MyHomePage))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets(
      'Kartu Gallery membuka form dan Back kembali ke Home di $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(const MyApp());
        final card = find.widgetWithText(ItemCard, 'Tambah Foto Gallery');
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pumpAndSettle();
        expect(find.byType(GalleryFormPage), findsOneWidget);
        expect(
          Navigator.of(tester.element(find.byType(GalleryFormPage))).canPop(),
          isTrue,
        );
        expect(
          find.text('Kamu telah menekan tombol Tambah Foto Gallery!'),
          findsOneWidget,
        );
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(MyHomePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Form menolak input wajib kosong atau spasi', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GalleryFormPage()));
    for (var index = 0; index < 3; index++) {
      await tester.enterText(find.byType(TextFormField).at(index), '   ');
    }
    await saveGallery(tester);
    expect(find.text('Judul wajib diisi.'), findsOneWidget);
    expect(find.text('Tahun wajib diisi.'), findsOneWidget);
    expect(find.text('Gambar wajib diisi.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Validator memeriksa panjang tahun dan format gambar', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GalleryFormPage()));
    final fields = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .toList();
    expect(fields[0].validator!('a' * 255), isNull);
    expect(fields[0].validator!('a' * 256), isNotNull);
    for (final year in ['abc', '2026.5', '-2000', '1999', '2101']) {
      expect(fields[1].validator!(year), isNotNull, reason: year);
    }
    for (final year in ['2000', '2026', '2100']) {
      expect(fields[1].validator!(year), isNull);
    }
    for (final image in [
      'https://example.com/foto.jpg',
      'http://example.com/image?id=1',
      '/static/img/foto.jpg',
      'https://example.com/${'a' * 480}',
    ]) {
      expect(fields[2].validator!(image), isNull, reason: image);
    }
    for (final image in [
      'https://',
      'javascript:alert(1)',
      'file:///foto.jpg',
      'foto.jpg',
      '/static/img/',
      '/static/img/../secret.jpg',
      '/static/img/%2e%2e/secret.jpg',
      'https://example.com/foto saya.jpg',
      'https://example.com/${'a' * 481}',
    ]) {
      expect(fields[2].validator!(image), isNotNull, reason: image);
    }
    expect(fields[4].validator!(''), isNull);
    expect(fields[4].validator!('a' * 100), isNull);
    expect(fields[4].validator!('a' * 101), isNotNull);
    expect(fields[5].validator!(''), isNull);
    expect(fields[5].validator!('a' * 255), isNull);
    expect(fields[5].validator!('a' * 256), isNotNull);
  });

  testWidgets('Dialog menampilkan semua isian dan OK kembali ke form', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GalleryFormPage()));
    final values = [
      ' Foto kampus ',
      '2026',
      '/static/img/kampus.jpg',
      'Momen sore',
      'Kampus',
      'Depok',
    ];
    for (var index = 0; index < values.length; index++) {
      await tester.enterText(
        find.byType(TextFormField).at(index),
        values[index],
      );
    }
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await saveGallery(tester);
    for (final text in [
      'Judul: Foto kampus',
      'Tahun: 2026',
      'Gambar: /static/img/kampus.jpg',
      'Caption: Momen sore',
      'Kategori: Kampus',
      'Lokasi: Depok',
      'Featured: Ya',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(GalleryFormPage), findsOneWidget);
    expect(find.text(' Foto kampus '), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Foto baru');
    await saveGallery(tester);
    expect(find.text('Judul: Foto baru'), findsOneWidget);
    expect(find.text('Judul: Foto kampus'), findsNothing);
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets('Form bisa disimpan saat keyboard muncul di $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 120);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpWidget(const MaterialApp(home: GalleryFormPage()));
      await tester.enterText(find.byType(TextFormField).at(0), 'Foto');
      await tester.enterText(find.byType(TextFormField).at(1), '2000');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'https://example.com/foto',
      );
      await saveGallery(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Featured: Tidak'), findsOneWidget);
      await tester.ensureVisible(find.text('OK'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
