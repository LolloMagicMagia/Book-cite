import 'package:cite/shared/loading.dart';
import 'package:cite/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../../services/auth.dart';
import '../../shared/constant.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  MyViewModel _auth= MyViewModel.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String pw = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return  loading? Loading() :Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0,
        actions: [
          ElevatedButton.icon(
              onPressed: (){
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text("Register"),
              ),
        ],
      ),
      body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  decoration:textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (val){
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                  validator: (val) => val!.length<6 ? "Enter a pw 6+ long" : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(() => pw = val);
                  },
                ),
                ElevatedButton(
                  onPressed:() async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(email, pw);

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('email', email);

                      if(result == null){
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  } ,
                  child: Text('Sign in with email'),
                ),
                ElevatedButton(
                  onPressed:() async {
                    dynamic res = await _auth.handleSignInGoogle();
                    print("RES Is ${res.toString()}");
                    if(res is User){
                      String? emailGoogle = res.email;
                      print("RES IS USER : $emailGoogle");
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('email', emailGoogle!);
                    }else {
                      // La gestione dell'errore, se necessario
                      print("Si è verificato un errore durante l'autenticazione con Google.");
                    }
                  } ,
                  child: Text('Sign in with Google'),
                ),
              ],
            ),

          )
      ),
    );
  }
}
