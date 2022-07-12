import 'package:esperto/models/reminders.dart';
import 'package:flutter/cupertino.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../utils/custom_rect_tween.dart';

class AddReminderButton extends StatelessWidget {
  const AddReminderButton({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: _heroAddReminder,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: DarkTheme.borderColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const Icon(
              Icons.add,
              color: DarkTheme.fontColor,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}

const String _heroAddReminder = 'add-Reminder-hero';

class AddReminderPopupCard extends StatefulWidget {
  const AddReminderPopupCard({Key? key}) : super(key: key);

  @override
  State<AddReminderPopupCard> createState() => _AddReminderPopupCardState();
}

class _AddReminderPopupCardState extends State<AddReminderPopupCard> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddReminder,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: DarkTheme.backColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: DarkTheme.borderColor)),
                      cursorColor: DarkTheme.borderColor,
                      style: const TextStyle(color: DarkTheme.fontColor),
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //     onPressed: () async {
                    //       var id = const Uuid().v4();
                    //       Box passwords = Hive.box<Password>('passwords');
                    //       if (nameController.text == "" ||
                    //           usernameController.text == "" ||
                    //           passwordController.text == "") {
                    //         return;
                    //       }
                    //       Password password = Password(
                    //         id: id,
                    //         name: nameController.text,
                    //         url: urlController.text,
                    //         username: usernameController.text,
                    //         password: passwordController.text,
                    //       );
                    //       passwords.put(id, password);
                    //       Navigator.of(context).pop();
                    //     },
                    //     style: ButtonStyle(
                    //         foregroundColor: MaterialStateProperty.all(
                    //             DarkTheme.borderColor)),
                    //     child: const Text('Done'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
