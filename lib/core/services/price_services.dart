import 'package:chofood/constants/constant_init.dart';
import 'package:chofood/models/main_menu_item_models.dart';
import 'package:chofood/models/sub_item_model.dart';

class PriceServices {
  String convertPrice({double price}) {
    /// we have different condition for price text,
    /// this function help us for that
    /// if price null then this is for selectableItem e.q:Coca-Cola => Zero,Light...
    /// Main itemName 'Coca-Cola' not has price data, but 'Zero' or 'Light' has,
    /// so if price come from 'Coca-Cola' we showing info text,
    /// but if real price come, we show price with ₺
    var text = '';
    if (price == 0.0) {
      text = constantStrings.freeText;
    } else if (price == null) {
      text = constantStrings.haveChoiceDrink;
    } else {
      text = '${price.toStringAsFixed(2)} ₺';
    }
    return text;
  }

  String calculateBasketPrice(
      {MainMenuItemModels mainMenuItem, List<SubItemModels> subItemModelList}) {
    /// calculate main menu item and sub items total price
    double total = mainMenuItem.price;
    if (subItemModelList.isNotEmpty) {
      subItemModelList.forEach((element) {
        total += (element.price ?? 0);
      });
    }
    return convertPrice(price: total);
  }
}
