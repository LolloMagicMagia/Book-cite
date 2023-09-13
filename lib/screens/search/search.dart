import 'package:cite/screens/search/listView.dart';
import 'package:cite/screens/search/settingList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../../model/user.dart';
import '../../services/database.dart';
import '../../view_model.dart';
import '../home/bookList.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String valueText = "";

   Widget updateList(String valuePassata){
      print("cambio lettere dentro UPDATE : ${valuePassata}");
      return ListSearch(value:valuePassata);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(restorationId: ("search"),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value){
                      print("cambio lettere : ${value}");
                      setState(() {
                        valueText = value;
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search a Book",
                      suffixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(child: updateList(valueText)),
                ],
              )
          ),
        );

  }
}
