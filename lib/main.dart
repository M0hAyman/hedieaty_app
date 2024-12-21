import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/gradient_container.dart';
//import 'package:hedieaty_app/home_page.dart';
import 'package:hedieaty_app/Pages/login_page.dart';

//For creating local DB for the first time and testing it
// import 'Data/local_database/services/gift_service.dart';
// import 'Data/local_database/mydatabase.dart';
// import 'Data/local_database/services/event_service.dart';
import 'firebase_options.dart';

// void main() async {
//   // Ensure all Flutter bindings and initialization steps are complete
//   WidgetsFlutterBinding.ensureInitialized();
//
//
//   final localDB = MyLocalDatabaseService();
//   await localDB.initialize();
//   await localDB.resetDatabase();
//    final eventService = EventService();
//    final giftService = GiftService();
//    await eventService.insertEvent({
//      'EVENT_FIREBASE_ID': 'AnyFiReBaseId1',
//      'NAME': 'Birthday Party Test 1',
//      'CATEGORY': 'Birthday',
//      'DESCRIPTION': 'Come celebrate my birthday!',
//      'DATE': '2022-12-25',
//      'LOCATION': '123 Main St, New York, NY',
//      'USER_ID': 'dyYryYryYsw'
//
//    });
//
//    await giftService.insertGift({
//      'GIFT_FIREBASE_ID': 'AnyFiReBaseId1',
//      'NAME': 'Gift 1',
//      'DESCRIPTION': 'Gift 1 description',
//      'CATEGORY': 'Gift',
//      'PRICE': 50.00,
//      'IMG_URL': 'https://via.placeholder.com/150',
//      'PLEDGED_BY': 'John Doe',
//      'USER_ID': 'dyYryYryYsw',
//      'EVENT_ID': 1
//    });
//
//    //final event = await eventService.getEventsByUserId(1);
//    //print(event);
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // Run the application
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


const List<Color> colors = [
  // Color.fromARGB(255, 0, 243, 16),
  // Color.fromARGB(255, 74, 153, 0),
  Color.fromARGB(255, 60, 2, 101),
  Colors.deepPurple,
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends & Events',
      initialRoute: '/', // Define the initial route if needed
      routes: {
        //'/': (context) => const HomePage(), // Home screen route
        '/login': (context) => const LoginPage(), // Login screen route
        // I will add other routes when I need them
      },
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const GradientContainer(colors, LoginPage()), //LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
