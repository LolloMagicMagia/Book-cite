import 'package:cite/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import 'book_tile.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {

    List<Book> books = Provider.of<List<Book>?>(context) ?? [];

    if(books == null || books == []){
      return Scaffold();
    }else {
      //errore qua per quanto riguarda la rimozione e aggiunta di cuori
      List<Book> list = books.where((element) => element.heart == true).toList();
      return ListView.builder(
          itemCount: list?.length,
          itemBuilder: (context, index) {
            return BookTile(book: list![index]);
          }
      );
    }
  }
}
