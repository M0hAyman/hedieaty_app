import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty_app/Pages/AddEditGiftPage.dart';
import 'package:hedieaty_app/Pages/gift_list_page.dart';
//import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
//import 'package:hedieaty_app/main.dart' as app;


import 'package:mockito/mockito.dart';
import 'package:hedieaty_app/Data/firebase/services/gift_firestore_service.dart';
import 'package:hedieaty_app/Data/local_database/services/gift_service.dart';


// Mock dependencies
class MockGiftService extends Mock implements GiftService {}

class MockGiftFirestoreService extends Mock implements GiftFirestoreService {}

void main() {
  late MockGiftService mockGiftService;
  //late MockGiftFirestoreService mockFirestoreService;

  setUp(() {
    mockGiftService = MockGiftService();
    //mockFirestoreService = MockGiftFirestoreService();
  });

  Widget createTestWidget({required GiftListPage giftListPage}) {
    return MaterialApp(
      home: giftListPage,
    );
  }

  group('GiftListPage', () {
    const testUserId = 'test_user_1';
    const testEventId = 123;
    const testFirebaseEventId = 'test_event_123';

    testWidgets('displays empty message when there are no gifts',
            (WidgetTester tester) async {
          // Arrange: Mock empty local database response
          when(mockGiftService.getGiftsByEventId('1' as int))
              .thenAnswer((_) async => []);

          await tester.pumpWidget(createTestWidget(
            giftListPage: GiftListPage(
              eventId: testEventId,
              firebaseEventId: testFirebaseEventId,
              userId: testUserId,
            ),
          ));

          // Act: Wait for widgets to build
          await tester.pump();

          // Assert: Verify the empty message is displayed
          expect(find.text('No gifts added for this event.'), findsOneWidget);
        });

    testWidgets('displays gifts when fetched from local database',
            (WidgetTester tester) async {
          // Arrange: Mock local database response with sample gifts
          when(mockGiftService.getGiftsByEventId('1' as int)).thenAnswer(
                (_) async => [
              {
                'ID': 1,
                'NAME': 'Sample Gift 1',
                'CATEGORY': 'Toys',
                'IS_PLEDGED': 0,
                'GIFT_FIREBASE_ID': null,
                'USER_ID': testUserId,
              },
            ],
          );

          await tester.pumpWidget(createTestWidget(
            giftListPage: GiftListPage(
              eventId: testEventId,
              firebaseEventId: testFirebaseEventId,
              userId: testUserId,
            ),
          ));

          // Act: Wait for widgets to build
          await tester.pump();

          // Assert: Verify that the gift is displayed
          expect(find.text('Sample Gift 1'), findsOneWidget);
          expect(find.text('Category: Toys'), findsOneWidget);
        });

    testWidgets('navigates to AddEditGiftPage when add button is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget(
            giftListPage: GiftListPage(
              eventId: testEventId,
              firebaseEventId: testFirebaseEventId,
              userId: testUserId,
            ),
          ));

          // Act: Tap on the add button
          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();

          // Assert: Verify navigation to AddEditGiftPage
          expect(find.byType(AddEditGiftPage), findsOneWidget);
        });

    testWidgets('deletes a gift when delete button is pressed',
            (WidgetTester tester) async {
          // Arrange: Mock local database response with a sample gift
          when(mockGiftService.getGiftsByEventId('1' as int)).thenAnswer(
                (_) async => [
              {
                'ID': 1,
                'NAME': 'Sample Gift 1',
                'CATEGORY': 'Toys',
                'IS_PLEDGED': 0,
                'GIFT_FIREBASE_ID': null,
                'USER_ID': testUserId,
              },
            ],
          );


          await tester.pumpWidget(createTestWidget(
            giftListPage: GiftListPage(
              eventId: testEventId,
              firebaseEventId: testFirebaseEventId,
              userId: testUserId,
            ),
          ));

          // Act: Tap the delete button for the gift
          await tester.pump();
          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();

          // Assert: Verify the deleteGift method was called
          verify(mockGiftService.deleteGift(1)).called(1);
        });

    testWidgets('publishes a gift to Firestore when upload button is pressed',
            (WidgetTester tester) async {
          // Arrange: Mock local database response with a gift
          when(mockGiftService.getGiftsByEventId('1' as int)).thenAnswer(
                (_) async => [
              {
                'ID': 1,
                'NAME': 'Sample Gift 1',
                'CATEGORY': 'Toys',
                'IS_PLEDGED': 0,
                'GIFT_FIREBASE_ID': null,
                'USER_ID': testUserId,
              },
            ],
          );


          await tester.pumpWidget(createTestWidget(
            giftListPage: GiftListPage(
              eventId: testEventId,
              firebaseEventId: testFirebaseEventId,
              userId: testUserId,
            ),
          ));

          // Act: Tap the publish button for the gift
          await tester.pump();
          await tester.tap(find.byIcon(Icons.cloud_upload));
          await tester.pumpAndSettle();

        });
  });
}
