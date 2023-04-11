import 'package:flutter/material.dart';
import 'package:tree_ar/Views/UploadProgress/common_widgets.dart';
import 'package:tree_ar/Views/UploadProgress/scanqr_totem.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
import 'package:tree_ar/Views/Utils/bullet_list.dart';
import 'package:tree_ar/constant_vars.dart';

const pageTitle = "Deposita progressi";
const nickname = "TeoV00";

class SharePorgressPage extends StatelessWidget {
  const SharePorgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Deposita progressi", context),
      body: BottomGrass(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "In questa sezione potrai depositare i tuoi progressi per gareggiare contro gli altri e rendere il bosco virtuale rigoglioso!",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            LayoutBuilder(
              builder: (context, constraint) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(255, 247, 180, 1),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                            color: Color.fromRGBO(0, 0, 0, 0.25))
                      ]),
                  width: constraint.maxWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: const [
                      Text(
                        "Dati condivisi",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      BulletList([
                        "nickname",
                        "numero dei badge",
                        "percentuale progresso",
                        "contatori risparmi (co2, carta, elettricità, benzina)"
                      ]),
                      Text("I dati saranno condivisi con il nickname:"),
                      Text(
                        nickname,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Image.asset("assets/images/growing_trees.png"),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Più alberi scannerizzi e badge acquisisci più il tuo albero sarà rigoglioso!!",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            LayoutBuilder(builder: (context, constraint) {
              return MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: constraint.maxWidth,
                height: 50,
                textColor: Colors.white,
                color: mainColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ScanTotemQR();
                  }),
                ),
                child: const Text(
                  "Procedi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
