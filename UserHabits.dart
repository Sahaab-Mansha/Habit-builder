import 'package:isar/isar.dart';
import 'habit_model.dart';

part 'UserHabits.g.dart';

@collection
class UserHabits {
  Id id = Isar.autoIncrement;
  String userId = '';
  late List<Habit> habits=[];
}
