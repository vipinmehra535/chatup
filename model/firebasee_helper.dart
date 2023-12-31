import 'package:chatup/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<User?> getUserModelById(String uid) async {
    User? user;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      user = User.fromSnap(docSnap);
    }

    return user;
  }
}
