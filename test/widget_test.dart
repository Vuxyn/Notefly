import 'package:flutter_test/flutter_test.dart';

import 'package:notefly/app.dart';

void main() {
  testWidgets('App renders HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // HomeScreen shows the app name and tagline.
    expect(find.text('Notefly'), findsOneWidget);
    expect(
      find.text('Quick notes, always on top'),
      findsOneWidget,
    );
  });
}
