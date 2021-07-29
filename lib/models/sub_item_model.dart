import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class SubItemModels {
  final String name, image, subMenuName, caption;
  final int subKeyIndex;
  final double price;
  final List<SubItemModels> items;

  SubItemModels({
    Key key,
    @required this.name,
    @required this.price,
    @required this.subKeyIndex,
    @required this.items,
    @required this.image,
    @required this.caption,
    @required this.subMenuName,
  });

  factory SubItemModels.fromJson(
      {YamlMap data, String subName, int subKeyIndex}) {
    var tempImagePath = data['image'].toString();
    var imagePath = 'assets${tempImagePath.substring(1, tempImagePath.length)}';
    return SubItemModels(
      subMenuName: subName,
      name: data['name'],
      subKeyIndex: subKeyIndex,
      items: data['items'] != null
          ? List.generate(
              data['items'].length,
              (index) => SubItemModels.fromJson(
                  data: data['items'][index],
                  subName: subName,
                  subKeyIndex: subKeyIndex))
          : [],
      caption: data['caption'],
      price: data['price'] != null
          ? double.parse(data['price'].toString().replaceAll(',', '.'))
          : data['items'] != null
              ? null
              : 0.0,

      /// price has ',', so we need to replace that with '.'
      image: imagePath,
    );
  }
}
