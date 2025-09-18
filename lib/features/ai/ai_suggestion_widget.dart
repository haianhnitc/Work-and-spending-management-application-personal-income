import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'ai_controller.dart';
import '../../../core/services/theme_service.dart';

class AISuggestionWidget extends StatelessWidget {
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      final isDark = themeService.isDarkMode;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 20,
          vertical: isTablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: _buildAIGradient(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _getAIShadowColor(isDark),
              blurRadius: 25,
              offset: Offset(0, 12),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 28 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isTablet, isDark),
                SizedBox(height: 20),
                _buildContent(context, isTablet, isDark),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0);
    });
  }

  Widget _buildHeader(BuildContext context, bool isTablet, bool isDark) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDark ? 0.15 : 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
              width: 1.5,
            ),
          ),
          child: GetX<AIController>(
            init: AIController(),
            builder: (controller) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: isTablet ? 28 : 24,
                        height: isTablet ? 28 : 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: isTablet ? 28 : 24,
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2000.ms, delay: 1000.ms),
              );
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Assistant',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Gợi ý thông minh cho bạn',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDark ? 0.15 : 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isTablet, bool isDark) {
    return GetX<AIController>(
      builder: (controller) {
        if (!controller.isInitialized.value) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.08 : 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.15 : 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI đang được khởi tạo...',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          child: Container(
            key: ValueKey(controller.smartSuggestions.value),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                width: 1,
              ),
            ),
            child: Text(
              controller.smartSuggestions.value.isEmpty
                  ? controller.getContextualSuggestion()
                  : controller.smartSuggestions.value,
              style: TextStyle(
                fontSize: isTablet ? 16 : 15,
                color: Colors.white,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  LinearGradient _buildAIGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1a1a2e),
          Color(0xFF16213e),
          Color(0xFF0f3460),
          Color(0xFF533483),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
          Color(0xFFf093fb),
          Color(0xFF4facfe),
        ],
      );
    }
  }

  Color _getAIShadowColor(bool isDark) {
    if (isDark) {
      return Color(0xFF0f3460).withOpacity(0.4);
    } else {
      return Color(0xFF667eea).withOpacity(0.3);
    }
  }
}
