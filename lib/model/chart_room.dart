class ChatRoom {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  DateTime? createdOn;
  List<dynamic>? users;

  ChatRoom({
    this.chatRoomId,
    this.participants,
    this.lastMessage,
    this.createdOn,
    this.users,
  });

  static ChatRoom fromSnap(Map<String, dynamic> map) {
    return ChatRoom(
      chatRoomId: map["chatRoomId"],
      participants: map["participants"],
      lastMessage: map["lastMessage"],
      createdOn: map["createdOn"].toDate(),
      users: map["users"],
    );
  }

  Map<String, dynamic> toJson() => {
        "chatRoomId": chatRoomId,
        "participants": participants,
        "lastMessage": lastMessage,
        "createdOn": createdOn,
        "users": users,
      };
}
