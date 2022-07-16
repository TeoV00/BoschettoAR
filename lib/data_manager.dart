import 'package:tree_ar/Database/database.dart';
import 'Database/dataModel.dart';

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  //TODO: save in user preferences user id
  static DatabaseProvider dbProvider = DatabaseProvider.dbp;

  DataManager() {
    //Init saving user preferences and data
    //if there are saved data in json load them and init userData
  }

  Future<List<Tree>> getScannedUserTrees(int userId) {
    //from id of tree get information from source
    return dbProvider.getUserTrees(userId);
  }

  Future<List<Badge>> getBadges(int userId) {
    return dbProvider.getUserBadges(userId);
  }

  static void addUserTree(int userId, int treeId) {
    dbProvider.addUserTree(userId, treeId);
  }

  static void unlockUserBadge(int userId, int idBadge) {
    dbProvider.addUserBadge(userId, idBadge);
  }

  static bool isValidTreeCode(String qrData) {
    //TODO: check if scanned qr contains a treeId and is valid
    //if not valid return false
    return false;
  }
}
