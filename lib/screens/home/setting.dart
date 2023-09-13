import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../../services/database.dart';
import '../../shared/constant.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  //form values
  String? _currentName ;
  String? _currentLastName;
  String? _image ;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserApp?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid:user?.uid).userData,
        builder: (context, snapshot) {

          if(snapshot.hasData){

            UserData? userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Update your brew settings.",
                      style: TextStyle(fontSize: 18)
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                    onChanged: (val) => setState(() {
                      _currentName = val;
                    }),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.last_name,
                    decoration: textInputDecoration,
                    validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                    onChanged: (val) => setState(() {
                      _currentLastName = val;
                    }),
                  ),
                  SizedBox(height: 20),
                  //slider
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink[400]
                      ),
                    ),
                    child: Text(
                      "update",
                      style: TextStyle(color: Colors.white),
                    ),

                    onPressed: () async {
                      //si aggiorna da solo perchè ho uno stream di DatabaseService.brews
                      //in Home così che se qualcosa cambia modifica la schermata
                      if(_formKey.currentState!.validate()){
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        final imagePath = prefs.getString('selected_image_path');
                        await DatabaseService(uid: user?.uid).updateUserData(
                            _currentName  ?? userData!.name,
                            _currentLastName ?? userData!.last_name,
                            imagePath ?? userData!.image,
                            );
                        //chiude la bottom
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          }else{
            print(" pronti");
            return Scaffold(
                body: Text("ciao"));
          }
        }
    );
  }
}
