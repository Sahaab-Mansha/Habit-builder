import 'package:flutter/material.dart';
import 'package:habit_builder/settings.dart';
import 'package:habit_builder/streak.dart';
import 'package:habit_builder/Taskpage.dart';
import 'package:habit_builder/addhabit.dart';
import 'package:habit_builder/UserHabitsService.dart'; // Where getHabitNames() is defined

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen(this.userId, {super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> habitNames = [];
  bool isLoading = true;
  List<String> habitEmojis = [];
  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final names = await getHabitNames(widget.userId);
    final emojis = await getEmojiList(widget.userId);
    print("Eojis: $emojis");
    setState(() {
      habitNames = names;
      habitEmojis = emojis;
      isLoading = false;
    });
  }
  void gotoaddHabit() {
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddHabitScreen(widget.userId)),
    );
  }
  void _goToSettings(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage(widget.userId)),
      );

  void _goToStreak(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Streak(widget.userId)),
      );

  void _goToHabit(int index, String habitName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(widget.userId, habitName: habitName, index: index)),
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
          children: [
            Image.asset('assets/logo.png', height: 40),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department_rounded,
                color: Colors.orange),
            onPressed: () => _goToStreak(context),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () => _goToSettings(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MY HABITS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
        onPressed: () => gotoaddHabit(),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Column(
        children: [
          if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 50)),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
