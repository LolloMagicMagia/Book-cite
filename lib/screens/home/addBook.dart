import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/constant.dart';
import '../../view_model.dart';

class AddBook extends StatefulWidget {

  const AddBook({super.key});


  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  final _formKey = GlobalKey<FormState>();
  String? _currentTitle = null;
  String? _currentAuthor = null;
  String? _currentText = "Empty";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp?>(context);

    return SimpleDialog(
            children: [
      Form(
      key: _formKey,
      child: Column(
        children: [
          Text("Update your book settings.",
              style: TextStyle(fontSize: 18)
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Title"),
            validator: (val) =>
            val!.isEmpty
                ? "Please enter a Title"
                : null,
            onChanged: (val) =>
                setState(() {
                  _currentTitle = val;
                }),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Author"),
            validator: (val) =>
            val!.isEmpty
                ? "Please enter a name"
                : null,
            onChanged: (val) =>
                setState(() {
                  _currentAuthor = val;
                }),
          ),
          SizedBox(height: 20),
          //slider
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.pink[400]
              ),
            ),
            child: Text(
              "update",
              style: TextStyle(color: Colors.white),
            ),

            onPressed: () async {
              //si aggiorna da solo perchè ho uno stream di DatabaseService.brews
              //in Home così che se qualcosa cambia modifica la schermata
              print(_formKey.currentState!.validate());
              if (_formKey.currentState!.validate()) {
                /*DatabaseService(uid: user?.uid)
                    .aggiungiCitazioneDiLibro(
                    _currentTitle!, _currentAuthor!, _currentText!);*/
                MyViewModel.instance.createDatabase(user!.uid)?.
                aggiungiCitazioneDiLibro(_currentTitle!, _currentAuthor!, _currentText!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    )
            ],
    );
  }
}
