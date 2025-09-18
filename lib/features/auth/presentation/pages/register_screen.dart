import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_expense_manager/core/services/theme_service.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 32 : 24),
                  child: Column(
                    children: [
                      _buildWelcomeSection(context, isTablet),
                      SizedBox(height: isTablet ? 48 : 32),
                      _buildAuthFormCard(context, isTablet),
                      SizedBox(height: isTablet ? 48 : 32),
                      _buildSwitchModeLink(context, isTablet),
                      SizedBox(height: isTablet ? 32 : 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, bool isTablet) {
    return Column(
      children: [
        Container(
          width: isTablet ? 120 : 100,
          height: isTablet ? 120 : 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: isTablet ? 60 : 50,
            color: Colors.white,
          ),
        ).animate().scale(
              duration: 400.ms,
              curve: Curves.easeOutBack,
            ),

        SizedBox(height: isTablet ? 32 : 24),

        Text(
          'Tạo tài khoản mới! 🚀',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: isTablet ? 36 : 28,
                letterSpacing: -0.5,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(
              duration: 300.ms,
              delay: 100.ms,
            ),

        SizedBox(height: isTablet ? 16 : 12),

        Text(
          'Đăng ký để bắt đầu quản lý công việc và chi tiêu',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 18 : 16,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(
              duration: 300.ms,
              delay: 200.ms,
            ),
      ],
    );
  }

  Widget _buildAuthFormCard(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isTablet ? 500 : double.infinity,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 48 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Đăng ký',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isTablet ? 28 : 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Get.find<ThemeService>().isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: isTablet ? 26 : 22,
                    ),
                    onPressed: () => Get.find<ThemeService>().toggleTheme(),
                  ),
                ).animate().scale(
                      duration: 200.ms,
                      delay: 100.ms,
                    ),
              ],
            ),

            SizedBox(height: isTablet ? 32 : 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.language_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: Get.locale?.languageCode ?? 'vi',
                      underline: const SizedBox(),
                      isExpanded: true,
                      items: ['vi', 'en'].map((code) {
                        return DropdownMenuItem(
                          value: code,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                code == 'en' ? '🇺🇸' : '🇻🇳',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  code == 'en' ? 'English' : 'Tiếng Việt',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => Get.updateLocale(Locale(value!)),
                    ),
                  ),
                ],
              ),
            ).animate().slideX(
                  begin: 0.2,
                  end: 0,
                  duration: 300.ms,
                  delay: 150.ms,
                  curve: Curves.easeOutCubic,
                ),

            SizedBox(height: isTablet ? 32 : 24),

            Obx(() => AuthForm(
                  isLogin: false,
                  isLoading: controller.isLoading.value,
                  errorMessage: controller.errorMessage.value,
                  onSubmit: controller.signUp,
                  onSwitch: () => Get.toNamed('/login'),
                )),
          ],
        ),
      ),
    )
        .animate()
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 300.ms,
          delay: 200.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(
          duration: 300.ms,
          delay: 200.ms,
        );
  }

  Widget _buildSwitchModeLink(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Đã có tài khoản? ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isTablet ? 16 : 14,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/login'),
          child: Text(
            'Đăng nhập ngay',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: isTablet ? 16 : 14,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ],
    ).animate().fadeIn(
          duration: 300.ms,
          delay: 300.ms,
        );
  }
}
