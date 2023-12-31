import 'package:chatup/model/chart_room.dart';
import 'package:chatup/model/user.dart';
import 'package:chatup/providers/user_provider.dart';
import 'package:chatup/screens/chat/chat_room_page.dart';
import 'package:chatup/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SearchChatScreen extends StatefulWidget {
  const SearchChatScreen({Key? key}) : super(key: key);

  @override
  State<SearchChatScreen> createState() => _SearchChatScreenState();
}

class _SearchChatScreenState extends State<SearchChatScreen> {
  final TextEditingController searchChatController = TextEditingController();

  bool isShown = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    Future<ChatRoom?> getChatRoom(var targetUser) async {
      ChatRoom chatRoom;

      //Creating Chatroom
      if (kDebugMode) {
        print(targetUser);
      }
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${user!.uid}", isEqualTo: true)
          .where("participants.$targetUser", isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        //Fetch the existing chatroom

        var docdata = snapshot.docs[0].data();
        var existingChatRoom =
            ChatRoom.fromSnap(docdata as Map<String, dynamic>);

        chatRoom = existingChatRoom;

        if (kDebugMode) {
          print("Chat Room already there");
        }
      } else {
        //create a chat room
        ChatRoom newchatRoom = ChatRoom(
          chatRoomId: const Uuid().v1(),
          participants: {
            user.uid.toString(): true,
            targetUser.toString(): true,
          },
          lastMessage: "",
          createdOn: DateTime.now(),
          users: [
            user.uid.toString(),
            targetUser.toString(),
          ],
        );

        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newchatRoom.chatRoomId)
            .set(newchatRoom.toJson());
        chatRoom = newchatRoom;

        if (kDebugMode) {
          print("Chat room  created !!");
        }
      }
      return chatRoom;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          autofocus: true,
          controller: searchChatController,
          decoration: const InputDecoration(
            labelText: 'Search',
          ),
          onFieldSubmitted: (String _) {
            if (kDebugMode) {
              print("sub $_");
            }
            setState(() {
              isShown = true;
            });
          },
        ),
      ),
      body: isShown
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isEqualTo: searchChatController.text,
                  )
                  .where(
                    "username",
                    isNotEqualTo: user!.username,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Some Error"));
                } else if (!snapshot.hasData ||
                    (snapshot.data as dynamic).docs.isEmpty) {
                  return const Center(child: Text("No User Found"));
                } else {
                  return ListView.builder(
                    itemCount: (snapshot.data as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          User searchedUser = User.fromMap(userMap);
                          ChatRoom? chatRoom =
                              await getChatRoom(searchedUser.uid);

                          if (chatRoom != null) {
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => ChatRoomPage(
                                    user: user,
                                    chatRoom: chatRoom,
                                    targetUser: searchedUser),
                              ));
                            }
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).docs[index]['username'],
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                        ),
                      );
                    },
                  );
                }
              },
            )
          : null,
    );
  }
}
