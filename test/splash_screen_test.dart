import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadaqa_app/features/splash/presentation/views/spash_screen_view.dart';

void main() {
  testWidgets('SplashScreen shows logo image', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreenView()));

    expect(find.byType(Image), findsOneWidget);
  });
}
