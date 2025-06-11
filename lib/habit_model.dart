import 'dart:developer';
import 'package:isar/isar.dart';
part 'habit_model.g.dart';

@embedded
class Habit {
  String habitName = ''; // Default empty string
  DateTime? lastCompleted;
  int noOfTasks = 0; // Default to 0
  int index=0;
  bool isCompleted = false;
  List<String> tasks = [];
  String emoji = "😊"; // Default emoji

  Habit({
    this.habitName = '', // Make optional with default
    this.tasks = const [], // Make optional with default
    this.emoji = "😊",
  }) {
    lastCompleted = null;
    noOfTasks = tasks.length;
    index = 0; // Default index
    isCompleted = false; // Default completion status
  }

  void updateStreak() {
    if (!isCompleted) {
      lastCompleted = DateTime.now();
      print("Last completed updated to: $lastCompleted");
      index++;
      print("index updated to: $index");
      if (index >= noOfTasks-1) {
        isCompleted = true; // Mark as complete after all tasks
        print("Habit completed!");
      }
    }
  }

  

  String? getTask() {
    if (index >= tasks.length) {
      print("Index exceeds task list.");
      return null;
    }
   print("lastcompleted: $lastCompleted");
    if (lastCompleted == null) {
      return tasks[index];
    }

    // Normalize dates to midnight for day comparison
    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);
    final lastDay = DateTime(lastCompleted!.year, lastCompleted!.month, lastCompleted!.day);
    final difference = currentDay.difference(lastDay).inDays;

    print("Day difference: $difference");

    if (difference > 1) {
      return tasks[index];
    } else {
      print("Last completed was too recent (same day or next day).");
      return null;
    }
  }
}