import 'package:cite/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database.dart';

class AuthService extends ChangeNotifier{
  static AuthService? _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Costruttore privato
  AuthService._();

  // Metodo statico per ottenere l'istanza della classe
  static AuthService get instance {
    // Se l'istanza non è stata ancora creata, crea una nuova istanza
    _instance ??= AuthService._();
    return _instance!;
  }


  Stream<UserApp?> get user{
    //ogni volta che cambia l'accesso authstatechanges andrà a notificare ed avendo detto al main di ascoltare modificherà
    /*map: Il metodo map è una funzione di trasformazione fornita dagli stream in Flutter.
     Prende una funzione come argomento e applica quella funzione a ciascun elemento emesso nello stream, generando un nuovo stream con i risultati trasformati.*/
    return _auth.authStateChanges()./*map((event) => _userFromFirebaseUser(event));*/
    map(_userFromFirebaseUser);
  }

  UserApp? _userFromFirebaseUser(User? user){
    print(" PRONTI : ${user?.uid}");
    return user != null ? UserApp(uid: user.uid) : null;
  }

  //sign in email & pw
  Future signInWithEmailAndPassword(String email, String pw) async{
    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: pw);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email & pw
  Future registerWithEmailAndPassword(String email, String pw) async{
    try{
      UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: pw);
      User? user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData("Da definire", "Da definire", "assets/coffee_bg.png");
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future handleSignInGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;
        await DatabaseService(uid: firebaseUser!.uid).updateUserData("Da definire", "Da definire", "assets/coffee_bg.png");
        print("Logged in with Google: credential accessToken");

        return firebaseUser;
        /*return await _auth.signInWithCredential(credential!);*/
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut(); // Effettua il log out da Google
      await _auth.signOut(); // Effettua il log out dall'autenticazione Firebase
    } catch (e) {
      print(e.toString());
    }
  }

}