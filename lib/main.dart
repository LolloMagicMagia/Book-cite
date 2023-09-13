import 'package:cite/model/user.dart';
import 'package:cite/screens/home/Home.dart';
import 'package:cite/screens/wrapper.dart';
import 'package:cite/services/auth.dart';
import 'package:cite/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform );
  runApp(MyApp());
}

//devo chiamare FIREBASE ALL'INIZIO E POI AGGIORNARE LE SHARED E QUANDO CHIUDO L'APP VADO
//AD AGGIORNARE FIREBASE TRAMITE LE SHARED PREFERENCES

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserApp?>.value(
     value: MyViewModel.instance.user,
     initialData: null,
     child: MaterialApp(
       home:Wrapper(),
     ),
    );
  }
}


