import 'package:chatup/utils/color.dart';
import 'package:chatup/utils/global_variables.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController pageController;
  // for tabs animation
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: webBackgroundColor,
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
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => navigationTapped(0),
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : secondaryColor,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => navigationTapped(1),
            icon: Icon(
              Icons.search,
              color: (_page == 1) ? primaryColor : secondaryColor,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () => navigationTapped(2),
            icon: Icon(
              Icons.add_reaction_outlined,
              color: (_page == 2) ? primaryColor : secondaryColor,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () => navigationTapped(3),
            icon: Icon(
              Icons.person,
              color: (_page == 3) ? primaryColor : secondaryColor,
            ),
          )
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: homeScreenItems,
      ),
    );
  }
}
