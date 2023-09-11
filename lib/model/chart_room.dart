import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId;
  final List participants;

  const ChatRoom({
    required this.chatRoomId,
    required this.participants
   
  });

  static ChatRoom fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatRoom(
      chatRoomId: snapshot["chatRoomId"],
      participants: snapshot["participants"],
    );
  }

  Map<String, dynamic> toJson() => {
        "chatRoomId": chatRoomId,
        "participants": participants,
        
      };
}
