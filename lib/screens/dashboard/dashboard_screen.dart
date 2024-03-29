import 'package:dashboard/responsive.dart';
import 'package:dashboard/screens/dashboard/components/my_files.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/marches_page.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child : MyFiles(),
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Crypto Coins",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Container(
                        height: 500, // hauteur
                        child: MarchesPage(),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
