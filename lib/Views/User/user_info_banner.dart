import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Database/database_constant.dart';
import 'package:tree_ar/Views/User/edit_user_page.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:tree_ar/utils.dart';

class UserInfoBanner extends StatefulWidget {
  const UserInfoBanner({Key? key}) : super(key: key);

  @override
  State<UserInfoBanner> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoBanner> {
  void _refreshData(bool areUpdated) async {
    if (areUpdated) {
      print("Dati aggiornati allora aggiorna gui");

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataManager>(
      builder: (context, dataManager, child) => FutureBuilder<User>(
        future: dataManager.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var usr = snapshot.data ?? defaultUser;

            return Expanded(
                child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserInfoPage(user: usr),
                  ),
                ).then((value) => _refreshData(value))
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.all(radiusCorner),
                ),
                child: Row(
                  children: [
                    //Profile image
                    getUserImageWidget(usr.userImageName),
                    Flexible(
                      //User info
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usr.getNameSurname(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Data Nascita: ${usr.dateBirth ?? "no data"}",
                                    style: const TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: darkGray),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              usr.course ?? "no course info",
                              style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: darkGray,
                              ),
                            ),
                            Text(
                              "Immatricolato il: ${usr.registrationDate ?? 'no info'}",
                              style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: darkGray),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
          } else if (snapshot.hasError) {
            const Text("errore nel caricamento info utente");
          } else {
            return const Text("Loading...");
          }
          return const Text("data");
        },
      ),
    );
  }
}
