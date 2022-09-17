import 'dart:async';

import 'package:esperto/models/config.dart';
import 'package:esperto/pages/home.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({Key? key}) : super(key: key);

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  Box<Config> configCollection = Hive.box<Config>('config');

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DarkTheme.backColor,
        body: PasscodeScreen(
          title: const Text("Enter Your Pin"),
          passwordEnteredCallback: _onPasscodeEntered,
          backgroundColor: DarkTheme.backColor,
          passwordDigits: 5,
          cancelButton: const Text('Cancel'),
          deleteButton: const Text('Delete'),
          shouldTriggerVerification: _verificationNotifier.stream,
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = configCollection.values.first.password == enteredPasscode;
    if (!isValid) {
      _verificationNotifier.add(isValid);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
