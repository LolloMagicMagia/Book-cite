import 'package:cite/screens/profile/profile.dart';
import 'package:cite/screens/search/search.dart';
import 'package:cite/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/book.dart';
import '../model/user.dart';
import '../view_model.dart';
import 'home/Home.dart';
import 'home/setting.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  AuthService _auth = AuthService.instance;
  String _schermata ="Home";

  final List<Widget> _widgetOptions = [
    Home(),
    Search(),
    Profile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 1){
        _schermata = "Search";
      }else if(index ==2){
        _schermata = "Profile";
      }else{
        _schermata = "Home";
      }
    });
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp?>(context);

    void showSettingsPanel(){
      showModalBottomSheet(context: context, builder:(context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Book>?>.value(
        value: MyViewModel.instance.getBooks(context, user!.uid),
      initialData: null,
      child: Scaffold(
      appBar: AppBar(
        title: Text(_schermata),
        elevation: 0,
        actions: [
          ElevatedButton.icon(
              onPressed: () async{
                //così da togliere tutti i dati salvati in un app android
                clearSharedPreferences();
                await _auth.signOut();
              },
              icon: Icon(Icons.email_outlined),
            label: Text("sign-out"),
              ),
          ElevatedButton.icon(
            onPressed: () {
              showSettingsPanel();
            },
            icon: Icon(Icons.settings),
            label: Text(""),
          )
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    ),
    );
  }
}
