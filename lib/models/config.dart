import 'package:hive/hive.dart';
part 'config.g.dart';

@HiveType(typeId: 5)
class Config {
  Config({
    required this.id,
    required this.signup,
    required this.password,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final bool signup;

  @HiveField(2)
  final String password;
}
