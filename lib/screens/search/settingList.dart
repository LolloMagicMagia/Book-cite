import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../home/book_tile.dart';

class SettingTile extends StatefulWidget {
  const SettingTile({super.key});

  @override
  State<SettingTile> createState() => _SettingTile();
}

class _SettingTile extends State<SettingTile> {
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>?>(context) ?? [];

    if(books == null || books == []){
      return Scaffold();
    }else {
      return ListView.builder(
          itemCount: books?.length,
          itemBuilder: (context, index) {
            return BookTile(book: books![index]);
          }
      );
    }
  }
}

