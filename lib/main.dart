import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/core/locator.dart';
import 'package:chofood/views/home.dart';
import 'package:flutter/material.dart';

import 'core/services/navigator_service.dart';

void main() {
  setUpLocators();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<NavigatorService>().navigatorKey,
      theme: ThemeData(
          primarySwatch: constantColors.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: constantColors.whiteColor),
          )),
      home: Home(),
    );
  }
}
