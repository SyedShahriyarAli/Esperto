import 'package:esperto/pages/notes/notes.dart';
import 'package:esperto/pages/passwords/passwords.dart';
import 'package:esperto/pages/reminders/reminders.dart';
import 'package:esperto/pages/tasks/tasks.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: DarkTheme.backColor,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          iconSize: 16,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.noteSticky), label: 'Notes'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.listCheck), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.key), label: 'Passwords'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.clock), label: 'Reminders'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.gear), label: 'Settings')
          ],
          onTap: _onTappedBar,
          selectedItemColor: DarkTheme.fontColor,
          unselectedItemColor: DarkTheme.borderColor,
          currentIndex: _selectedIndex,
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          NotesPage(),
          TasksPage(),
          PasswordsPage(),
          RemindersPage(),
        ],
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
