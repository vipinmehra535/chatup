import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatup/utils/color.dart';
import 'package:chatup/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

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
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CupertinoTabBar(
          onTap: navigationTapped,
          currentIndex: _page,
          backgroundColor:
              //  size.width > webScreenSize
              //     ? webBackgroundColor
              //     :
              mobileBackgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: (_page == 0) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: (_page == 1) ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_reaction_outlined,
                  color: (_page == 2) ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: (_page == 3) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
