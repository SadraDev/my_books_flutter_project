// @dart=2.9
import 'package:appandup_bookshelf/CustomWidgets/header.dart';
import 'package:appandup_bookshelf/CustomWidgets/rounded_button.dart';
import 'package:appandup_bookshelf/networking/log_in.dart';
import 'package:appandup_bookshelf/Screens/email_login_screen.dart';
import 'package:appandup_bookshelf/Screens/home_screen.dart';
import 'package:appandup_bookshelf/Screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('something went wrong'));
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const WelcomeScreenUI();
        }
      },
    );
  }
}

class WelcomeScreenUI extends StatefulWidget {
  const WelcomeScreenUI({Key key}) : super(key: key);

  @override
  _WelcomeScreenUIState createState() => _WelcomeScreenUIState();
}

class _WelcomeScreenUIState extends State<WelcomeScreenUI> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Header(),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          loading: false,
                          icon: Icons.login_outlined,
                          color: Colors.cyan,
                          title: 'Log in',
                          onPressed: () {
                            Navigator.pushNamed(context, EmailLogin.id);
                          },
                        ),
                        RoundedButton(
                          loading: loading,
                          icon: FontAwesomeIcons.google,
                          color: Colors.red,
                          title: 'Continue with Google',
                          onPressed: () {
                            final provider =
                                Provider.of<LogIn>(context, listen: false);
                            provider.googleIn();
                            loading = !loading;
                            setState(() {});
                          },
                        ),
                        RoundedButton(
                          loading: false,
                          icon: Icons.app_registration,
                          color: Colors.blueAccent,
                          title: 'Register',
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
