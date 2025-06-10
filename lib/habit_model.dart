import 'dart:developer';

import 'package:isar/isar.dart';
part 'habit_model.g.dart';
@embedded

class Habit {
  
  late String habitName;
  late DateTime? lastCompleted;
  late int noOfTasks; // Was DateTime, changed to int for task count
  late int index = -1;
  late bool isCompleted = false;
  late List<String> tasks = [];
  late String emoji = "😊"; // Default emoji
       // List of task names
       Habit({
    required this.habitName,
    required this.tasks,
    this.emoji = "😊",
  }
  ) {
    lastCompleted = null;
    noOfTasks = tasks.length;
    index = 0; // Default index
    isCompleted = false; // Default completion status
  }

  void updateStreak()
  {
    if(!isCompleted)
    {
       lastCompleted = DateTime.now();
       print("Updated last completed time: $lastCompleted");
    index++;
    if (index >= noOfTasks) {
      isCompleted = true; // Reset index after completing all tasks
    }
    
    }
    
  }     

  String? getTask()
  {
    if (index < tasks.length && DateTime.now().difference(lastCompleted!).inDays > 1) 
    {
      print("time difference " + DateTime.now().difference(lastCompleted!).inDays.toString());
      return tasks[index];
    } 
    else 
    {
      print("Index exceeds task list or last completed time is not valid.");
      return null; // Handle case where index exceeds task list
    }
  }

}
