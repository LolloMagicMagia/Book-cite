import "package:cite/screens/authenticate/register.dart";
import "package:cite/screens/authenticate/signIn.dart";
import "package:cite/services/auth.dart";
import "package:flutter/material.dart";

import "../../shared/constant.dart";

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView : toggleView) : Register(toggleView: toggleView);
  }
}

