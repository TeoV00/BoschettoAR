import 'package:firebase_database/firebase_database.dart';
import 'package:tree_ar/DataModel/data_model.dart';

class FirebaseProvider {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<List<Tree>?> getTrees() async {
    List<Tree>? treeList;
    DataSnapshot snap = await _getSnapshotOf('trees');
    if (snap.exists) {
      treeList = snap.children
          .map((snap) =>
              Tree.fromMap(Map<String, dynamic>.from(snap.value as Map)))
          .toList();
    }
    return treeList;
  }

  Future<Map<String, int>?> getRelationshipProjAndTree() async {
    Map<String, int>? relationships = {};
    DataSnapshot snap = await _getSnapshotOf('projOfTree');

    if (snap.exists) {
      snap.children.map((snap) => snap.value as Map).forEach((elemMap) {
        relationships[elemMap['projName'] as String] = elemMap['treeId'] as int;
      });
    }

    return relationships.isEmpty ? null : relationships;
  }

  Future<List<TotemInfo>?> getTotems() async {
    List<TotemInfo>? totems;
    DataSnapshot snap = await _getSnapshotOf('totemInfo');
    if (snap.exists) {
      totems = snap.children
          .map((snap) => TotemInfo.fromMap(
                totemId: snap.key!,
                totemData: Map<String, dynamic>.from(snap.value as Map),
              ))
          .toList();
    }
    return totems;
  }

  //TODO: metodo che carica i dati della app sul firebase
  // https://boschetto-unibo-cesena-default-rtdb.europe-west1.firebasedatabase.app/totems/ces_remade

  Future<DataSnapshot> _getSnapshotOf(final String location) async {
    return ref.child(location).get();
  }
}
