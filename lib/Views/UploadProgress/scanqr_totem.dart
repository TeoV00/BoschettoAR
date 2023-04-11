import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_ar/Views/DetailsPageView/details_box_container.dart';
import 'package:tree_ar/Views/UploadProgress/common_widgets.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
import 'package:tree_ar/constant_vars.dart';

const String helpGuide =
    "Recati nel totem più vicino, clicca sul pulsante “Deposita Progressi APP” e scansiona il Qr code";

class ScanTotemQR extends StatefulWidget {
  const ScanTotemQR({super.key});

  @override
  State<StatefulWidget> createState() => ScanTotemQRState();
}

class ScanTotemQRState extends State<ScanTotemQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar("Scansione Totem", context),
      body: BottomGrass(
        childOnGrass: Image.asset(
          "$imagePath/arrow_vase.png",
          height: 120,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                DetailsBox(
                  childBox: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      helpGuide,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
