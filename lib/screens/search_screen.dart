import 'package:chatup/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:chatup/screens/profile_screen.dart';
import 'package:chatup/utils/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search',
            ),
            onFieldSubmitted: (String _) {
              if (kDebugMode) {
                print("sub $_");
              }
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers == true
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'username',
                      isEqualTo: searchController.text,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
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
                  } else {
                    return (snapshot.data! as dynamic).docs == null
                        ? const Center(child: Text("No User Found"))
                        : ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['photoUrl'],
                                    ),
                                    radius: 16,
                                  ),
                                  title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                  ),
                                ),
                              );
                            },
                          );
                  }

                  // if (!snapshot.hasData) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }
                  // return ListView.builder(
                  //   itemCount: (snapshot.data! as dynamic).docs.length,
                  //   itemBuilder: (context, index) {
                  //     return InkWell(
                  //       // onTap: () => Navigator.of(context).push(
                  //       //   MaterialPageRoute(
                  //       //     builder: (context) => ProfileScreen(
                  //       //       uid: (snapshot.data! as dynamic).docs[index]['uid'],
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       child: ListTile(
                  //         leading: CircleAvatar(
                  //           backgroundImage: NetworkImage(
                  //             (snapshot.data! as dynamic).docs[index]['photoUrl'],
                  //           ),
                  //           radius: 16,
                  //         ),
                  //         title: Text(
                  //           (snapshot.data! as dynamic).docs[index]['username'],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
              )
            // :
            //  Container());
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return MasonryGridView.count(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          size.width > webScreenSize ? size.width * 0.3 : 0,
                      vertical: size.width > webScreenSize ? 15 : 0,
                    ),
                    crossAxisCount: 2,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  uid: (snapshot.data! as dynamic).docs[index]
                                      ['uid']),
                            ),
                          );
                        },
                        child: Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8.0,
                  );
                },
              ),
      ),
    );
  }
}


// import 'package:chatup/screens/profile_screen.dart';
// import 'package:chatup/utils/color.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController searchController = TextEditingController();
//   bool isShowUsers = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: Form(
//           child: TextFormField(
//             controller: searchController,
//             decoration:
//                 const InputDecoration(labelText: 'Search for a user...'),
//             onFieldSubmitted: (String _) {
//               setState(() {
//                 isShowUsers = true;
//               });
//             },
//           ),
//         ),
//       ),
//       body: isShowUsers
//           ? FutureBuilder(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .where(
//                     'username',
//                     isGreaterThanOrEqualTo: searchController.text,
//                   )
//                   .get(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return ListView.builder(
//                   itemCount: (snapshot.data! as dynamic).docs.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => ProfileScreen(
//                             uid: (snapshot.data! as dynamic).docs[index]['uid'],
//                           ),
//                         ),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(
//                             (snapshot.data! as dynamic).docs[index]['photoUrl'],
//                           ),
//                           radius: 16,
//                         ),
//                         title: Text(
//                           (snapshot.data! as dynamic).docs[index]['username'],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             )
//           : FutureBuilder(
//               future: FirebaseFirestore.instance
//                   .collection('posts')
//                   .orderBy('datePublished')
//                   .get(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 return MasonryGridView.count(
//                   crossAxisCount: 3,
//                   itemCount: (snapshot.data! as dynamic).docs.length,
//                   itemBuilder: (context, index) => Image.network(
//                     (snapshot.data! as dynamic).docs[index]['postUrl'],
//                     fit: BoxFit.cover,
//                   ),
//                   mainAxisSpacing: 8.0,
//                   crossAxisSpacing: 8.0,
//                 );
//               },
//             ),
//     );
//   }
// }
