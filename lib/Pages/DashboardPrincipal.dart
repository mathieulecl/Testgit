import 'package:flutter/material.dart';

class DashboardPrincipal extends StatelessWidget {
  const DashboardPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Statistiques"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView(
            children: [Card(
              child: ListTile(
                leading: Image.asset("assets/image/touati.jpg"),
                title: Text('Marc Touati'),
                subtitle: Text("Bientôt un krash plus grave qu'en 1929 ?"),
                trailing: Icon(Icons.more_vert),
              ),
            ),Card(
              child: ListTile(
                leading: Image.asset("assets/image/artus.jpg"),
                title: Text('Patrick Artus'),
                subtitle: Text('La bourse dans les prochains mois'),
                trailing: Icon(Icons.more_vert),
              ),
            ),Card(
              child: ListTile(
                leading: Image.asset("assets/image/bouzou.jpg"),
                title: Text('Nicolas Bouzou'),
                subtitle: Text("Inflation en France"),
                trailing: Icon(Icons.more_vert),
              ),
            ),],

          ),
        )
    );
  }
}