import 'package:chatup/model/chart_room.dart';
import 'package:chatup/model/firebasee_helper.dart';
import 'package:chatup/model/user.dart';
import 'package:chatup/screens/chat/chat_room_page.dart';
import 'package:chatup/screens/chat/chat_search_screen.dart';
import 'package:chatup/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatup/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: const Text("ChatUp"),
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatrooms")
            .where("users", arrayContains: user!.uid)
            .orderBy("createdOn", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

              return ListView.builder(
                itemCount: chatRoomSnapshot.docs.length,
                itemBuilder: (context, index) {
                  ChatRoom chatRoom = ChatRoom.fromSnap(
                      chatRoomSnapshot.docs[index].data()
                          as Map<String, dynamic>);

                  Map<String, dynamic> participants = chatRoom.participants!;
                  List<String> participantsKeys = participants.keys.toList();
                  participantsKeys.remove(user.uid);

                  return FutureBuilder(
                    future:
                        FirebaseHelper.getUserModelById(participantsKeys[0]),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.data != null) {
                          User targetUser = snap.data as User;
                          return ListTile(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatRoomPage(
                                  chatRoom: chatRoom,
                                  targetUser: targetUser,
                                  user: user),
                            )),
                            visualDensity: VisualDensity.comfortable,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(targetUser.photoUrl),
                            ),
                            title: Text(targetUser.username),
                            subtitle: chatRoom.lastMessage!.isNotEmpty
                                ? Text(
                                    // participantsKeys[0] == user.uid
                                    // ?
                                    " ${chatRoom.lastMessage.toString()}"
                                    // : "Me: ${chatRoom.lastMessage.toString()}"
                                    ,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : const Text(
                                    "Say Hello",
                                    style: TextStyle(color: Colors.pink),
                                  ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                  child: Text(
                "No Chats",
                style: TextStyle(color: Colors.amber),
              ));
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        },
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const SearchChatScreen(),
          ));
        },
        backgroundColor: Colors.white,
        label: const Text(
          "Search",
          style: TextStyle(
            color: webBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
