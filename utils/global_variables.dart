import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatup/screens/addpost/add_post_screen.dart';
import 'package:chatup/screens/feed/feed_Screen.dart';
import 'package:chatup/screens/profile/profile_screen.dart';
import 'package:chatup/screens/search/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
