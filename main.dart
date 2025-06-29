import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AnchaDubPlayer());
}

class AnchaDubPlayer extends StatelessWidget {
  const AnchaDubPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ancha Dub Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}
