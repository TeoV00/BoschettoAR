import 'constant_vars.dart';

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  static List<String> getDataOf(InfoType dataType) {
    if (dataType == InfoType.PROJECT) {
      return <String>['G', 'e', 'f', 'd', 'e', 'f', 'd'];
    } else {
      return <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
    }
  }
}
