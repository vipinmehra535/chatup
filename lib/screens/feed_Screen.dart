import 'package:chatup/screens/chat_screen.dart';
import 'package:chatup/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatup/utils/color.dart';
import 'package:chatup/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: size.width > webScreenSize
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: size.width > webScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                "chatUp",
              ),

              //  SvgPicture.asset(
              //   "assets/ic_instagram.svg",
              //   color: primaryColor,
              //   height: 32,
              // ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  )),
                  icon: const Icon(Icons.messenger_outline),
                )
              ],
            ),
      body: StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              color: primaryColor,
              axisDirection: AxisDirection.down,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        size.width > webScreenSize ? size.width * 0.3 : 0,
                    vertical: size.width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data?.docs[index].data(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
