import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_pcto/main.dart';

void main() {
  testWidgets('shows mocked login flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Log in to TikTok'), findsOneWidget);
    expect(find.text('Use phone / email / username'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
