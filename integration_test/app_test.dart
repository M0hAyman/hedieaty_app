import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login and Navigate to Profile Page Test', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Wait for the "Login" text to appear with a timeout
    const timeout = Duration(seconds: 10);
    final endTime = DateTime.now().add(timeout);

    while (find.text('Login').evaluate().isEmpty) {
      await tester.pump();
      if (DateTime.now().isAfter(endTime)) {
        throw TestFailure('Login page not found within $timeout');
      }
    }

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

    // Wait for Main Navigation Bar to appear
    final navBarTimeout = Duration(seconds: 10);
    final navBarEndTime = DateTime.now().add(navBarTimeout);

    while (find.byType(BottomNavigationBar).evaluate().isEmpty) {
      await tester.pump();
      if (DateTime.now().isAfter(navBarEndTime)) {
        throw TestFailure('Main Navigation Bar not found within $navBarTimeout');
      }
    }

    // Verify that Main Navigation Bar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap on the Profile tab in the Bottom Navigation Bar
    final profileTab = find.byIcon(Icons.person);
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    // Verify that the Profile Page is displayed
    final profileTimeout = Duration(seconds: 10);
    final profileEndTime = DateTime.now().add(profileTimeout);

    while (find.text('Profile').evaluate().isEmpty) {
      await tester.pump();
      if (DateTime.now().isAfter(profileEndTime)) {
        throw TestFailure('Profile Page not found within $profileTimeout');
      }
    }

    expect(find.text('Profile'), findsOneWidget); // Adjust text as per your Profile Page
  });
}
