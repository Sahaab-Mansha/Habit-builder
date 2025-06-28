import 'package:flutter/material.dart';
import 'package:habit_builder/settings.dart';
import 'package:habit_builder/streak.dart';
import 'package:habit_builder/Taskpage.dart';
import 'package:habit_builder/addhabit.dart';
import 'package:habit_builder/UserHabitsService.dart';
import 'profile.dart';
import 'grid.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen(this.userId, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> habitNames = [];
  List<String> habitEmojis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final names = await getHabitNames(widget.userId);
    final emojis = await getEmojiList(widget.userId);
    setState(() {
      habitNames = names;
      habitEmojis = emojis;
      isLoading = false;
    });
  }

  void _goToAddHabit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddHabitScreen(widget.userId)),
    );
  }

  void _goToSettings() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen(userId: widget.userId)),
    );
  }

  void _goToStreak() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Streak(widget.userId)),
    );
  }

  void _goToHabit(int index, String habitName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HabitCalendarScreen(userId: widget.userId, index: index),
      ),
    );
  }

  void _goToProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5DA),
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: SizedBox(
          height: 40,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.local_fire_department_rounded, color: Colors.orange),
            onPressed: _goToStreak,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black87),
            onPressed: _goToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: _goToSettings,
          ),
        ],
      ),
    ],
  ),
),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("HABITS",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const BouncingScrollPhysics(),
                      children: habitNames.asMap().entries.map((entry) {
                        final index = entry.key;
                        final name = entry.value;
                        return HabitChip(
                          text: name,
                          emoji: habitEmojis.isNotEmpty ? habitEmojis[index] : null,
                          onTap: () => _goToHabit(index, name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddHabit,
        backgroundColor: const Color(0xFFF9E0E3),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HabitChip extends StatelessWidget {
  final String text;
  final String? emoji;
  final VoidCallback? onTap;

  const HabitChip({
    super.key,
    required this.text,
    this.emoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB0D0E7),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (emoji != null)
            Text(
              emoji!,
              style: const TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
