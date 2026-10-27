import 'package:flutter_test/flutter_test.dart';
import 'package:campuspilot/main.dart';

void main() {
  testWidgets('CampusPilot app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusPilotApp());

    expect(find.text('CampusPilot'), findsOneWidget);
    expect(find.text('Your overview'), findsOneWidget);
  });
}
