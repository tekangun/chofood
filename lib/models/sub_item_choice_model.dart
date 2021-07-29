import 'package:chofood/models/sub_item_model.dart';
import 'package:flutter/material.dart';

class ChoiceSelectItem {
  int subItemIndex;
  int subItemKeyIndex;
  SubItemModels subItemModels;

  ChoiceSelectItem(
      {@required this.subItemModels,
      @required this.subItemIndex,
      @required this.subItemKeyIndex});

  factory ChoiceSelectItem.fromJson(Map<String, dynamic> data) {
    return ChoiceSelectItem(
        subItemModels: data['subItem'],
        subItemIndex: data['subItemIndex'],
        subItemKeyIndex: data['subItemKeyIndex']);
  }
}
