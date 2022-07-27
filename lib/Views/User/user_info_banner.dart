import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Database/database_constant.dart';
import 'package:tree_ar/Views/User/edit_user_page.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';

class UserInfoBanner extends StatefulWidget {
  const UserInfoBanner({Key? key}) : super(key: key);

  @override
  State<UserInfoBanner> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoBanner> {
  DataManager dataManager = DataManager();

  void _refreshData(bool areUpdated) {
    if (areUpdated) {
      print("Dati aggiornati allora aggiorna gui");
      dataManager.getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => dataManager,
        child: Consumer<DataManager>(
          builder: (context, value, child) {
            return FutureBuilder<User>(
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
                          ClipOval(
                            child: Image.asset(
                              usr.userImageName ??
                                  "$imagePath/userPlaceholder.jpeg",
                              height: 90,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  "$imagePath/userPlaceholder.jpeg",
                                  height: 90,
                                );
                              },
                            ),
                          ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                  Text("errore nel caricamnot info utente");
                } else {
                  return Text("Loading...");
                }
                return Text("data");
              },
            );
          },
        ));
  }
}
