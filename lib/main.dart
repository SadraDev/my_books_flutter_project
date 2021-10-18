// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'networking/log_in.dart';
import 'Screens/email_login_screen.dart';
import 'Screens/favorite_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GoogleBooks());
}

class GoogleBooks extends StatelessWidget {
  const GoogleBooks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogIn(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          EmailLogin.id: (context) => const EmailLogin(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          FavoriteScreen.id: (context) => const FavoriteScreen(),
        },
      ),
    );
  }
}
