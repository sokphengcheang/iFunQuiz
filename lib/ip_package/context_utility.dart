import 'package:flutter/material.dart';

class ContextUtility{
  static final GlobalKey<NavigatorState> _navigatorkey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorkey => _navigatorkey;

  static NavigatorState? get navigetor => navigatorkey.currentState;
  static BuildContext? get context => navigetor?.overlay?.context;
}