import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_edtech/main.dart';

void main() {
  testWidgets('App initializes and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FlowApp()));
    await tester.pumpAndSettle();

    // Verify that login screen is shown
    expect(find.text('Flow'), findsOneWidget);
  });
}
