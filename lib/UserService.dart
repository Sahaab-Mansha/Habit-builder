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
    
    // Normalize dates to midnight for day comparison
    final today = DateTime(now.year, now.month, now.day);
    final lastLoginDay = DateTime(last.year, last.month, last.day);
    final difference = today.difference(lastLoginDay).inDays;

    await isar.writeTxn(() async {
      if (difference == 1) {
        // Consecutive calendar days
        user.streaks += 1;
      } else if (difference > 1) {
        // More than one day gap - reset streak
        user.streaks = 0;
      }
      // Don't update streak if difference == 0 (same day)
      
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
Future<void> ResetUser(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  if (user != null) {
    user.streaks = 0;
    user.lastLogin = DateTime.now();
    user.babyName = "Baran"; // Reset to default
    await isar.writeTxn(() => isar.users.put(user));
  }
}

Future<void> deleteUser(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  if (user != null) {
    await isar.writeTxn(() async {
      await isar.users.delete(user.id);
      await isar.userHabits.where().filter().userIdEqualTo(userId).deleteAll();
    });
  }
}

void changePassword(String userId, String newPassword) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  if (user != null) {
    user.password = newPassword;
    await isar.writeTxn(() => isar.users.put(user));
  }
}
void changeUsername(String userId, String newUsername) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  if (user != null) {
    user.username = newUsername;
    await isar.writeTxn(() => isar.users.put(user));
  }
}

Future<String> GetGender(String userId) async {
  final user = await isar.users.filter().userIdEqualTo(userId).findFirst();
  return user?.gender ?? "Unknown"; // Return gender or default
}