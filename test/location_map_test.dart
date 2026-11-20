import 'package:dibuang_sayang_mobile/config.dart';
import 'package:dibuang_sayang_mobile/features/location_map/location_map_page.dart';
import 'package:dibuang_sayang_mobile/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// Tab awal Pesanan tetap bisa diuji tanpa koneksi backend.
class _LocalRequest extends CookieRequest {
  final requestedUrls = <String>[];

  @override
  Future<dynamic> get(String url) async {
    requestedUrls.add(url);
    return [];
  }
}

Future<_LocalRequest> _openMap(
  WidgetTester tester, {
  double textScale = 1,
}) async {
  final request = _LocalRequest();
  await tester.pumpWidget(
    Provider<CookieRequest>.value(
      value: request,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kGreen,
            secondary: kOrange,
          ),
          scaffoldBackgroundColor: kBackground,
          useMaterial3: true,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: const HomePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Peta'));
  await tester.pumpAndSettle();
  return request;
}

void main() {
  testWidgets('Peta uses the existing navigation without fetching map data',
      (tester) async {
    final request = await _openMap(tester);

    expect(find.byType(LocationMapPage), findsOneWidget);
    expect(find.text('Peta Restoran'), findsOneWidget);
    expect(find.text('Senopati, Jakarta Selatan'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(request.requestedUrls, ['$baseUrl/api/order/orders/']);

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Food & Restaurant'), findsOneWidget);

    await tester.tap(find.text('Ulasan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lihat Pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pesanan.'), findsOneWidget);

    await tester.tap(find.text('Peta'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationMapPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Search and categories update locally with the keyboard open',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    final request = await _openMap(tester);

    await tester.enterText(find.byType(TextField), 'roti');
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    await tester.pumpAndSettle();
    expect(find.text('roti'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text, '');

    tester.view.resetViewInsets();
    tester.testTextInput.hide();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final bentoChip = find.widgetWithText(ChoiceChip, 'Bento & box');
    await tester.ensureVisible(bentoChip);
    await tester.pumpAndSettle();
    await tester.tap(bentoChip);
    await tester.pump();
    expect(tester.widget<ChoiceChip>(bentoChip).selected, isTrue);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Semua'))
          .selected,
      isFalse,
    );
    expect(find.byType(Card), findsNWidgets(3));
    expect(request.requestedUrls, ['$baseUrl/api/order/orders/']);
    expect(tester.takeException(), isNull);
  });

  for (final layout in [
    (size: const Size(320, 568), textScale: 1.0),
    (size: const Size(320, 568), textScale: 2.0),
    (size: const Size(568, 320), textScale: 1.0),
  ]) {
    testWidgets(
        'Map remains scrollable at ${layout.size}, text scale ${layout.textScale}',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = layout.size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await _openMap(tester, textScale: layout.textScale);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Peta segera hadir'));
      await tester.pumpAndSettle();
      expect(find.text('Peta segera hadir').hitTestable(), findsOneWidget);

      await tester.ensureVisible(
        find.text('Jl. Wolter Monginsidi No. 24, Jakarta Selatan'),
      );
      await tester.pumpAndSettle();
      expect(
        find
            .text('Jl. Wolter Monginsidi No. 24, Jakarta Selatan')
            .hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
