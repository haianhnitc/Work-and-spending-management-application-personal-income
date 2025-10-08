import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme_config.dart';

class ThemeService extends GetxService {
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  RxBool get isDarkModeRx => _isDarkMode;

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeTheme(
        _isDarkMode.value ? ThemeConfig.darkTheme : ThemeConfig.lightTheme);
    return this;
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeTheme(
        _isDarkMode.value ? ThemeConfig.darkTheme : ThemeConfig.lightTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode.value);
  }
}
