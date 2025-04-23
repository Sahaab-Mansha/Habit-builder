
// screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _goToSettings() {
      Navigator.pushNamed(context, '/settings');
    }

    void _goToStreak() {
      Navigator.pushNamed(context, '/streak');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE1F5DA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'images/logo_2.png',
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department_rounded, color: Colors.orange),
            onPressed: _goToStreak,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: _goToSettings,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("RECENT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  HabitChip(text: "Sleeping Early 🛌"),
                  SizedBox(width: 8),
                  HabitChip(text: "Basketball 🏀"),
                  SizedBox(width: 8),
                  HabitChip(text: "Cooking 🍽️"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("DISCOVER NEW", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: const [
                  HabitChip(text: "Cleaning 🧹"),
                  HabitChip(text: "Reading 📖"),
                  HabitChip(text: "Dancing 💃"),
                  HabitChip(text: "Sketching ✏️"),
                  HabitChip(text: "Coding 👨‍💻"),
                  HabitChip(text: "Writing 🗘️"),
                  HabitChip(text: "Exercise 💪"),
                  HabitChip(text: "Gaming 🎮"),
                  HabitChip(text: "Darts 🎯"),
                  HabitChip(text: "Studying 📚"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitChip extends StatelessWidget {
  final String text;
  const HabitChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB0D0E7),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
