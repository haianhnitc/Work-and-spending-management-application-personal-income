import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_binding.dart';
import 'package:task_expense_manager/core/constants/theme_config.dart';
import 'core/l10n/l10n.dart';
import 'core/services/theme_service.dart';
import 'dependency_injection/main_config.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

// Platform  Firebase App Id
// web       1:875593479035:web:5faeae3be1e9d3f94203de
// android   1:875593479035:android:35820027bf21317b4203de
// ios       1:875593479035:ios:a6798259f8b0d5b74203de
// windows   1:875593479035:web:ca6ca7d174189a584203de

// @InjectableInit()
// void configureDependencies() => getIt.init();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'appName'.tr,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: Get.find<ThemeService>().isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: Get.locale ?? L10n.all[0],
        fallbackLocale: L10n.all[0],
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.all,
        getPages: AppRoutes.routes,
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? AppRoutes.main
            : AppRoutes.login);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppBinding().dependencies();
  // Get.put(FirebaseService());
  await Get.putAsync(() => ThemeService().init());
  configureDependencies();
  runApp(App());
}
