import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String sender;
  final String messageText;
  final DateTime createdOn;
  final bool seen;

  const Message({
    required this.messageId,
    required this.sender,
    required this.messageText,
    required this.createdOn,
    required this.seen,
  });

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
        messageId: snapshot["messageId"],
        sender: snapshot["chatRoomId"],
        messageText: snapshot["participants"],
        createdOn: snapshot["createdOn"].toDate(),
        seen: snapshot["seen"]);
  }

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "chatRoomId": sender,
        "participants": messageText,
        "createdOn": createdOn,
        "seen": seen
      };
}
