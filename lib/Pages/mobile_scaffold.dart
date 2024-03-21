import 'package:flutter/material.dart';

import 'constant.dart';
import 'my_box.dart';
import 'my_tile.dart';

class MobileScaffold extends StatefulWidget{
  const MobileScaffold({Key? key}): super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffold();
}

class _MobileScaffold extends State<MobileScaffold>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: myDefaultBackground,
      drawer: myDrawer,
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: SizedBox(
              width: double.infinity,
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
                return MyBox(isSpecial: true,);
              },
              ),
            ),
          ),

          Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context,index) {
                  return MyTile();
                },))
        ],
      ),


    );
  }
}