import 'constant_vars.dart';

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.

  late List<String> _treeSaved;
  late List<bool> _badgeUnlocked;
  Profile? userData;

  DataManager() {
    _badgeUnlocked = List.empty(growable: true);
    _treeSaved = List.empty(growable: true);
    //Init saving user preferences and data
    //if there are saved data in json load them and init userData
  }

  void addTree(treeID) {
    _treeSaved.add(treeID);
  }

  List<String> getTree() {
    //from id of tree get information from source
    return _treeSaved.toList(growable: false);
  }

  List<bool> getBadges() {
    return _badgeUnlocked.toList(growable: false);
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

class Profile {
  String name;
  String surname;
  DateTime birth;
  String course;
  DateTime registrationDate;
  String? photoURI;

  Profile(this.name, this.surname, this.birth, this.course,
      this.registrationDate, this.photoURI);
}
