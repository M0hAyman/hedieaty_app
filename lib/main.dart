import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/gradient_container.dart';
//import 'package:hedieaty_app/home_page.dart';
import 'package:hedieaty_app/Pages/login_page.dart';

void main() {
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
        // I will add ither routes when I need them
      },
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const GradientContainer(colors, LoginPage()), //LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
