import 'package:flutter/material.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
import 'package:tree_ar/constant_vars.dart';

class FirstLaunchGuide extends StatefulWidget {
  const FirstLaunchGuide({super.key});

  @override
  State<FirstLaunchGuide> createState() => FirstLaunchGuideState();
}

class FirstLaunchGuideState extends State<FirstLaunchGuide> {
  @override
  Widget build(BuildContext context) {
    return BottomGrass(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Benvenuto in $appName!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Image.asset("$imagePath/forest1.png"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Con questa app scoprirai quanto ha risparmiato l'università di Bologna nelle sue iniziative e progetti con il supporto della realtà aumentata.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const Spacer(flex: 2),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Inizia subito a scannerizzare i codici QR sugli alberi!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Image.asset("$imagePath/down-arrow.png"),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
