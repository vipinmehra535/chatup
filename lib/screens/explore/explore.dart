import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/navigation_provider.dart';
import 'package:instagram_clone_flutter/utils/color.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Widget? activePage;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    activePage = Provider.of<NavigationProvider>(context).currentState.page;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          cursorColor: Colors.white,
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search user',
            labelStyle: TextStyle(color: Colors.white),
          ),
          onFieldSubmitted: (value) {}, // abe ruk ek miin krr
        ),
      ),
      body: activePage,
    );
  }
}
