import 'package:chatup/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatup/model/user.dart';
import 'package:chatup/providers/user_provider.dart';
import 'package:chatup/resources/firebase_methods.dart';
import 'package:chatup/screens/comment/comments_screen.dart';
import 'package:chatup/utils/color.dart';
import 'package:chatup/utils/utils.dart';
import 'package:chatup/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  User? user;

  @override
  void initState() {
    getComments();

    super.initState();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
      setState(() {});
    } catch (e) {
      if (mounted) {
        showSnackBar(
          e.toString(),
          context,
        );
      }
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    final Size size = MediaQuery.sizeOf(context);
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : Container(
            decoration: BoxDecoration(
              color: mobileBackgroundColor,
              border: Border.all(
                  color: size.width > webScreenSize
                      ? secondaryColor
                      : webBackgroundColor),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                //Header Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          widget.snap["profImage"],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${widget.snap['username']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => Dialog(
                            //     child: ListView(
                            //       padding:
                            //           const EdgeInsets.symmetric(vertical: 16),
                            //       shrinkWrap: true,
                            //       children: ['Delete']
                            //           .map(
                            //             (e) => InkWell(
                            //               onTap: () {},
                            //               child: Container(
                            //                 padding: const EdgeInsets.symmetric(
                            //                     vertical: 12, horizontal: 16),
                            //                 child: Text(e),
                            //               ),
                            //             ),
                            //           )
                            //           .toList(),
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(Icons.more_vert))
                    ],
                  ),
                ),

                // IMAGE SECTION OF THE POST
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user!.uid,
                      widget.snap['likes'],
                    );

                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // LIKE, COMMENT SECTION OF THE POST
                Row(
                  children: <Widget>[
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(user!.uid),
                      smallLike: true,
                      child: IconButton(
                        icon: widget.snap['likes'].contains(user!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              widget.snap['postId'].toString(),
                              user!.uid,
                              widget.snap['likes']);
                        },
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.comment_outlined,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return CommentsScreen(
                                  snap: widget.snap,
                                );
                              },
                            ),
                          );
                        }),
                    IconButton(
                        icon: const Icon(
                          Icons.send,
                        ),
                        onPressed: () {}),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {}),
                    ))
                  ],
                ),
                //DESCRIPTION AND NUMBER OF COMMENTS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.snap['likes'].length == 0
                          // widget.snap['likes'].contains(user!.uid)
                          ? Container()
                          : DefaultTextStyle(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w800),
                              child: Text(
                                '${widget.snap['likes'].length} likes',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.snap['username'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: commentLen == 0
                                ? Container()
                                : Text(
                                    "View all ${commentLen.toString()} comments",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CommentsScreen(snap: widget.snap),
                            ));
                          }),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
