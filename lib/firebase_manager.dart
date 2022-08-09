import 'package:firebase_database/firebase_database.dart';

class FirebaseProvider {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void printData() async {
    DataSnapshot snap = await ref.child('trees').get();
    if (snap.exists) {
      print(snap.value.toString());
    }
  }
}
