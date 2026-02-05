import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_ecg_app/app/app.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppRoot(),
      ),
    );

    expect(find.text('Smart ECG App'), findsOneWidget);
  });
}
