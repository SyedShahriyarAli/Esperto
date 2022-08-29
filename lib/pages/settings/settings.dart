import 'package:esperto/models/config.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final passwordController = TextEditingController();
  final configCollection = Hive.box<Config>('config');
  late Config config;

  _SettingsPageState() {
    config = configCollection.values.first;
    passwordController.text = config.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DarkTheme.backColor,
        appBar: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            elevation: 0,
            backgroundColor: DarkTheme.backColor,
            title: const SafeArea(child: Text("Master Passowrd"))),
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                          obscureText: false,
                          cursorColor: DarkTheme.backColor,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          maxLength: 5,
                          style: const TextStyle(
                              height: 1.4,
                              fontSize: 18.0,
                              color: DarkTheme.fontColor),
                          textAlignVertical: const TextAlignVertical(y: 0.45),
                          decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: DarkTheme.borderColor,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                      color: DarkTheme.borderColor,
                                      width: 1.0,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                      color: DarkTheme.borderColor,
                                      width: 1.0,
                                      style: BorderStyle.solid)),
                              hintStyle: const TextStyle(
                                  color: DarkTheme.fontColor,
                                  letterSpacing: 0,
                                  fontSize: 16),
                              hintText: "Set Your 5 Digits Pin")),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              child: const Text(
                                "Submit",
                                style: TextStyle(color: DarkTheme.fontColor),
                              ),
                              onPressed: () async {
                                Box configs = Hive.box<Config>('config');
                                Config config = Config(
                                    id: this.config.id,
                                    signup: true,
                                    password: passwordController.text);
                                configs.put(config.id, config);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: DarkTheme.blueColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  textStyle: const TextStyle(
                                      color: DarkTheme.fontColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            )),
                      ),
                    ])),
          ),
        ));
  }
}
