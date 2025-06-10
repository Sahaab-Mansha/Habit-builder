import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'user_model.dart';
import 'UserHabits.dart';
import 'UserHabitsService.dart';

/// Add a new user to the database
/// 
/// 
Future<bool> addUser({
  required String username,
  required String password,
  required String gender,
  required DateTime dob,
}) async {
  final userExists = await isUserAvailable(username);

  if (userExists != null) return false; // user already exists

  final newUser = User()
    ..userId = const Uuid().v4()
    ..username = username
    ..password = password
    ..gender = gender
    ..dob = dob
    ..lastLogin = DateTime.now()
    ..streaks = 0;

  await isar.writeTxn(() => isar.users.put(newUser));
  await addDefaultHabits(newUser.userId); // Add default habits for the new user
  return true;
}

/// Check if user exists with given username and password
Future<User?> isUserAvailable(String username, [String? password]) async {
  final query = isar.users.filter()
      .usernameEqualTo(username)
      // Only add password condition if password is provided
      .optional(password != null, (q) => q.passwordEqualTo(password!))
      .findFirst();

  return query;
}


/// Update user's streak based on last login
Future<void> updateStreak(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();

  if (user != null) {
    final now = DateTime.now();
    final last = user.lastLogin;
    final difference = now.difference(last).inDays;

    await isar.writeTxn(() async {
      if (difference == 1) {
        user.streaks += 1;
      } else if (difference > 1) {
        user.streaks = 0;
      }
      user.lastLogin = now;
      await isar.users.put(user);
    });
  }
}

Future<bool> checkPassword(String username, String password) async {
  final user = await isar.users.filter().usernameEqualTo(username).findFirst();

  // If user is not found or password doesn't match
  if (user == null || user.password != password) {
    return false; // Password is incorrect
  }

  return true; // Password is correct
}

Future<int> getStreaks(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  return user?.streaks ?? 0; // Return streaks or 0 if user not found
}
Future<void> setBabyname(String userId, String newName) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  if (user != null) {
    user.babyName = newName;
    await isar.writeTxn(() => isar.users.put(user));
    
  }
  
}
Future<String> getBabyname(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  return user?.babyName ?? "Baran"; // Return baby name or default
}

Future<String> getUserName(String userId)  async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  print(user?.username);
  return user?.username ?? ""; // Return username or default
}

Future<void> deleteUsers() async {
  final users = await isar.users.where().findAll();
  if (users.isNotEmpty) {
    await isar.writeTxn(() async {
      for (var user in users) {
        await isar.users.delete(user.id);
      }
    });
  }
}