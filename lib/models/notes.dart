import 'package:hive/hive.dart';
part 'notes.g.dart'; 

@HiveType(typeId: 1)
class Note {
  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    this.selected = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;
 
  @HiveField(3)
  final String color;
  bool selected;
}
