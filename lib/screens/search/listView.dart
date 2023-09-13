import 'package:cite/screens/search/settingList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../home/bookList.dart';
import '../home/book_tile.dart';

class ListSearch extends StatefulWidget {
  String value;

  ListSearch({Key? key, required this.value});

  @override
  State<ListSearch> createState() => _ListSearchState();
}

class _ListSearchState extends State<ListSearch> {

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>?>(context) ?? [];
    print("LISTRESEARCH ${widget.value}");

    if(widget.value == null || widget.value == ""){
      print("value == null");
      return SettingTile();
    }else {
      List<Book> list = books.where((element) => element.author.toLowerCase().contains(widget.value?.toLowerCase() as Pattern)).toList();
      print("value !=null ${list.toString()}");
      return ListView.builder(
          itemCount: list?.length,
          itemBuilder: (context, index) {
            return BookTile(book: list![index]);
          }
      );
    }
  }
}
