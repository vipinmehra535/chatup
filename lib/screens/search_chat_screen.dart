import 'package:chatup/screens/chat_room_page.dart';
import 'package:chatup/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const ChatRoomPage(),
                        )),
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
