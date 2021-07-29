import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<dynamic> navigate(Widget route) {
    return _navigatorKey.currentState
        .push(MaterialPageRoute(builder: (_) => route));
  }

  Future<dynamic> navigateAndRemoveUntil(Widget route) {
    return _navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => route), (route) => false);
  }

  void navigatePop(var data) {
    return _navigatorKey.currentState.pop(data);
  }

  Future<dynamic> navigatePopAndPush(Widget route) {
    _navigatorKey.currentState.pop();
    return _navigatorKey.currentState
        .push(MaterialPageRoute(builder: (_) => route));
  }
}
