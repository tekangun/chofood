import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class MainMenuItemModels {
  final String name, caption, image;
  final double price;
  final YamlList subMenus;

  MainMenuItemModels(
      {Key key,
      @required this.name,
      @required this.caption,
      @required this.image,
      @required this.subMenus,
      @required this.price});

  factory MainMenuItemModels.fromJson(YamlMap data) {
    var tempImagePath = data['image'].toString();
    var imagePath = 'assets${tempImagePath.substring(1, tempImagePath.length)}';
    return MainMenuItemModels(
        name: data['name'],
        caption: data['caption'],
        image: imagePath,
        subMenus: data['subMenus'],
        price: data['price'] != null
            ? double.parse(data['price'].toString().replaceAll(',', '.'))
            : 0.0);

    /// price has ',', so we need to replace that with '.'
  }
}
