// @dart=2.9
import 'package:appandup_bookshelf/CustomWidgets/header.dart';
import 'package:appandup_bookshelf/CustomWidgets/rounded_button.dart';
import 'package:appandup_bookshelf/networking/log_in.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key key}) : super(key: key);

  static const String id = 'email_login_screen';

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  bool loading = false;
  bool _obscureText = true;
  String _email;
  String _password;

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
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            cursorHeight: 24.0,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your Email address',
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                            validator: (email) =>
                                !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            obscureText: _obscureText,
                            cursorHeight: 24.0,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter Password',
                              labelText: 'password',
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.password_outlined,
                              ),
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          RoundedButton(
                            icon: Icons.email_outlined,
                            title: 'Log in',
                            color: Colors.cyan,
                            loading: loading,
                            onPressed: () async {
                              final provider =
                                  Provider.of<LogIn>(context, listen: false);
                              final form = formKey.currentState;

                              if (form.validate()) {
                                provider.emailLogIn(_email, _password, context);
                                setState(() {
                                  loading = !loading;
                                });
                              }
                            },
                          ),
                        ],
                      ),
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
