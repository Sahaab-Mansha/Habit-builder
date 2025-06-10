import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'UserService.dart';
import 'main_page.dart';
import 'Taskpage.dart';
import 'UserHabitsService.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures plugin services are available
  await initIsar();// initialize Isar DB for habits
  runApp(MyApp()); // launch the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Builder',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Initial screen
    );
  }
}
