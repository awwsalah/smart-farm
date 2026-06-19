import 'package:app/app.dart';
import 'package:app/config/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bottom nav shows Somali tab labels', (WidgetTester tester) async {
    await tester.pumpWidget(const BeeralayApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.navHome), findsOneWidget);
    expect(find.text(AppStrings.navResources), findsOneWidget);
    expect(find.text(AppStrings.navNews), findsOneWidget);
    expect(find.text(AppStrings.navMarket), findsOneWidget);
  });
}