import 'package:esperto/theme.dart';
import 'package:esperto/utils/hero_dialogue_route.dart';
import 'package:flutter/material.dart';

import 'reminders_floating_button.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.backColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: AddReminderButton(
              onTap: () async {
                await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return const AddReminderPopupCard();
                }));
                setState(() {
                  // notes = notesCollection.values.toList();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
