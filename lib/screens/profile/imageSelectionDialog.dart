import 'package:flutter/material.dart';

class ImageSelectionDialog extends StatelessWidget {

  final List<String> imageOptions = [
    "assets/coffee_bg.png",
    "assets/OIP.jpg",
    "assets/toji.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Seleziona un\'immagine'),
      children: imageOptions.map((imagePath) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, imagePath);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
        );
      }).toList(),
    );
  }
}