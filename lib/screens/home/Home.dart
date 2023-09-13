import 'package:cite/model/book.dart';
import 'package:cite/screens/home/bookList.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/constant.dart';
import '../../view_model.dart';
import '../profile/imageSelectionDialog.dart';
import 'addBook.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //vado a chiamare quello che mi mostrerà le imm
  Future<void> _addBook(BuildContext context) async {
      await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBook();
      },
    );
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: Stack(
            children: [
              BookList(),
              Positioned(
                bottom: 16.0, // Imposta la posizione del bottone come desideri
                right: 16.0,
                child: ElevatedButton(
                  onPressed: () {
                  // Gestisci l'azione del bottone qui
                    _addBook(context);
                  },
                  child: Text('AddBook'),
            ),
          ),
            ],
          ),

        );
  }
}


