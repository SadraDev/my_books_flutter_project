import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          const Text(
            'Books, ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Books Everywhere !',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                colors: [
                  Colors.blue,
                  Colors.blue,
                  Colors.white,
                  Colors.blue,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
