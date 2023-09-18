// import 'package:chatup/model/user.dart';
import 'package:chatup/screens/chat/chat_search_screen.dart';
import 'package:chatup/utils/color.dart';
import 'package:flutter/material.dart';
// import 'package:chatup/providers/user_provider.dart';
// import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    // final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: const Text("ChatUp"),
      ),
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
