import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/book.dart';
import '../model/user.dart';

class DatabaseService{

  final String? uid;

  DatabaseService({this.uid});

  //collection reference, se non esiste la crea se no prende il reference
  final CollectionReference userCollection =  FirebaseFirestore.instance.collection("Users");

  Future updateUserData(String name, String last_name, String? image) async{
    //se non esiste la crea se no prende il reference
    return await userCollection.doc(uid).set({
      "name": name,
      "last_name": last_name,
      "image": image,
    });
  }

  Future updateUserDataNL(String name, String last_name, String image) async{
    //se non esiste la crea se no prende il reference
    return await userCollection.doc(uid).set({
      "name": name,
      "last_name": last_name,
      "image": image,
    });
  }

  Stream<UserData> get userData{
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snap){
    return UserData(id: uid, name: snap.get("name"), last_name: snap.get("last_name"), image: snap.get("image"));
  }

  //BOOK
  // Funzione per aggiungere una citazione di libro per l'utente corrente
  Future<void> aggiungiCitazioneDiLibro(String titolo, String autore, String testo) async {
    final collectionReference = userCollection.doc(uid).collection('citazioniDiLibri');

    try {
      await collectionReference.add({
        'titolo': titolo,
        'autore': autore,
        'testo': testo,
        "cuore": false
      });
    } catch (e) {
      print('Errore durante l aggiunta della citazione di libro: $e');
    }
  }

  Future updateCitazioniLibro(String uidB,String author, String title, String text, bool heart) async{
    //se non esiste la crea se no prende il reference
    return await userCollection.doc(uid).collection("citazioniDiLibri").doc(uidB).set({
      "autore": author,
      "cuore": heart,
      "testo": text,
      "titolo":title,
    });
  }

  // Funzione per aggiungere una citazione di libro per l'utente corrente
  Future changePreferencesHeart(Book book) async {
    final collectionReference = userCollection.doc(uid).collection('citazioniDiLibri').doc(book.uid);

    collectionReference.update({
      "cuore":!book.heart,
    });
  }

    //brewList form snapshots
    List<Book>? _brewListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs.map((e) {
        return Book(uid: e.id,author: e.get("autore") ?? "Empty", title: e.get("titolo") ?? "Empty", puntiFondamentali: e.get("testo") ?? "Empty", heart: e.get("cuore") ?? false);
      }).toList();
    }

  // get brew stream,
  Stream<List<Book>?> get book{
    print("GET BOOKS ${uid}");
    return userCollection.doc(uid).collection('citazioniDiLibri').snapshots().map(_brewListFromSnapshot);
  }
}