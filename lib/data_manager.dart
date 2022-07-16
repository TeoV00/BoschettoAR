import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  //TODO: save in user preferences user id
  static DatabaseProvider dbProvider = DatabaseProvider.dbp;
  var localTreeCopy = List.empty(); //TODO: fill it with online trees

  DataManager() {
    //Init saving user preferences and data
    //if there are saved data in json load them and init userData
    //copy all online trees in local db --> then keep a list of them
  }

  // GETTER methods
  Future<Map<InfoType, List>> getUserTreesProject(int userId) async {
    //from id of tree get information from source
    final trees = await dbProvider.getUserTrees(userId);
    final projc = await dbProvider.getUserProjects(userId);
    return {
      InfoType.tree: trees,
      InfoType.project: projc,
    };
  }

  Future<List<Badge>> getBadges(int userId) {
    return dbProvider.getUserBadges(userId);
  }

  static int getCurrentUserId() {
    //the app for now not support multi user
    return DEFAULT_USER_ID;
  }

  //ADDING methods
  static void addUserTree(int userId, int treeId) {
    dbProvider.addUserTree(userId, treeId);
  }

  static void unlockUserBadge(int userId, int idBadge) {
    dbProvider.addUserBadge(userId, idBadge);
  }

  static bool isValidTreeCode(String qrData) {
    //TODO: get valid ids from online server or from cached trees donwloade form online db
    return true;
  }
}
