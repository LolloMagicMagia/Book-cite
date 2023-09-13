import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../model/user.dart';
import '../services/database.dart';

// Definisci la nuova schermata come un widget separato
class DettaglioLibro extends StatefulWidget {
  final Book book;

  DettaglioLibro({required this.book});

  @override
  State<DettaglioLibro> createState() => _DettaglioLibroState();
}

class _DettaglioLibroState extends State<DettaglioLibro> {
  bool changeT= false;
  bool changeA= false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp?>(context);
    String? author = widget.book.author;
    String? title = widget.book.title;
    String? text = widget.book.puntiFondamentali;
    TextEditingController myTextController = TextEditingController(text: text);

    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli del Libro"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
        child: Form(
            key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Titolo: "),
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      validator: (val) => val!.isEmpty ? "Enter a title" : null,
                      onChanged: (val){
                        changeT = true;
                        title = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none, // Rimuove i bordi
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Text("Author: "),
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      validator: (val) => val!.isEmpty ? "Enter a author" : null,
                      onChanged: (val){
                        changeA = true;
                        author = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none, // Rimuove i bordi
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
            TextField(
            maxLines: null, // Permette di espandere il widget in base al contenuto.
            keyboardType: TextInputType.multiline, // Abilita la modalità multiriga.
            controller: myTextController, // Testo predefinito.
            decoration: InputDecoration(
              border: OutlineInputBorder(

              ), // Stile del bordo.
            ),
            ),
              SizedBox(height: 30.0),
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
                  print("RISULTATO DETTAGLIO LIB : ${changeT || changeA || myTextController.text != "Write here" && _formKey.currentState!.validate()};");
                  if(changeT || changeA || myTextController.text != "Write here" && _formKey.currentState!.validate()){
                    await DatabaseService(uid: user?.uid).updateCitazioniLibro(widget.book.uid, author!, title!, myTextController.text!, widget.book.heart);
                    Navigator.pop(context);
                  };
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}