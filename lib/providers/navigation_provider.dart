import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  // List<NavigationState> _tracks = [
  //   // NavigationState(navigationIndex: 0, page: Home),
  // ];
  // NavigationState get currentState => _tracks.last;

  // setNavigationState(NavigationState newState) {
  //   _tracks.add(newState);
  //   notifyListeners();
  // }

  // bool back() {
  //   if (_tracks.length > 1) {
  //     _tracks.removeLast();
  //     notifyListeners();
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}

class NavigationState {
  final int? navigationIndex;
  final Widget? page;
  NavigationState({this.navigationIndex, this.page});
}
