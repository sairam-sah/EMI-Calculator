import 'package:easyemi/app/modules/calculator/binding/calculator_binding.dart';
import 'package:easyemi/app/modules/calculator/views/calculator_views.dart';
import 'package:get/get.dart';

import '../modules/emicalculator/bindings/emicalculator_binding.dart';
import '../modules/emicalculator/views/emicalculator_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EMICALCULATOR,
      page: () => const EmicalculatorView(),
      binding: EmicalculatorBinding(),
    ),
     GetPage(
      name: _Paths.CALCULATOR,
      page: () => const Calculator(),
      binding: CalculatorBinding(),
    ),
  ];
}
