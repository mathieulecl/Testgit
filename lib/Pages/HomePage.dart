import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../navigation_menu.dart';
import 'package:dashboard/Pages/marches_page.dart';
import 'package:dashboard/Pages/actualites_page.dart';
import  'dropdown_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(), // Contenu de la page d'accueil
    MarchesPage(),
    ActualitesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationMenu(
        onItemTapped: _onItemTapped, // Passer la fonction de rappel à votre NavigationMenu
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/image/dash3.svg",
          color: Colors.blue,
          height: 100, // Réglez la hauteur selon votre préférence
        ),
        const Text(
          "Mathieu Leclercq, Adele Chevalier, Gael Martins",
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        // Autres éléments de votre page d'accueil
      ],
    );
  }
}
