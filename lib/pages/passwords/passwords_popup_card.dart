import 'package:esperto/models/passwords.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../theme.dart';
import '../../utils/custom_rect_tween.dart';

class PasswordPopupCard extends StatefulWidget {
  const PasswordPopupCard({Key? key, required this.password}) : super(key: key);
  final Password password;
  @override
  State<PasswordPopupCard> createState() => _PasswordPopupCardState();
}

class _PasswordPopupCardState extends State<PasswordPopupCard> {
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  @override
  void initState() {
    nameController.text = widget.password.name;
    urlController.text = widget.password.url ?? "";
    usernameController.text = widget.password.username;
    passwordController.text = widget.password.password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Hero(
        tag: widget.password.name,
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
                    controller: nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: 'Account Name',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: DarkTheme.borderColor)),
                    cursorColor: DarkTheme.borderColor,
                    style: const TextStyle(color: DarkTheme.fontColor),
                  ),
                  TextField(
                    controller: urlController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: 'URL',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: DarkTheme.borderColor)),
                    cursorColor: DarkTheme.borderColor,
                    style: const TextStyle(color: DarkTheme.fontColor),
                  ),
                  TextField(
                    controller: usernameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: 'Username / Email',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: DarkTheme.borderColor)),
                    cursorColor: DarkTheme.borderColor,
                    style: const TextStyle(color: DarkTheme.fontColor),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                                  showPassword = !showPassword;
                                }),
                            child: Icon(
                              !showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: DarkTheme.borderColor,
                            )),
                        hintText: 'Password',
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: DarkTheme.borderColor)),
                    cursorColor: DarkTheme.borderColor,
                    style: const TextStyle(color: DarkTheme.fontColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Box notes = Hive.box<Password>('passwords');
                          notes.delete(widget.password.id);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Box notes = Hive.box<Password>('passwords');
                          if (nameController.text == "" ||
                              usernameController.text == "" ||
                              passwordController.text == "") {
                            return;
                          }
                          Password password = Password(
                            id: widget.password.id,
                            name: nameController.text,
                            url: urlController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );
                          notes.put(widget.password.id, password);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Done'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
