import 'package:isar/isar.dart';
import 'habit_model.dart';
import 'UserHabits.dart';
import 'user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'UserService.dart';
late Isar isar;

Future<void> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [UserHabitsSchema, UserSchema], // include all schemas here
    directory: dir.path,
  );
  
  // Clear habits on initialization // Add default habits if none exist
}

Future<void> addDefaultHabits(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();

  if (userHabits != null && userHabits.habits.isNotEmpty) {
    return; // Default habits already exist
  }

  final defaultHabits = [
    Habit(habitName: 'Drink Water', tasks: ['Drink 8 glasses of water'], emoji: '💧'),
    Habit(habitName: 'Exercise', tasks: ['30 minutes of exercise'], emoji: '🏋️'),
    Habit(habitName: 'Read', tasks: ['Read for 20 minutes'], emoji: '📚'),
  ];

  final newUserHabits = UserHabits()
    ..userId = userId
    ..habits = defaultHabits;

  await isar.writeTxn(() async {
    await isar.userHabits.put(newUserHabits);
  });

}

Future<bool> addHabit(String userId, String habitName, List<String> tasks, {String? emoji}) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();

  if (userHabits == null) {
    return false;
  }

  for (final habit in userHabits.habits) {
    if (habit.habitName == habitName) {
      return false;
    }
  }

  final newHabit = Habit(
    habitName: habitName,
    tasks: tasks,
    emoji: emoji ?? '😊',
  );

  userHabits.habits = List<Habit>.from(userHabits.habits);
  userHabits.habits.add(newHabit);

  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });

  return true;


  return true;
}

Future<String?> getTask(String userId, int index) async {
final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || index < 0 || index >= userHabits.habits.length) {
    return null;
  }

  final habit = userHabits.habits[index];
  return habit.getTask();
}

Future<List<String>> getHabitNames(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  return userHabits.habits.map((habit) => habit.habitName).toList();
}

Future<List<String>> getEmojiList(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  return userHabits.habits.map((habit) => habit.emoji).toList();
}

Future<int> getIndex(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return -1;
  }
  return userHabits.habits[habitIndex].index;
}

Future<void> updateHabit(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return;
  }

  final habit = userHabits.habits[habitIndex];
  habit.updateStreak();
  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });
}

Future<bool> isCompleted(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return false;
  }
  return userHabits.habits[habitIndex].isCompleted;
}

