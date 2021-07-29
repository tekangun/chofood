import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_models.dart';
import 'package:chofood/models/sub_item_model.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/services.dart" as s;
import "package:yaml/yaml.dart";

class MenuServices {
  Future<YamlMap> loadYamlMenu() async {
    /// for loading data of food menu
    final data = await s.rootBundle.loadString(constantPaths.pathOfMenuList);
    return loadYaml(data);
  }

  Future<List<MainMenuModels>> getMainMenuList() async {
    /// for get home main menu list
    var mapData = await loadYamlMenu();
    var menuJson = mapData['menus'][0]['items'];
    return List.generate(
        menuJson.length, (index) => MainMenuModels.fromJson(menuJson[index]));
  }

  Future<List<SubItemModels>> getSubMenuWithKey(
      {@required String subMenuKey}) async {
    /// for get submenu with submenu key in main menu
    var mapData = await loadYamlMenu();
    var subMenuJson = mapData['menus'];
    int subMenuIndex;

    /// we have string key like food-key-sample,
    /// we need to find key index number inside menu.yaml
    /// subMenuIndex is that index
    for (var i = 0; i < subMenuJson.length; i++) {
      if (subMenuJson[i]['key'] == subMenuKey) {
        subMenuIndex = i;
      }
    }
    var subMenuJsonDetails = mapData['menus'][subMenuIndex]['items'];
    return List.generate(
        subMenuJsonDetails.length,
        (index) => SubItemModels.fromJson(
            data: subMenuJsonDetails[index],
            subName: mapData['menus'][subMenuIndex]['description'],
            subKeyIndex: subMenuIndex));
  }
}
