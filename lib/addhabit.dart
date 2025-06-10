
import 'package:flutter/material.dart';
import 'UserHabitsService.dart'; // Import your habit service
import 'habit_model.dart'; // Import your habit model
import 'main_page.dart'; // Import the main page you want to navigate to
class AddHabitScreen extends StatefulWidget {
  final String userId;
  const AddHabitScreen(this.userId, {super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final List<String> _tasks = [];

  void _addTask() {
    setState(() {
      _tasks.add(''); // Placeholder task entry (can be edited later)
    });
  }

  void _saveHabit() async {
  final habitName = _habitNameController.text.trim();
  print("tasks: $_tasks");
  // Check for empty name
  if (habitName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Habit name can't be empty")),
    );
    return;
  }

  // Check if at least one task is added
  if (_tasks.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please add at least one task")),
    );
    return;
  }

  // Attempt to add habit
  final success = await addHabit(widget.userId, habitName, _tasks);

  if (success) {
    // Return to HomeScreen with signal to reload
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)));
  } else {
    // Habit already exists
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Habit already exists")),
    );
    return;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5DA),
      appBar: AppBar(
        title: const Text('Add New Habit'),
        backgroundColor: const Color(0xFFECC7CE),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Habit Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                hintText: "e.g. Meditation 🧘‍♀️",
                filled: true,
                fillColor:  const Color(0XFFD6EDF5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Task"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0D0E7),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Task ${index + 1}",
                        filled: true,
                        fillColor: const Color(0XFFD6EDF5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) {
                        _tasks[index] = value;
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: const Text("Save Habit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECC7CE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
