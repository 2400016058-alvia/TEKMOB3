import 'package:flutter_test/flutter_test.dart';
import 'package:sutta_app/main.dart';

void main() {
  testWidgets(
    'StudyDrop app loads correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(const StudyDropApp());

      expect(find.text('StudyDrop'), findsOneWidget);
    },
  );
}