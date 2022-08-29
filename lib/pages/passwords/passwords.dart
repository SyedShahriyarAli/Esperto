import 'package:esperto/models/passwords.dart';
import 'package:esperto/theme.dart';
import 'package:esperto/utils/hero_dialogue_route.dart';
import 'package:esperto/pages/passwords/passwords_floating_button.dart';
import 'package:esperto/pages/passwords/passwords_popup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({Key? key}) : super(key: key);

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final searchController = TextEditingController();
  final passwordsCollection = Hive.box<Password>('passwords');
  List<Password> passwords = <Password>[];

  _PasswordsPageState() {
    passwords = passwordsCollection.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.backColor,
      appBar: AppBar(
        backgroundColor: DarkTheme.backColor,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: SafeArea(
          top: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 40,
            child: TextField(
                autofocus: false,
                cursorColor: DarkTheme.borderColor,
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {
                    passwords = passwordsCollection.values
                        .where((e) => e.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                onChanged: (value) {
                  setState(() {
                    passwords = passwordsCollection.values
                        .where((e) => e.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                style: const TextStyle(
                    height: 1, fontSize: 14.0, color: DarkTheme.fontColor),
                textAlignVertical: const TextAlignVertical(y: 0.6),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    filled: true,
                    fillColor: DarkTheme.backColor,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    hintStyle: const TextStyle(
                      color: DarkTheme.fontColor,
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: DarkTheme.borderColor),
                    hintText: "Search")),
          ),
        ),
      ),
      body: Stack(
        children: [
          Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: passwords.isEmpty
                ? const Center(
                    child: Text(
                    "Add Your Passwords Here. You Can Copy Password Easily and Navigate To The App 😉",
                    style:
                        TextStyle(color: DarkTheme.borderColor, fontSize: 24),
                    textAlign: TextAlign.center,
                  ))
                : ListView(
                    padding: const EdgeInsets.only(bottom: 60),
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      for (final password in passwords)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: DarkTheme.backColor,
                            border: Border.all(color: DarkTheme.borderColor),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: password.password));
                                      showSnackbar(context, "Password Copied");
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        FontAwesomeIcons.copy,
                                        color: DarkTheme.borderColor,
                                        size: 18,
                                      ),
                                    )),
                                password.url == ""
                                    ? const Text("")
                                    : GestureDetector(
                                        onTap: () async {
                                          await launchUrl(
                                              Uri.parse(password.url!),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            FontAwesomeIcons.link,
                                            color: DarkTheme.borderColor,
                                            size: 18,
                                          ),
                                        )),
                                GestureDetector(
                                    onTap: () {
                                      passwordsCollection.delete(password.id);
                                      setState(() {
                                        passwords =
                                            passwordsCollection.values.toList();
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        FontAwesomeIcons.trash,
                                        color: DarkTheme.borderColor,
                                        size: 18,
                                      ),
                                    )),
                              ],
                            ),
                            tileColor: DarkTheme.backColor,
                            dense: true,
                            title: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  HeroDialogRoute(
                                    fullscreenDialog: false,
                                    builder: (context) => Center(
                                      child:
                                          PasswordPopupCard(password: password),
                                    ),
                                  ),
                                );
                                setState(() {
                                  passwords =
                                      passwordsCollection.values.toList();
                                });
                              },
                              child: Text(
                                password.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: DarkTheme.fontColor, fontSize: 16),
                              ),
                            ),
                            subtitle: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  HeroDialogRoute(
                                    fullscreenDialog: false,
                                    builder: (context) => Center(
                                      child:
                                          PasswordPopupCard(password: password),
                                    ),
                                  ),
                                );
                                setState(() {
                                  passwords =
                                      passwordsCollection.values.toList();
                                });
                              },
                              child: Text(
                                password.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: DarkTheme.fontColor, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AddPasswordButton(
              onTap: () async {
                await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return const AddPasswordPopupCard();
                }));
                setState(() {
                  passwords = passwordsCollection.values.toList();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
