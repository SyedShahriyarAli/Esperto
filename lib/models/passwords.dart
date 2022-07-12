import 'package:hive/hive.dart';
part 'passwords.g.dart'; 

@HiveType(typeId: 3)
class Password {
  Password({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    this.url,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? url;
 
  @HiveField(3)
  final String username;
 
  @HiveField(4)
  final String password;
}
