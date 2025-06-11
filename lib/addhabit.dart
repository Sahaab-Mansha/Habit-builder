import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'UserHabitsService.dart';
import 'habit_model.dart';
import 'main_page.dart';

class AddHabitScreen extends StatefulWidget {
  final String userId;
  const AddHabitScreen(this.userId, {super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final List<String> _tasks = [];
  String selectedEmoji = '😊';

  void _addTask() {
    setState(() {
      _tasks.add('');
    });
  }

  void _saveHabit() async {
    final habitName = _habitNameController.text.trim();
    print("tasks: $_tasks");
    if (habitName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Habit name can't be empty")),
      );
      return;
    }

    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one task")),
      );
      return;
    }
   if(selectedEmoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an emoji")),
      );
      return;
    }
    final success = await addHabit(widget.userId, habitName, _tasks, selectedEmoji);

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Habit already exists")),
      );
      return;
    }
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() {
            selectedEmoji = emoji.emoji; // Update selected emoji without changing TextField
          });
          Navigator.pop(context);
        },
        config: Config(
          
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5DA),
      appBar: AppBar(
        title: const Text('Add New Habit'),
        backgroundColor: const Color(0xFFECC7CE),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)),
            );
          },
        ),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _habitNameController,
                    decoration: InputDecoration(
                      hintText: "e.g. Meditation",
                      filled: true,
                      fillColor: const Color(0xFFD6EDF5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _showEmojiPicker,
                  child: Container(
                    width: 60, // Increased from 40 to 60
                    height: 60, // Increased from 40 to 60
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD6EDF5),
                    ),
                    child: Center(child: Text(selectedEmoji, style: const TextStyle(fontSize: 24))), // Adjusted font size
                  ),
                ),
              ],
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
                        fillColor: const Color(0xFFD6EDF5),
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