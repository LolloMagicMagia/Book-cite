
import 'dart:io';

import 'package:cite/model/user.dart';
import 'package:cite/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/database.dart';
import 'imageSelectionDialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  String? selectedImage = null;
  UserData? userApp = null;
  String? email = "";

  @override
  void initState() {
    super.initState();
    print("0001");
    /*loadImage();*/ // Chiama la funzione per caricare l'immagine selezionata
  }

  @override
  void dispose() async {
    super.dispose();
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_image_path', selectedImage!);
    print(selectedImage);
    //SALVARE SU FIREBASE L'IMM NUOVA
    if(selectedImage != userApp?.image) {
      MyViewModel.instance.updateDatabase(userApp!, selectedImage!);
    }*/
  }

  //per prendere l'imm selezionata dalle shared preferences
  /*Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('selected_image_path');
    if (imagePath != null) {
      setState(() {
        selectedImage = imagePath;
      });
    }
  }*/

  //vado a chiamare quello che mi mostrerà le imm
  Future<void> _selectImage(BuildContext context) async {
    String? selectedImagePicker = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageSelectionDialog();
      },
    );

    if (selectedImagePicker != null) {
      setState(() {
        selectedImage = selectedImagePicker;
      });
      // Salva il percorso dell'immagine selezionata con shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_image_path', selectedImage!);
    }
  }

   Future<String?> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return email = prefs.getString('email');
  }

  bool first=  true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp?>(context);

    return StreamBuilder<UserData>(
        stream: MyViewModel.instance.getUserData(user!.uid),
        builder: (context, snapshot) {
          print("CIAO + ${snapshot.hasData}");
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            userApp = userData;

              if(first){
                selectedImage = userData!.image;
                first = !first;
              }

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: CircleAvatar(
                      backgroundImage: selectedImage != null ? AssetImage(selectedImage!) : AssetImage("assets/coffee_bg.png"),
                      radius: 100,
                    ),
                    ),
                    Center(child: ElevatedButton(
                      onPressed: () async {
                        await _selectImage(context);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('selected_image_path', selectedImage!);
                        print("VEDIAMO SE WORKA1");
                        if(selectedImage != userApp?.image) {
                          print("VEDIAMO SE WORKA0");
                          MyViewModel.instance.updateUserDatabase(userApp!, selectedImage!);
                        }
                      },
                      child: Text('Scegli un\'immagine'),
                      ),
                    ),
                    Divider(height: 60.0, color: Colors.white),
                    Text("Name"),
                    Text(userData!.name),
                    Divider(height: 60.0, color: Colors.white),
                    Text("Last-Name"),
                    Text(userData!.last_name),
                    Divider(height: 60.0, color: Colors.white),
                    Text("email"),
                    FutureBuilder<String?>(
                    future: _getEmail(),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Il Future è in attesa di completamento
                        return Text("email");
                      } else if (snapshot.hasError) {
                        // Si è verificato un errore nel caricamento del valore
                        return Text('Errore nel recupero dell\'email');
                      } else {
                        // Il Future è stato completato con successo
                        String? email = snapshot.data;
                        return Text(email ?? 'Email non disponibile');
                      }
                      },
                    )





          ],
                ),
              ),
            );
          }
          else {
            print(" pronti");
            return Scaffold(
              body: Text(""),
            );
          }
        }
    );
  }
}