import 'package:esperto/pages/home.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/notes.dart';
import 'dart:io';

import 'models/passwords.dart';
import 'models/reminders.dart';
import 'models/tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Directory? dir = await getExternalStorageDirectory();
  await Hive.initFlutter(dir!.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Password>('passwords');
  await Hive.openBox<Reminder>('reminders');
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
      home: const HomePage(),
    );
  }
}
