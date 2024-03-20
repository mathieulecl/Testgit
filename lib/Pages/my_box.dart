import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final bool isSpecial; // Ajoutez un paramètre pour déterminer si cette boîte est spéciale

  const MyBox({Key? key, required this.isSpecial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[650],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          width: 100,
          height: 100,
          child: Center(
            child: isSpecial
                ? Text(
              'Boîte spéciale', // Remplacez par votre texte spécial
              style: TextStyle(
                color: Colors.black, // Couleur du texte
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            )
                : Text(
              'Texte commun de la boîte', // Remplacez par votre texte commun
              style: TextStyle(
                color: Colors.black, // Couleur du texte
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
