import 'package:hive/hive.dart';
part 'reminders.g.dart';

@HiveType(typeId: 4)
class Reminder {
  Reminder({
    required this.id,
    required this.title,
    required this.dateTime,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  DateTime dateTime;
}
