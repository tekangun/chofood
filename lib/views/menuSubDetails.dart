import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_item_models.dart';
import 'package:chofood/models/sub_item_choice_model.dart';
import 'package:chofood/models/sub_item_model.dart';
import 'package:chofood/views/my_basket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yaml/yaml.dart';

class MenuSubDetails extends StatefulWidget {
  final YamlList subMenuList;
  MainMenuItemModels mainMenuItem;
  int selectedSubMenuKeyIndex;
  List<SubItemModels> selectedSubItemList = [];

  MenuSubDetails(
      {@required this.subMenuList,
      @required this.selectedSubItemList,
      @required this.selectedSubMenuKeyIndex,
      @required this.mainMenuItem});

  @override
  _MenuSubDetailsState createState() => _MenuSubDetailsState();
}

class _MenuSubDetailsState extends State<MenuSubDetails> {
  int selectedSubMenuItemIndex = 0;
  int subMenuLength;

  List<ChoiceSelectItem> choiceSelectItemList = [];

  ChoiceSelectItem checkIsSelected({@required int subItemIndex}) {
    var selected;
    choiceSelectItemList.forEach((element) {
      /// for the special subItemInfo
      /// if subMenuKey compare with currentMenu, check if listed items have isSelected before condition
      /// if isSelected before, return selected subMenuItem
      if (element.subItemKeyIndex == widget.selectedSubMenuKeyIndex &&
          element.subItemIndex == subItemIndex) {
        selected = element;
      }
    });
    return selected;
  }

  void nextItem({SubItemModels subItemModels}) {
    if (widget.selectedSubMenuKeyIndex != (widget.subMenuList.length - 1)) {
      widget.selectedSubMenuKeyIndex += 1;
      widget.selectedSubItemList.add(subItemModels);
      navigatorService.navigatePopAndPush(MenuSubDetails(
        subMenuList: widget.subMenuList,
        selectedSubMenuKeyIndex: widget.selectedSubMenuKeyIndex,
        mainMenuItem: widget.mainMenuItem,
        selectedSubItemList: widget.selectedSubItemList,
      ));
    } else {
      widget.selectedSubItemList.add(subItemModels);
      navigatorService.navigatePopAndPush(MyBasket(
        mainMenuModels: widget.mainMenuItem,
        subItemModelList: widget.selectedSubItemList,
      ));

      /// last
    }
  }

