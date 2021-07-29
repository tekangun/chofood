import 'package:chofood/models/main_menu_item_models.dart';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class MainMenuModels {
  final String name, caption, image;
  final List<MainMenuItemModels> items;

  MainMenuModels(
      {Key key,
      @required this.name,
      @required this.caption,
      @required this.image,
      @required this.items});

  factory MainMenuModels.fromJson(YamlMap data) {
    var tempImagePath = data['image'].toString();
    var imagePath = 'assets${tempImagePath.substring(1, tempImagePath.length)}';
    return MainMenuModels(
        name: data['name'],
        caption: data['caption'],
        image: imagePath,
        items: List.generate(data['items'].length,
            (index) => MainMenuItemModels.fromJson(data['items'][index])));
  }
}
