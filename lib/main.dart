import 'package:esperto/pages/introductions/introduction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esperto/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esperto/theme.dart';
import 'package:uuid/uuid.dart';
import 'models/passwords.dart';
import 'models/reminders.dart';
import 'models/notes.dart';
import 'models/tasks.dart';
import 'models/config.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initializeDatabase();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esperto',
      theme: ThemeData(
          fontFamily: 'Montserrat',
          textTheme:
              const TextTheme(bodyText2: TextStyle(color: DarkTheme.fontColor)),
          backgroundColor: DarkTheme.backColor),
      home: const IntroductioPage(),
    );
  }
}

Future<void> initializeDatabase() async {
  Directory? dir = await getExternalStorageDirectory();
  await Hive.initFlutter(dir!.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(ConfigAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Password>('passwords');
  await Hive.openBox<Reminder>('reminders');
  await Hive.openBox<Config>('config');
  Box configCollection = Hive.box<Config>('config');
  if (configCollection.isEmpty) {
    var id = const Uuid().v4();
    Config config = Config(
      id: id,
      signup: false,
      password: "",
    );
    configCollection.put(id, config);
  }
}
