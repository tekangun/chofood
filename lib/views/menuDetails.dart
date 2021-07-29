import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_item_models.dart';
import 'package:chofood/models/main_menu_models.dart';
import 'package:chofood/views/menuSubDetails.dart';
import 'package:chofood/views/my_basket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:yaml/yaml.dart';

class MenuDetails extends StatefulWidget {
  final MainMenuModels mainMenuModels;

  const MenuDetails({@required this.mainMenuModels});

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  MainMenuItemModels selectedMenu;

  Future<void> nextSubMenu({BuildContext context, YamlList subMenuList}) async {
    await navigatorService.navigate(MenuSubDetails(
              subMenuList: subMenuList,
              selectedSubMenuKeyIndex: 0,
              mainMenuItem: selectedMenu,
              selectedSubItemList: [],
            ));
  }

  void selectItem(
      {context, YamlList subMenuList, MainMenuItemModels mainItemModel}) {
    selectedMenu = mainItemModel;
    if (mainItemModel.subMenus != null) {
      nextSubMenu(context: context, subMenuList: mainItemModel.subMenus);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Widget customFloatingActionButton(){

    if(selectedMenu == null){
      return null;
    }
    else if(selectedMenu.subMenus != null){
      return null;
    }
    return FloatingActionButton.extended(
          onPressed: () => navigatorService.navigate(MyBasket(mainMenuModels: selectedMenu, subItemModelList: [])),
          backgroundColor: constantColors.selectedGreen,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                constantStrings.pay,
                style: TextStyle(color: constantColors.whiteColor),
              ),
              SizedBox(width: 2,),
              Icon(Icons.navigate_next,color: constantColors.whiteColor,size: 22,)
            ],
          ));
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: customFloatingActionButton(),
      appBar: AppBar(
        title: Text(
          widget.mainMenuModels.name,
          style: TextStyle(color: constantColors.whiteColor),
        ),
        actions: [
          if (selectedMenu != null)
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
              decoration: BoxDecoration(
                color: constantColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                  '${constantStrings.totalPriceText}: ${priceService.convertPrice(price: selectedMenu.price)}'),
            )
        ],
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.mainMenuModels.image))),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            AnimationLimiter(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                padding: EdgeInsets.zero,
                childAspectRatio: 1 / 1.1,
                children: List.generate(
                  widget.mainMenuModels.items.length,
                  (itemIndex) => AnimationConfiguration.staggeredGrid(
                    position: itemIndex,
                    duration: Duration(milliseconds: 500),
                    columnCount: 2,
                    child: ScaleAnimation(
                      duration: Duration(milliseconds: 900),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              width: size.width * .46,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          topLeft: Radius.circular(18)),
                                      child: Image.asset(
                                        widget.mainMenuModels.items[itemIndex]
                                            .image,
                                        fit: BoxFit.cover,
                                      )),
                                  Container(
                                    width: size.width * .46,
                                    height: size.height * .06,
                                    color: constantColors.greyBoxColor,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          widget.mainMenuModels.items[itemIndex]
                                              .name,
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
                                        Text(
                                          priceService.convertPrice(
                                              price: widget.mainMenuModels
                                                  .items[itemIndex].price),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => selectItem(
                                      context: context,
                                      mainItemModel: widget
                                          .mainMenuModels.items[itemIndex],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(18),
                                            bottomRight: Radius.circular(18)),
                                        color: selectedMenu ==
                                                widget.mainMenuModels
                                                    .items[itemIndex]
                                            ? constantColors.selectedGreen
                                            : constantColors.mainColor,
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6),
                                      child: Center(
                                          child: Text(
                                        selectedMenu ==
                                                widget.mainMenuModels
                                                    .items[itemIndex]
                                            ? constantStrings.selected
                                            : constantStrings.select,
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 16),
                                      )),
                                      width: size.width * .46,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget
                                    .mainMenuModels.items[itemIndex].subMenus !=
                                null)

                              /// if subMenu has more subMenuItem, showing this icon
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      color: constantColors.whiteColor,
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
