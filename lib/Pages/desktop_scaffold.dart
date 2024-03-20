import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../navigation_menu.dart';
import 'HomePage.dart';
import 'actualites_page.dart';
import 'constant.dart';
import 'marches_page.dart';
import 'my_box.dart';
import 'my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _MobileScaffold();
}

class _MobileScaffold extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: myDefaultBackground,
      drawer: myDrawer,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: 2,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return MyBox(isSpecial: true);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return MyTile();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.grey[500],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tableau de bord à droite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationMenu(
        onItemTapped: (index) {
          // Handle navigation based on index
          switch (index) {
            case 0:
            // Handle Accueil tab
            // You can add your logic or navigate to the corresponding page
              break;
            case 1:
            // Handle Marchés tab
              Navigator.push(context, MaterialPageRoute(builder: (context) => MarchesPage()));
              break;
            case 2:
            // Handle Actualités tab
              Navigator.push(context, MaterialPageRoute(builder: (context) => ActualitesPage()));
              break;
          }
        },
      ),
    );
  }
}
