import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_binding.dart';
import 'package:task_expense_manager/core/constants/theme_config.dart';
import 'core/l10n/l10n.dart';
import 'core/services/theme_service.dart';
import 'core/services/ai_service.dart';
import 'core/utils/env_config.dart';
import 'dependency_injection/main_config.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        logWriterCallback: (text, {isError = false}) {
          if (text.contains('SNACKBAR') ||
              text.contains('Route') ||
              text.contains('Auth')) {
            print('🔍 GetX Log: $text');
          }
        },
        popGesture: true,
        defaultTransition: Transition.cupertino,
        transitionDuration: Duration(milliseconds: 300),
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
        initialRoute: AppRoutes.splash);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.init();

  final missingEnvVars = EnvConfig.validate();
  if (missingEnvVars.isNotEmpty) {
    print('⚠️ Missing environment variables: ${missingEnvVars.join(', ')}');
    print('Please check your .env file');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppBinding().dependencies();
  // Get.put(FirebaseService());
  await Get.putAsync(() => ThemeService().init());

  // Initialize AI Service after EnvConfig is ready
  try {
    await AIService.initialize();
  } catch (e) {
    print('⚠️ AI Service initialization failed: $e');
    print('💡 App will continue without AI features');
  }

  configureDependencies();
  runApp(App());
}
