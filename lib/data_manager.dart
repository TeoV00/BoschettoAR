import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;

  int currentUserId = DEFAULT_USER_ID; //next feature could be multiuser in app
  User? userData; // var to chache user data from db
  late Map<InfoType, List> userTreeAndProj;

  DataManager() {
    var emptyList = List.empty(growable: true);
    userTreeAndProj = {InfoType.tree: emptyList, InfoType.project: emptyList};
  }

  //TODO: metodo che copia gli alberi da server online a db locale
  //TODO: save in user preferences user id

  ///get user info then when received, cache data to var then notify listeners
  getUser() async {
    var user = await dbProvider.getUserInfo(currentUserId);
    userData = user;
    notifyListeners();
  }

  void updateUserInfo(
    int userId,
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    await dbProvider.updateUserInfo(userId, name, surname, dateBirth, course,
        registrationDate, userImageName);
  }

  void getUserTreesProject() async {
    //from id of tree get information from source
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await dbProvider.getUserProjects(currentUserId);

    // set data manager var
    userTreeAndProj = {
      InfoType.tree: trees,
      InfoType.project: projc,
    };
    notifyListeners();
  }

  Tree? getTreeById(int id) {
    Tree? result;
    dbProvider.getTree(id).then((tree) => {result = tree});
    return result;
  }

  Project? getProjectById(int id) {
    Project? result;
    dbProvider.getProject(id).then((proj) => result = proj);
    return result;
  }

  Future<List<Badge>> getBadges() {
    return dbProvider.getUserBadges(currentUserId);
  }

  //SETTER methods
  void addUserTree(int treeId) {
    dbProvider.addUserTree(currentUserId, treeId);
    notifyListeners();
  }

  void unlockUserBadge(int idBadge) {
    dbProvider.addUserBadge(currentUserId, idBadge);
    notifyListeners();
  }

  Future<bool> isValidTreeCode(String qrData) async {
    var treeId = int.parse(qrData);
    var isValidTreeId = await dbProvider.isValidTree(treeId);
    print(
        "tree with id: $treeId ${isValidTreeId ? "ESISTE-VALIDO" : "NON VALIDO"}");
    return isValidTreeId;
  }
}
