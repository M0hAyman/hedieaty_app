import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/gradient_container.dart';
//import 'package:hedieaty_app/home_page.dart';
import 'package:hedieaty_app/Pages/login_page.dart';

import 'Data/local_database/services/event_service.dart';
import 'Data/local_database/services/user_service.dart';
import 'firebase_options.dart';

// void main() async {
//   // // Ensure all Flutter bindings and initialization steps are complete
//   // WidgetsFlutterBinding.ensureInitialized();
//   //
//   //  final eventService = EventService();
//   //  await eventService.insertEvent({
//   //    'NAME': 'Birthday Party',
//   //    'DATE': '2022-12-25',
//   //    'LOCATION': '123 Main St, New York, NY',
//   //    'DESCRIPTION': 'Come celebrate my birthday!',
//   //    'USER_ID': 1
//   //  });
//   //  final event = await eventService.getEventsByUserId(1);
//   //  print(event);
//
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
