import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  const MyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), // Modifier la valeur pour ajuster le rayon
        child: Container(
          color: Colors.grey[350],
          height: 100,
          child: Center(
            child: Text(
              'Le Bitcoin a attiré l attention en tant que forme alternative de monnaie, d investissement et de technologie financière. Cependant, il est important de noter que son adoption et sa réglementation varient d un pays à l autre, et son utilisation suscite des débats et des questions en matière de sécurité, de réglementation et d impact environnemental.', // Remplacez par votre texte
              style: TextStyle(
                color: Colors.grey[1000], // Couleur du texte
                fontSize: 10,
                fontWeight: FontWeight.normal,// Taille du texte
              ),
            ),
          ),
        ),

      ),
    );
  }
}
