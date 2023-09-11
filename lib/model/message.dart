import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final List messageText;
  final DateTime createdOn;
  final bool seen;

  const Message({
    required this.sender,
    required this.messageText,
    required this.createdOn,
    required this.seen,
  });

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
        sender: snapshot["chatRoomId"],
        messageText: snapshot["participants"],
        createdOn: snapshot["createdOn"].toDate(),
        seen: snapshot["seen"]);
  }

  Map<String, dynamic> toJson() => {
        "chatRoomId": sender,
        "participants": messageText,
        "createdOn": createdOn,
        "seen": seen
      };
}
