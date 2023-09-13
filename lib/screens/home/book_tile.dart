import 'package:cite/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../../model/user.dart';
import '../../services/database.dart';
import '../../shared/dettaglio_libro.dart';

class BookTile extends StatelessWidget {
  final Book book;

  BookTile({required this.book});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child:ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown,
            backgroundImage: AssetImage("assets/coffee_bg.png"),
          ),
          title: Text(book.author),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DettaglioLibro(book: book),
                ),
            );

          },
          subtitle: Text(book.title),
          trailing: IconButton(
              icon: Icon(Icons.heart_broken),
              color: book.heart == true ? Colors.red:Colors.grey,
              onPressed: () {
                MyViewModel.instance.changePreferencesHeart(book);
              },
          ),
        ),
      ),
    );
  }
}
