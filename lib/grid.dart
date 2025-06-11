import 'package:flutter/material.dart';
import 'UserHabitsService.dart';
import 'Taskpage.dart';
import 'main_page.dart';
class HabitCalendarScreen extends StatelessWidget {
  const HabitCalendarScreen({super.key, required this.userId, required this.index});
  final String userId;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7F5), // light blue
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: const Color(0xFFECC7CE), // pink
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(userId)),
          ),
        ),
      ),
      body: HabitCalendarGrid(userId: userId, index: index),
    );
  }
}

class HabitCalendarGrid extends StatefulWidget {
  const HabitCalendarGrid({super.key, required this.userId, required this.index});
  final String userId;
  final int index;

  @override
  State<HabitCalendarGrid> createState() => _HabitCalendarGridState();
}

class _HabitCalendarGridState extends State<HabitCalendarGrid> {
  int totalTasks = 0;
  int currentTaskIndex = 0;
  String habitName = '';
  String habitEmoji = '';

  @override
  void initState() {
    super.initState();
    _loadTaskInfo();
  }

  Future<void> _loadTaskInfo() async {
    final noTasks = await no_of_tasks(widget.userId, widget.index);
    final idx = await getIndex(widget.userId, widget.index);
    final name = await GetHabitName(widget.userId, widget.index);
    final emoji = await getEmoji(widget.userId, widget.index);
    setState(() {
      totalTasks = noTasks;
      currentTaskIndex = idx;
      habitName = name;
      habitEmoji = emoji;
    });
  }

  Future<void> resetHabitProgress(String userId, int index) async {
    await ResetHabit(userId, index); // Implement this in UserHabitsService.dart
  }

  @override
  Widget build(BuildContext context) {
    return totalTasks == 0
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0D0E7),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black87, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$habitName $habitEmoji',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: totalTasks,
                      itemBuilder: (context, i) {
                        return FutureBuilder<String?>(
                          future: getTask(widget.userId, widget.index),
                          builder: (context, snapshot) {
                            final task = snapshot.data;
                            Color color;

                            if (i < currentTaskIndex) {
                              color = const Color(0xFFE1F5DA); // Greenish
                            } else if (i == currentTaskIndex) {
                              color = (snapshot.hasData && task != null)
                                  ? const Color(0xFFB0C4DE) // Blue
                                  : const Color(0xFFECC7CE); // Pink
                            } else {
                              color = const Color(0xFFECC7CE); // Pink
                            }

                            return GestureDetector(
                              onTap: () {
                                if (i == currentTaskIndex && snapshot.hasData && task != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TaskPage(widget.userId, index: widget.index),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60), // space for button
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    await resetHabitProgress(widget.userId, widget.index);
                    await _loadTaskInfo(); // reload UI
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Progress has been reset.')),
                    );
                  },
                  backgroundColor: const Color(0xFFEF9A9A), // light red
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ),
            ],
          );
  }
}
