import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

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

  void _saveHabit() {
    final habitName = _habitNameController.text.trim();
    if (habitName.isNotEmpty) {
      // For now, just print it
      print('Habit saved: $habitName with ${_tasks.length} tasks');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Habit name can't be empty")),
      );
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
