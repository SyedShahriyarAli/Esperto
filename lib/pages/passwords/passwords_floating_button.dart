import 'package:esperto/models/passwords.dart';
import 'package:flutter/cupertino.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../utils/custom_rect_tween.dart';

class AddPasswordButton extends StatelessWidget {
  const AddPasswordButton({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: _heroAddPassword,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: DarkTheme.blueColor,
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

const String _heroAddPassword = 'add-Password-hero';

class AddPasswordPopupCard extends StatefulWidget {
  const AddPasswordPopupCard({Key? key}) : super(key: key);

  @override
  State<AddPasswordPopupCard> createState() => _AddPasswordPopupCardState();
}

class _AddPasswordPopupCardState extends State<AddPasswordPopupCard> {
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddPassword,
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
                      obscureText: !showPassword,
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
                          hintStyle:
                              const TextStyle(color: DarkTheme.borderColor)),
                      cursorColor: DarkTheme.borderColor,
                      style: const TextStyle(color: DarkTheme.fontColor),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          var id = const Uuid().v4();
                          Box passwords = Hive.box<Password>('passwords');
                          if (nameController.text == "" ||
                              usernameController.text == "" ||
                              passwordController.text == "") {
                            return;
                          }
                          Password password = Password(
                            id: id,
                            name: nameController.text,
                            url: urlController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );
                          passwords.put(id, password);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Done'),
                      ),
                    ),
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
