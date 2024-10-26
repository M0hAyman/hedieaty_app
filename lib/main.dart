import 'package:flutter/material.dart';
import 'package:hedieaty_app/CustomWidgets/gradient_container.dart';
import 'package:hedieaty_app/login_page.dart';

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
    return const MaterialApp(
      title: 'Friends & Events',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: GradientContainer(colors, LoginPage()), //LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
