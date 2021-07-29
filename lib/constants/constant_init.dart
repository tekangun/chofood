import 'package:chofood/constants/constant_colors.dart';
import 'package:chofood/constants/constant_paths.dart';
import 'package:chofood/constants/constant_strings.dart';
import 'package:chofood/core/locator.dart';
import 'package:chofood/core/services/menu_services.dart';
import 'package:chofood/core/services/navigator_service.dart';
import 'package:chofood/core/services/price_services.dart';

/// Global Variables

var constantStrings = getIt<ConstantStrings>();
var constantColors = getIt<ConstantColors>();
var menuServices = getIt<MenuServices>();
var navigatorService = getIt<NavigatorService>();
var constantPaths = getIt<ConstantPaths>();
var priceService = getIt<PriceServices>();
