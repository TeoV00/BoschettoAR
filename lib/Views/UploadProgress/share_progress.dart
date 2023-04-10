import 'package:flutter/material.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
import 'package:tree_ar/constant_vars.dart';

const pageTitle = "Deposita progressi";
const nickname = "TeoV00";

class SharePorgressPage extends StatelessWidget {
  const SharePorgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(pageTitle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BottomGrass(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
                "In questa sezione potrai depositare i tuoi progressi e gareggiare contro gli altri."),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: const [
                  Text("I dati saranno condivisi sotto il nickname:"),
                  Text(
                    nickname,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color.fromRGBO(255, 247, 180, 1),
              padding: const EdgeInsets.all(8),
              child: const Text("kkk"),
            ),
            Image.asset("assets/images/growing_trees.png"),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  "Più alberi scannerizzi e badge acquisisci più il tuo albero sarà rigoglioso!!"),
            ),
            LayoutBuilder(builder: (context, constraint) {
              return MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: constraint.maxWidth,
                height: 50,
                textColor: Colors.white,
                color: mainColor,
                onPressed: () {},
                child: const Text(
                  "Procedi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            })
          ],
        ),
      )),
    );
  }
}
