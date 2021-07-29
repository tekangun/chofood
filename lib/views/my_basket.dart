import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_item_models.dart';
import 'package:chofood/models/sub_item_model.dart';
import 'package:chofood/views/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyBasket extends StatefulWidget {
  final MainMenuItemModels mainMenuModels;
  final List<SubItemModels> subItemModelList;

  MyBasket({@required this.mainMenuModels, @required this.subItemModelList});

  @override
  _MyBasketState createState() => _MyBasketState();
}

class _MyBasketState extends State<MyBasket> {
  Widget titleText(String title) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 6),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              height: 2,
              color: constantColors.greyBoxColor,
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          constantStrings.orderConfirm,
          style: TextStyle(color: constantColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Hero(
              tag: widget.mainMenuModels.caption,
              child: Container(
                width: size.width,
                height: size.height * .24,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.mainMenuModels.image))),
              ),
            ),
            titleText(constantStrings.homeMenu),
            AnimationLimiter(
              child: ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, mainIndex) {
                  return AnimationConfiguration.staggeredList(
                    position: mainIndex,
                    delay: Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      verticalOffset: -250,
                      child: ScaleAnimation(
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: constantColors.greyBoxColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(right: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.asset(widget.mainMenuModels.image),
                              ),
                              trailing: Text(priceService.convertPrice(
                                  price: widget.mainMenuModels.price)),
                              title: Text(widget.mainMenuModels.name),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            titleText(constantStrings.subMenu),
            AnimationLimiter(
              child: widget.subItemModelList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.subItemModelList.length,
                      itemBuilder: (_, subItemIndex) {
                        return AnimationConfiguration.staggeredList(
                          position: subItemIndex,
                          delay: Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 2500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            verticalOffset: -250,
                            child: ScaleAnimation(
                              duration: Duration(milliseconds: 1500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: constantColors.greyBoxColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(right: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    trailing: Text(priceService.convertPrice(
                                        price: widget
                                            .subItemModelList[subItemIndex]
                                            .price)),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      child: Image.asset(widget
                                          .subItemModelList[subItemIndex]
                                          .image),
                                    ),
                                    title: Text(
                                      widget.subItemModelList[subItemIndex]
                                              .name ??
                                          widget.subItemModelList[subItemIndex]
                                              .caption,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(constantStrings.notHaveSubMenu),
                    ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: constantColors.mainColor,
              ),
              child: Text(
                '${constantStrings.totalPriceText}: ${priceService.calculateBasketPrice(mainMenuItem: widget.mainMenuModels, subItemModelList: widget.subItemModelList)}',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .9),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => {
                Fluttertoast.showToast(msg: constantStrings.orderConfirmed),
                navigatorService.navigateAndRemoveUntil(Home()),
              },
              child: Container(
                alignment: Alignment.center,
                width: size.width * .6,
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: constantColors.selectedGreen,
                ),
                child: Text(
                  constantStrings.orderNow,
                  style:
                      TextStyle(color: constantColors.whiteColor, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
