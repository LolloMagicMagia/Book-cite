import 'package:cite/services/auth.dart';
import 'package:cite/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final MyViewModel _auth = MyViewModel.instance;
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String pw = "";
  String errore="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        elevation: 0,
        actions:
        [ElevatedButton.icon(
          onPressed: () {
            widget.toggleView();
          },
          icon: Icon(Icons.person),
          label: Text("Sign in"),
        ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.pink[400])
                ),
                child: Text("Register", style: TextStyle(color: Colors.white)),
                onPressed: ()async{
                  //se i due form sono corretti allora si fa l'if
                  if(_formKey.currentState!.validate()){
                    dynamic result = await _auth.registerWithEmailAndPassword(email, pw);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email', email);

                    if(result == null){
                      setState(() {
                        errore = "please supply a valid email";
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              Text(errore, style: TextStyle(color : Colors.red,fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
