import 'package:chatup/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Expanded(
            //   child: Container(),
            // ),
            TextFieldInput(
              textEditingController: textEditingController,
              hintText: "Enter text",
              textInputType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
