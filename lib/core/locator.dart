import 'package:chofood/constants/constant_colors.dart';
import 'package:chofood/constants/constant_paths.dart';
import 'package:chofood/constants/constant_strings.dart';
import 'package:chofood/core/services/menu_services.dart';
import 'package:chofood/core/services/navigator_service.dart';
import 'package:chofood/core/services/price_services.dart';
import 'package:get_it/get_it.dart';

/// Paths for getIt.
var getIt = GetIt.instance;

void setUpLocators() {
  getIt.registerLazySingleton(() => ConstantStrings());
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => ConstantColors());
  getIt.registerLazySingleton(() => MenuServices());
  getIt.registerLazySingleton(() => ConstantPaths());
  getIt.registerLazySingleton(() => PriceServices());
}
