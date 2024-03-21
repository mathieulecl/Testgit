import 'package:flutter/material.dart';
import  'package:flutter_svg/flutter_svg.dart';

import 'Pages/HomePage.dart';
import 'Pages/desktop_scaffold.dart';
import 'Pages/mobile_scaffold.dart';
import 'Pages/responsive_layout.dart';
import 'Pages/tablet_scaffold.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    debugShowCheckedModeBanner: false,
    home: ResponsiveLayout(
    mobileScaffold: const MobileScaffold(),
    tabletScaffold: const TabletScaffold(),
    desktopScaffold: const DesktopScaffold(),
    ),
    );
    }
}



