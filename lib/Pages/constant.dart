import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../navigation_menu.dart';
/*import 'my_graphic.dart';*/

/*var data=[
  Crypto('Bitcoin','30%','63 900 euros',Colors.lightBlueAccent),
  Crypto('Bitcoin','30%','63 900 euros',Colors.lightBlueAccent),
  Crypto('Bitcoin','30%','63 900 euros',Colors.lightBlueAccent),
];*/

var navigationBar = NavigationMenu(
  onItemTapped: (index) {
    // Handle navigation based on index
  },
);

var myDefaultBackground= Colors.grey[1000];

var myAppBar=AppBar(
  backgroundColor: Colors.grey[700],
);

var myLogo= SvgPicture.asset(
  'assets/image/dash3.svg',
  color: Colors.grey[900],
  width: 100.0,
  height: 100.0,
);

var myDrawer=Drawer(
    backgroundColor: Colors.grey[350],
    child:
    Column(
      children: [
        DrawerHeader(
          child: myLogo,
        ),
        ListTile(
          leading: Icon(Icons.newspaper_outlined),
          title: Text('VOS INFORMATIONS'),
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('SECURITE'),
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app_sharp),
          title: Text('EXIT'),
        ),
      ],
    )

);