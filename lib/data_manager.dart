import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';
import 'UtilsModel.dart';
import 'package:collection/collection.dart' as coll;

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;
  int currentUserId = DEFAULT_USER_ID; //next feature could be multiuser in app

  //Snapshot Variables used as place of return vars of async method
  Map<UserData, dynamic>? userData; // snapshot user data from db
  Tree? treeByQrCodeId; // result of request treeById
  Project? projByQrCodeId;
  Map<InfoType, List<dynamic>> userTreeAndProj = {
    InfoType.tree: List.empty(),
    InfoType.project: List.empty(),
  };

  bool loadHasFinished = false;

  DataManager() {
    resetCacheVars();
    pullTreeDataInDb();
  }

  void pullTreeDataInDb() {}
  //TODO: metodo che copia gli alberi da server online a db locale
  //TODO: save in user preferences user id

  ///get user info then when received, cache data to var then notify listeners
  getUserData() async {
    print("getUser data");
    resetCacheVars();
    var user = await dbProvider.getUserInfo(currentUserId);
    Statistics stats = await _calculateStats();

    Map<Badge, bool> badges = {};
    var userBadges = await getUnlockedBadges();
    var allBadge = await dbProvider.getAllBadges();
    Set<int> userBadgesSet = userBadges.map((e) => e.id).toSet();

    for (var domainBadge in allBadge) {
      badges.addAll({domainBadge: userBadgesSet.contains(domainBadge.id)});
    }

    //prendo tutti i badge poi li ordino e a ciascuno dico se l'utente l'ha sbloccato o no
    userData = {
      UserData.info: user,
      UserData.stats: stats,
      UserData.badge: badges
    };
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

    var pogress = 0.8; //get that info from gameController
    return Statistics(papers, totCo2, pogress);
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
    //retrieve data saved in database - local memory
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await dbProvider.getUserProjects(currentUserId);

    //unpack current user trees and project listes
    List<Tree> currTrees = (userTreeAndProj[InfoType.tree] ?? []).cast<Tree>();
    List<Project> currProj =
        (userTreeAndProj[InfoType.project] ?? []).cast<Project>();

    //compares list and update them only if current are older
    if (trees.length != currTrees.length && projc.length != currProj.length) {
      print("I dati mostrati vengono aggiiornati");
      userTreeAndProj = {
        InfoType.tree: trees,
        InfoType.project: projc,
      };
      notifyListeners();
    } else {
      print("dati invariati");
    }
  }

  Future<List<Badge>> getUnlockedBadges() {
    return dbProvider.getUserBadges(currentUserId);
  }

  //SETTER methods
  void addUserTree(int treeId) async {
    await dbProvider.addUserTree(currentUserId, treeId);
  }

  void unlockUserBadge(int idBadge) {
    dbProvider.addUserBadge(currentUserId, idBadge);
    notifyListeners();
  }

  void isValidTreeCode(String qrData) async {
    print("isValidtreeCode Called");
    var treeId = int.parse(qrData);
    treeByQrCodeId =
        // Tree(
        //     treeId: 1,
        //     name: "name",
        //     descr: "descr",
        //     height: 100,
        //     diameter: 10,
        //     co2: 252);
        await dbProvider.getTree(treeId);
    projByQrCodeId =
        // Project(
        //     projectId: 1,
        //     treeId: 1,
        //     name: "name",
        //     descr: "descr",
        //     link: "link");
        await dbProvider.getProject(treeId);

    if (treeByQrCodeId != null && projByQrCodeId != null) {
      addUserTree(treeId);
    }

    loadHasFinished = true;
    notifyListeners();
  }

  ///remember to call this method to reset return vars that can be used in other screen
  ///in order to make app work fine, its a workaround to return values of async functions
  void resetCacheVars() {
    print("reset Chached vars");
    userData = null;
    treeByQrCodeId = null;
    projByQrCodeId = null;
    loadHasFinished = false;
    var emptyList = List.empty(growable: true);
  }
}
