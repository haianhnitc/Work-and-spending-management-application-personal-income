import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/theme_service.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        actions: [
          IconButton(
            icon: Icon(Get.find<ThemeService>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => Get.find<ThemeService>().toggleTheme(),
          ),
          DropdownButton<String>(
            value: Get.locale?.languageCode,
            items: ['en', 'vi'].map((code) {
              return DropdownMenuItem(
                value: code,
                child: Text(code == 'en' ? '🇺🇸 English' : '🇻🇳 Tiếng Việt'),
              );
            }).toList(),
            onChanged: (value) => Get.updateLocale(Locale(value!)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => AuthForm(
              isLogin: true,
              isLoading: controller.isLoading.value,
              errorMessage: controller.errorMessage.value,
              onSubmit: (email, password) => controller.signIn(email, password),
              onSwitch: () => Get.toNamed('/register'),
            )),
      ),
    );
  }
}
