import 'package:cite/services/auth.dart';
import 'package:cite/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'model/book.dart';
import 'model/user.dart';

class MyViewModel{

  static MyViewModel? _instance;
  AuthService auth = AuthService.instance;
  String uidL ="";
  DatabaseService? db = null;
  Stream<List<Book>?>? books;
  Stream<List<Book>?>? booksF;
  Stream<UserData>? userData;

  bool firstTime = true;
  bool firstTime2 = true;

  // Costruttore privato
  MyViewModel._();

  // Metodo statico per ottenere l'istanza della classe
  static MyViewModel get instance {
    // Se l'istanza non è stata ancora creata, crea una nuova istanza
    _instance ??= MyViewModel._();
    return _instance!;
  }

  //AUTH
  Stream<UserApp?> get user{
    return auth.user;
  }

  Future signInWithEmailAndPassword(String email, String pw) async{
    return auth.signInWithEmailAndPassword(email, pw);
  }

  Future handleSignInGoogle() async {
    return auth.handleSignInGoogle();
  }

  Future registerWithEmailAndPassword(String email, String pw) async{
    return auth.registerWithEmailAndPassword(email, pw);
  }

  //DATABASE

  DatabaseService? createDatabase(String uid){
    print("VEDERE SE UID SONO DIVERSI ${uid != uidL}");
    if(uid != uidL){
      uidL = uid;
      db = _getDatabase(uid);
    }
    return db;
  }

  _getDatabase(String uid){
    return DatabaseService(uid: uid);
  }

  getBooks(BuildContext context, String uid)  {
    if(firstTime){
      firstTime = !firstTime;
      if(db == null){
        createDatabase(uid);
      }
      booksF = db?.book;
      return booksF;
    }else{
      return booksF;
    }
  }

  changePreferencesHeart(Book book){
    db?.changePreferencesHeart(book);
  }

  updateUserDatabase(UserData userApp, String selectedImage){
    db?.updateUserData(
        userApp!.name,
        userApp!.last_name,
        selectedImage
    );
  }

  getUserData(String uid)  {
    if(firstTime2){
      firstTime = !firstTime;
      if(db == null){
        createDatabase(uid);
      }
      userData = db?.userData;
      return userData;
    }else{
      return userData;
    }
  }

  resetParameters(){
    _instance = null;
    uidL ="";
    db = null;
    books = null;
    booksF = null;
    userData= null;
    firstTime = true;
    firstTime2 = true;
  }

}