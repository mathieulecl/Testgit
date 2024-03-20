import 'package:flutter/material.dart';
class NavigationMenu extends StatelessWidget {
  final Function(int) onItemTapped;

  const NavigationMenu({Key? key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[700],
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      currentIndex: 0,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Accueil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stacked_line_chart),
          label: "Marchés",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "Actualités",
        ),
      ],
    );
  }
}
