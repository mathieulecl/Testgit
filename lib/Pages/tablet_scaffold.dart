
import 'package:flutter/material.dart';

import 'constant.dart';
import 'constant.dart';
import 'my_box.dart';
import 'my_tile.dart';

class TabletScaffold extends StatefulWidget{
  const TabletScaffold({Key? key}): super(key: key);

  @override
  State<TabletScaffold> createState() => _MobileScaffold();
}

class _MobileScaffold extends State<TabletScaffold>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: myDefaultBackground,
      drawer: myDrawer,
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemBuilder: (context, index) {
                return MyBox(isSpecial: true,);
              },
              ),
            ),
          ),

          Expanded(
              flex:1,
              child: ListView.builder(
                itemCount:1,
                itemBuilder: (context,index) {
                  return MyTile();
                },))
        ],
      ),
    );
  }
}