import 'constant_vars.dart';

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  static List<String> getDataOf(InfoType dataType) {
    if (dataType == InfoType.project) {
      return <String>['G', 'e', 'f', 'd', 'e', 'f', 'd'];
    } else {
      return <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
    }
  }

  static String getTreeNameById(int treeId) {
    return "Gingobiloba africano - Nord Africa";
  }

  static void addUserTree(int treeId) {
    //TODO: save in user profile the new tree unlocked
    //update all statistics and badge unlocking
  }

  static bool isValidTreeCode(String qrData) {
    //TODO: check if scanned qr contains a treeId and is valid
    //if not valid return false
    return false;
  }
}
