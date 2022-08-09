import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'Database/dataModel.dart';

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
}
