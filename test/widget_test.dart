
import 'package:flutter_test/flutter_test.dart';
import 'package:dibuang_sayang_mobile/main.dart';

void main() {
  testWidgets('Application renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that the application renders its root widget.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
