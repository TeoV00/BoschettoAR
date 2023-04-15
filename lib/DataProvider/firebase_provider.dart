import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tree_ar/DataModel/data_model.dart';
import 'package:tree_ar/DataModel/share_data_model.dart';
import 'package:tree_ar/Views/UploadProgress/share_progress.dart';

class FirebaseProvider {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

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

  Future<void> uploadUserData({
    required String totemId,
    required SharedData data,
  }) async {
    var totemData = await _getTotemData(totemId: totemId);
    int lastIndex = totemData.length;
    int usrIdx = totemData.indexWhere((e) => e.nickname == nickname);
    int uploadIdx = usrIdx >= 0 ? usrIdx : lastIndex;

    log("lastIdx: $lastIndex\nusrIdx: $usrIdx\nuploadIds: $uploadIdx");
    return await ref.child('totems/$totemId/$uploadIdx').update(data.toMap());
  }

  Future<DataSnapshot> _getSnapshotOf(final String location) async {
    return ref.child(location).get();
  }

  Future<List<SharedData>> _getTotemData({required String totemId}) async {
    var totemSnap = await ref.child('totems/$totemId/').get();

    return totemSnap.children
        .map((child) => SharedData.fromMap(
            data: Map<String, dynamic>.from(child.value as Map)))
        .toList();
  }
}
