import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_app/main.dart' as app;

void main() {
  // Register the Integration Test driver
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login and Navigate to Profile Page Test', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Verify Login Page is displayed
    expect(find.text('Login'), findsOneWidget);

    // Input email
    final emailField = find.byType(TextField).at(0); // Assuming first TextField is Email
    await tester.enterText(emailField, 'b@gmail.com');

    // Input password
    final passwordField = find.byType(TextField).at(1); // Assuming second TextField is Password
    await tester.enterText(passwordField, 'mohamed12');

    // Tap the Login button
    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify that Main Navigation Bar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap on the Profile tab in the Bottom Navigation Bar
    final profileTab = find.byIcon(Icons.person);
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    // Verify that the Profile Page is displayed
    expect(find.text('Profile'), findsOneWidget); // Adjust text as per your Profile Page
  });
}
