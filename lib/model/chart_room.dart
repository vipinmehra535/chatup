class ChatRoom {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoom({
    this.chatRoomId,
    this.participants,
    this.lastMessage,
  });

  static ChatRoom fromSnap(Map<String, dynamic> map) {
    return ChatRoom(
      chatRoomId: map["chatRoomId"],
      participants: map["participants"],
      lastMessage: map["lastMessage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "chatRoomId": chatRoomId,
        "participants": participants,
        "lastMessage": lastMessage
      };
}