  Future<void> showChoicesAlert(
      {@required List<SubItemModels> choiceList,
      @required int subItemIndex}) async {
    await showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (_) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              constantStrings.choices,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          Column(
            children: List.generate(
                choiceList.length,
                (subChoiceIndex) => ListTile(
                      onTap: () => navigatorService
                          .navigatePop(choiceList[subChoiceIndex]),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(choiceList[subChoiceIndex].image)),
                      title: Text(choiceList[subChoiceIndex].name),
                      trailing: Text(choiceList[subChoiceIndex].price != 0
                          ? '+${priceService.convertPrice(price: choiceList[subChoiceIndex].price)}'
                          : priceService.convertPrice(
                              price: choiceList[subChoiceIndex].price)),
                    )).toList(),
          ),
        ]),
      ),
    ).then((value) {
      if (value != null) {
        var removeList = [];
        var selected = ChoiceSelectItem.fromJson({
          'subItemIndex': subItemIndex,
          'subItem': value,
          'subItemKeyIndex': widget.selectedSubMenuKeyIndex
        });
        choiceSelectItemList.forEach((element) {
          if (element.subItemIndex == subItemIndex) {
            removeList.add(element);
          }
        });
        if (removeList.isNotEmpty) {
          choiceSelectItemList.removeWhere((e) => removeList.contains(e));
        }
        choiceSelectItemList.add(selected);
        nextItem(subItemModels: value);
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: menuServices.getSubMenuWithKey(
          subMenuKey: widget.subMenuList[widget.selectedSubMenuKeyIndex]),
      builder: (_, AsyncSnapshot<List<SubItemModels>> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  constantStrings.error,
                  style: TextStyle(color: constantColors.whiteColor),
                ),
              ),
              body: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                constantStrings.loading,
                style: TextStyle(color: constantColors.whiteColor),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(constantColors.mainColor),
              ),
            ),
          );
        }
        subMenuLength = snapshot.data.length;
        if (snapshot.data[widget.selectedSubMenuKeyIndex].items.isNotEmpty) {
          choiceSelectItemList.fillRange(
              0, snapshot.data[widget.selectedSubMenuKeyIndex].items.length);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              snapshot.data[widget.selectedSubMenuKeyIndex].subMenuName,
              style: TextStyle(color: constantColors.whiteColor),
            ),
            actions: [
              if (widget.mainMenuItem != null)
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                  decoration: BoxDecoration(
                    color: constantColors.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      '${constantStrings.totalPriceText}: ${priceService.calculateBasketPrice(mainMenuItem: widget.mainMenuItem, subItemModelList: widget.selectedSubItemList)}'),
                )
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: AnimationLimiter(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.zero,
                  childAspectRatio: 1 / 1.1,
                  children: List.generate(
                    subMenuLength,
                    (subMenuListIndex) => AnimationConfiguration.staggeredGrid(
                      position: subMenuListIndex,
                      duration: Duration(milliseconds: 500),
                      columnCount: 2,
                      child: ScaleAnimation(
                        duration: Duration(milliseconds: 900),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            width: size.width * .46,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(18),
                                        topLeft: Radius.circular(18)),
                                    child: Image.asset(
                                      checkIsSelected(
                                                  subItemIndex:
                                                      subMenuListIndex) !=
                                              null
                                          ? checkIsSelected(
                                                  subItemIndex:
                                                      subMenuListIndex)
                                              .subItemModels
                                              .image
                                          : snapshot
                                              .data[subMenuListIndex].image,
                                      fit: BoxFit.cover,
                                    )),
                                Container(
                                  width: size.width * .46,
                                  height: size.height * .07,
                                  alignment: Alignment.center,
                                  color: constantColors.greyBoxColor,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        checkIsSelected(
                                                    subItemIndex:
                                                        subMenuListIndex) !=
                                                null
                                            ? (checkIsSelected(
                                                        subItemIndex:
                                                            subMenuListIndex)
                                                    .subItemModels
                                                    .name ??
                                                checkIsSelected(
                                                        subItemIndex:
                                                            subMenuListIndex)
                                                    .subItemModels
                                                    .caption)
                                            : (snapshot.data[subMenuListIndex]
                                                    .name ??
                                                snapshot.data[subMenuListIndex]
                                                    .caption),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      checkIsSelected(
                                                  subItemIndex:
                                                      subMenuListIndex) !=
                                              null
                                          ? Text(
                                              checkIsSelected(
                                                              subItemIndex:
                                                                  subMenuListIndex)
                                                          .subItemModels
                                                          .price !=
                                                      0
                                                  ? '+${priceService.convertPrice(price: checkIsSelected(subItemIndex: subMenuListIndex).subItemModels.price)}'
                                                  : constantStrings.freeText,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              ((snapshot.data[subMenuListIndex]
                                                              .price !=
                                                          0) &&
                                                      (snapshot
                                                              .data[
                                                                  subMenuListIndex]
                                                              .price !=
                                                          null))
                                                  ? '+${priceService.convertPrice(price: snapshot.data[subMenuListIndex].price)}'
                                                  : priceService.convertPrice(
                                                      price: snapshot
                                                          .data[
                                                              subMenuListIndex]
                                                          .price),

                                              /// snapshot.data[subMenuListIndex].price is writed this place because if item has some sub choice sub menu items, it not have price data
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => snapshot.data[subMenuListIndex]
                                          .items.isNotEmpty
                                      ? showChoicesAlert(
                                          choiceList: snapshot
                                              .data[subMenuListIndex].items,
                                          subItemIndex: subMenuListIndex)
                                      : nextItem(
                                          subItemModels:
                                              snapshot.data[subMenuListIndex]),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: size.width * .8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(18),
                                          bottomLeft: Radius.circular(18)),
                                      color: constantColors.mainColor,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      snapshot.data[subMenuListIndex].items
                                              .isNotEmpty
                                          ? constantStrings.choices
                                          : constantStrings.select,
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
