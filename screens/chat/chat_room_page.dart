import 'package:chatup/model/chart_room.dart';
import 'package:chatup/model/message.dart';
import 'package:chatup/model/user.dart';
import 'package:chatup/providers/user_provider.dart';
import 'package:chatup/utils/color.dart';
import 'package:chatup/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final User targetUser;
  final User user;

  const ChatRoomPage({
    Key? key,
    required this.chatRoom,
    required this.targetUser,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    User? user = Provider.of<UserProvider>(context).getUser;
    void sendMessage() async {
      String msg = textEditingController.text.trim();
      if (msg != "") {
        //send Message

        Message newMessage = Message(
          messageId: const Uuid().v1(),
          sender: widget.user.uid,
          messageText: msg,
          createdOn: DateTime.now(),
          seen: false,
        );

        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatRoomId)
            .collection("messages")
            .doc(newMessage.messageId)
            .set(newMessage.toJson());
        widget.chatRoom.lastMessage = msg;
        widget.chatRoom.createdOn = DateTime.now();

        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatRoomId)
            .set(widget.chatRoom.toJson());
        if (kDebugMode) {
          print("Message Send");
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileSearchColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.targetUser.username),
            CircleAvatar(
              backgroundColor: mobileSearchColor,
              backgroundImage: NetworkImage(widget.targetUser.photoUrl),
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoom.chatRoomId)
                      .collection("messages")
                      .orderBy("createdOn", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnap = snapshot.data as QuerySnapshot;
                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnap.docs.length,
                            itemBuilder: (context, index) {
                              Message currentMessage =
                                  Message.fromSnap(dataSnap.docs[index]);
                              return Row(
                                mainAxisAlignment:
                                    (currentMessage.sender == user!.uid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        color:
                                            (currentMessage.sender == user.uid)
                                                ? Colors.pinkAccent
                                                : Colors.pink,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width / 2),
                                      child: Text(
                                        currentMessage.messageText.toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              "An error occured 'check your internet connection'"),
                        );
                      } else {
                        return const Center(
                          child: Text("Say Hi to new Freind"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: TextFieldInput(
                    textEditingController: textEditingController,
                    hintText: "Enter Message",
                    textInputType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    sendMessage();
                    textEditingController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
