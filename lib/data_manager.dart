import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';
import 'UtilsModel.dart';

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;

  int currentUserId = DEFAULT_USER_ID; //next feature could be multiuser in app

  //Snapshot Variables used as place of return vars of async method
  Map<UserData, dynamic>? userData; // snapshot user data from db
  Tree? treeByQrCodeId; // result of request treeById
  Project? projByQrCodeId;
  late Map<InfoType, List> userTreeAndProj;

  bool loadHasFinished = false;

  DataManager() {
    resetCacheVars();
    var emptyList = List.empty(growable: true);
    userTreeAndProj = {InfoType.tree: emptyList, InfoType.project: emptyList};
    pullTreeDataInDb();
  }

  void pullTreeDataInDb() {
    dbProvider.insertTree(Tree(
        treeId: 1,
        name: "me",
        descr: "descr",
        height: 100,
        diameter: 10,
        co2: 203));
    dbProvider.insertTree(Tree(
        treeId: 2,
        name: "222",
        descr: "222",
        height: 222,
        diameter: 22,
        co2: 223));
  }
  //TODO: metodo che copia gli alberi da server online a db locale
  //TODO: save in user preferences user id

  ///get user info then when received, cache data to var then notify listeners
  getUserData() async {
    resetCacheVars();
    var user = await dbProvider.getUserInfo(currentUserId);
    Statistics stats = await _calculateStats();

    userData = {UserData.info: user, UserData.stats: stats};
    notifyListeners();
  }

  Future<Statistics> _calculateStats() async {
    int totCo2 = 0;
    try {
      List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
      totCo2 = trees
          .map((e) => e.co2)
          .reduce((co2Total, treeCo2) => co2Total += treeCo2);
    } catch (e) {
      totCo2 = 0;
    }

    //TODO: il numero di fogli di carta li prendo dalla stessa fonte della verione
    //web cosi come i kg di co2 per ciascun progetto
    //TODO: la carta prendo in considerazione quella del progetto e non quella che
    //l'albero sarebbe in grado di catturare
    var papers = 202; //prendo

    return Statistics(papers, totCo2);
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
    resetCacheVars();

    //from id of tree get information from source
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await dbProvider.getUserProjects(currentUserId);
    print(trees.toString());
    // set data manager snapshot
    userTreeAndProj = {
      InfoType.tree: trees,
      InfoType.project: projc,
    };
    notifyListeners();
  }

  // void getTreeById(int id) {
  //   dbProvider.getTree(id).then((tree) => {treeByQrCodeId = tree});
  //   notifyListeners();
  // }

  // void getProjectById(int id) {
  //   dbProvider.getProject(id).then((proj) => projByQrCodeId = proj);
  //   notifyListeners();
  // }

  Future<List<Badge>> getBadges() {
    return dbProvider.getUserBadges(currentUserId);
  }

  //SETTER methods
  void addUserTree(int treeId) {
    dbProvider.addUserTree(currentUserId, treeId);
  }

  void unlockUserBadge(int idBadge) {
    dbProvider.addUserBadge(currentUserId, idBadge);
    notifyListeners();
  }

  void isValidTreeCode(String qrData) async {
    var treeId = int.parse(qrData);
    treeByQrCodeId = Tree(
        treeId: 1,
        name: "name",
        descr: "descr",
        height: 100,
        diameter: 10,
        co2: 252); //await dbProvider.getTree(treeId);
    projByQrCodeId = Project(
        projectId: 1,
        treeId: 1,
        name: "name",
        descr: "descr",
        link: "link"); //await dbProvider.getProject(treeId);

    loadHasFinished = true;
    notifyListeners();
  }

  ///remember to call this method to reset return vars that can be used in other screen
  ///in order to make app work fine, its a workaround to return values of async functions
  void resetCacheVars() {
    userData = null;
    treeByQrCodeId = null;
    projByQrCodeId = null;
    loadHasFinished = false;
    var emptyList = List.empty(growable: true);
    userTreeAndProj = {InfoType.tree: emptyList, InfoType.project: emptyList};
  }
}
