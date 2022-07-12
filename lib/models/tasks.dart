import 'package:hive/hive.dart';
part 'tasks.g.dart';

@HiveType(typeId: 2)
class Task {
  Task(
      {required this.id,
      required this.task,
      required this.sequence,
      this.completed = false,
      this.selected = false});

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String task;

  @HiveField(2)
  bool? completed;

  @HiveField(3)
  int sequence;
  bool selected;
}
