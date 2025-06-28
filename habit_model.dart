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
      index++;
      if (index >= noOfTasks-1) {
        isCompleted = true; // Mark as complete after all tasks
      }
    }
  }

  

  String? getTask() {
    if (index >= tasks.length) {
      return null;
    }
    if (lastCompleted == null) {
      return tasks[index];
    }

    // Normalize dates to midnight for day comparison
    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);
    final lastDay = DateTime(lastCompleted!.year, lastCompleted!.month, lastCompleted!.day);
    final difference = currentDay.difference(lastDay).inDays;

    if (difference > 1) {
      return tasks[index];
    } else {
      return null;
    }
  }
}