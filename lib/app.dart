import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';
import 'splash_screen.dart';
import 'addhabit_screen.dart';

void main() {
  runApp(const ProgresslyApp());
}

class ProgresslyApp extends StatelessWidget {
  const ProgresslyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Progressly',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
    routes: {
    '/': (context) => SplashScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/home': (context) => const HomeScreen(),
    '/settings': (context) => Placeholder(),
    '/streak': (context) => Placeholder(),
    '/profile': (context) => Placeholder(),
    '/new_habit': (context) => AddHabitScreen(), // Add this line

    },
    );
  }
}
