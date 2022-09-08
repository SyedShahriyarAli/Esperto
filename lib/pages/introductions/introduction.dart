import 'package:esperto/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductioPage extends StatefulWidget {
  const IntroductioPage({Key? key}) : super(key: key);

  @override
  _IntroductioPageState createState() => _IntroductioPageState();
}

class _IntroductioPageState extends State<IntroductioPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName, [double width = 150]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: DarkTheme.backColor,
      imagePadding: EdgeInsets.only(top: 30),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: DarkTheme.backColor,
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: const Text(
                "Write Your Notes Here !",
                style: TextStyle(fontSize: 18),
              )),
          image: _buildImage('notes.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: const Text("List Your Todos !",
                  style: TextStyle(fontSize: 18))),
          title: "",
          image: _buildImage('todos.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: const Text(
                "Secure Your Passwords !",
                style: TextStyle(fontSize: 18),
              )),
          title: "",
          image: _buildImage('passwords.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: const Text(
                "Secure Your Passwords !",
                style: TextStyle(fontSize: 18),
              )),
          bodyWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(color: DarkTheme.blueColor),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ElevatedButton(
                  child: const Text(
                    "Continue With Google",
                    style: TextStyle(color: DarkTheme.fontColor),
                  ),
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                      primary: DarkTheme.blueColor.withOpacity(0.105),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      textStyle: const TextStyle(
                          color: DarkTheme.fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                )),
          ),
          image: _buildImage('google.png'),
          decoration: pageDecoration,
        ),
      ],
      showSkipButton: true,
      nextFlex: 0,
      next: const Icon(
        Icons.arrow_forward,
        color: DarkTheme.fontColor,
      ),
      skip: const Text(
        'Skip',
        style: TextStyle(color: DarkTheme.fontColor),
      ),
      showDoneButton: true,
      onDone: () {},
      done: const Text('',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: DarkTheme.fontColor)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.yellow,
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: DarkTheme.blueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
