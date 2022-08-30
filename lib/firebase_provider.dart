import 'package:firebase_database/firebase_database.dart';
import 'Database/data_model.dart';

class FirebaseProvider {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<List<Tree>?> getTrees() async {
    List<Tree>? treeList;
    DataSnapshot snap = await ref.child('trees').get();
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
    DataSnapshot snap = await ref.child('projOfTree').get();

    if (snap.exists) {
      snap.children.map((snap) => snap.value as Map).forEach((elemMap) {
        relationships[elemMap['projName'] as String] = elemMap['treeId'] as int;
      });
    }

    return relationships.isEmpty ? null : relationships;
  }
}
