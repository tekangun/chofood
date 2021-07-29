import 'dart:ui';

import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_models.dart';
import 'package:chofood/views/menuDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Home extends StatelessWidget {

  Future<void> nextMenuDetails(
      BuildContext context, MainMenuModels mainMenuModels) async {
    await navigatorService.navigate(MenuDetails(mainMenuModels: mainMenuModels));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            constantStrings.homeTitle,
            style: TextStyle(color: constantColors.whiteColor),
          ),
        ),
        body: FutureBuilder(
          future: menuServices.getMainMenuList(),
          builder: (_, AsyncSnapshot<List<MainMenuModels>> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(constantColors.mainColor),
              );
            }
            return AnimationLimiter(
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data.length,
                itemBuilder: (_, menuIndex) {
                  return AnimationConfiguration.staggeredList(
                    position: menuIndex,
                    delay: Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      verticalOffset: -250,
                      child: ScaleAnimation(
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: InkWell(
                          onTap: () =>
                              nextMenuDetails(_, snapshot.data[menuIndex]),
                          child: Hero(
                            tag: snapshot.data[menuIndex].caption,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: constantColors.greenColor,
                                  borderRadius: BorderRadius.circular(12)),
                              width: size.width,
                              height: size.height * .12,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      snapshot.data[menuIndex].image,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      width: size.width * .6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: constantColors.softWhiteColor,
                                      ),
                                      child: Text(
                                        snapshot.data[menuIndex].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: constantColors.blackColor,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}
