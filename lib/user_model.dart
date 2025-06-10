import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  late String userId;       // UUID
  late String username;
  late String password;
  late String gender;
  late DateTime dob;
  late DateTime lastLogin;
  int streaks = 0;
  late String babyName = "Baran";
}
