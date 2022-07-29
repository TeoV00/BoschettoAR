import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';
import 'utils.dart';
import 'package:collection/collection.dart' as coll;

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;
  int currentUserId = DEFAULT_USER_ID; //next feature could be multiuser in app

  //Snapshot Variables used as place of return vars of async method
  Map<UserData, dynamic>? userData; // snapshot user data from db

  Tree? treeByQrCodeId; // result of request treeById
  Project? projByQrCodeId;

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

    Statistics stats = await _calculateStats();

    Map<Badge, bool> badges = {};
    var userBadges = await getUnlockedBadges();
    var allBadge = await dbProvider.getAllBadges();
    Set<int> userBadgesSet = userBadges.map((e) => e.id).toSet();

    for (var domainBadge in allBadge) {
      badges.addAll({domainBadge: userBadgesSet.contains(domainBadge.id)});
    }

    //prendo tutti i badge poi li ordino e a ciascuno dico se l'utente l'ha sbloccato o no
    userData = {UserData.stats: stats, UserData.badge: badges};
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

  ///update current logged-in user's info
  ///return true if any edit has been done, false if anything was not updated
  /// or there was any problem
  Future<bool> updateCurrentUserInfo(User user) async {
    var res = await dbProvider.updateUserInfo(
      currentUserId,
      user.name,
      user.surname,
      user.dateBirth,
      user.course,
      user.registrationDate,
      user.userImageName,
    );
    return res;
  }

  ///Update snapshot of userInfo from db
  ///return true if data are on db and snapshot is updated
  Future<User> getUserInfo() async {
    var user = await dbProvider.getUserInfo(currentUserId);
    return user ?? defaultUser;
  }

  Future<Map<InfoType, List<dynamic>>> getUserTreesProject() async {
    //retrieve data saved in database - local memory
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await dbProvider.getUserProjects(currentUserId);

    var userTreeAndProj = {
      InfoType.tree: trees,
      InfoType.project: projc,
    };

    return userTreeAndProj;
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
    treeByQrCodeId = await dbProvider.getTree(treeId);
    projByQrCodeId = await dbProvider.getProject(treeId);

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
    treeByQrCodeId = null;
    projByQrCodeId = null;
    loadHasFinished = false;
    var emptyList = List.empty(growable: true);
  }
}
