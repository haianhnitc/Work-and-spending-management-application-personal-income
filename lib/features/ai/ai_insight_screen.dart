import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/features/ai/ai_controller.dart';
import '../../../core/services/theme_service.dart';

class AIInsightsScreen extends StatelessWidget {
  final AIController controller = Get.put(AIController());
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      final isDark = themeService.isDarkMode;

      return Scaffold(
        backgroundColor: _getBackgroundColor(isDark),
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildModernHeader(context, isTablet, isDark),
              _buildContent(context, isTablet, isDark),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(context, isDark),
      );
    });
  }

  Widget _buildModernHeader(BuildContext context, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _buildAIGradient(isDark),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 32 : 24,
          isTablet ? 54 : 50,
          isTablet ? 32 : 24,
          isTablet ? 32 : 28,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.15 : 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.psychology_outlined,
                color: Colors.white,
                size: isTablet ? 36 : 32,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Thông minh • Cá nhân hóa • Hiệu quả',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isTablet, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      child: Column(
        children: [
          _buildQuickInsights(context, isTablet, isDark),
          SizedBox(height: 32),
          _buildAnalysisSection(context, isTablet, isDark),
          SizedBox(height: 32),
          _buildTrendingSection(context, isTablet, isDark),
          SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildQuickInsights(BuildContext context, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : 28),
      decoration: BoxDecoration(
        color: _getCardColor(isDark),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _getBorderColor(isDark),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardShadowColor(isDark),
            blurRadius: 25,
            offset: Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: _buildAIGradient(isDark),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getAIShadowColor(isDark),
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Obx(() => AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 28,
                            )
                              .animate(
                                  onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 2000.ms, delay: 1000.ms),
                    )),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý thông minh',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 22,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(isDark),
                        letterSpacing: -0.6,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Được cá nhân hóa cho bạn',
                      style: TextStyle(
                        fontSize: isTablet ? 15 : 14,
                        color: _getSubtitleColor(isDark),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Obx(() => AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: Container(
                  key: ValueKey(controller.smartSuggestions.value),
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: isTablet ? 200 : 150,
                  ),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: _buildContentGradient(isDark),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getContentBorderColor(isDark),
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      controller.smartSuggestions.value.isEmpty
                          ? controller.getContextualSuggestion()
                          : controller.smartSuggestions.value,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 15,
                        height: 1.6,
                        color: _getContentTextColor(isDark),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildAnalysisSection(
      BuildContext context, bool isTablet, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Phân tích chi tiết',
            style: TextStyle(
              fontSize: isTablet ? 24 : 22,
              fontWeight: FontWeight.bold,
              color: _getTextColor(isDark),
              letterSpacing: -0.6,
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildModernAnalysisCard(
          context,
          '📊',
          'Phân tích chi tiêu',
          'Hiểu rõ thói quen tài chính',
          controller.expenseAnalysis.value,
          controller.isExpenseLoading.value,
          isDark ? Color(0xFFFF6B8A) : Color(0xFFFF6B6B),
          () {
            HapticFeedback.lightImpact();
            controller.analyzeExpenses();
          },
          isTablet,
          isDark,
        ),
        SizedBox(height: 20),
        _buildModernAnalysisCard(
          context,
          '✅',
          'Phân tích công việc',
          'Tối ưu năng suất làm việc',
          controller.taskAnalysis.value,
          controller.isTaskLoading.value,
          isDark ? Color(0xFF4EDCD4) : Color(0xFF4ECDC4),
          () {
            HapticFeedback.lightImpact();
            controller.analyzeTasks();
          },
          isTablet,
          isDark,
        ),
      ],
    );
  }

  Widget _buildModernAnalysisCard(
    BuildContext context,
    String emoji,
    String title,
    String subtitle,
    String content,
    bool isLoading,
    Color primaryColor,
    VoidCallback onTap,
    bool isTablet,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _getCardColor(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _getBorderColor(isDark),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardShadowColor(isDark),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 28 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: isLoading
                              ? SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor),
                                  ),
                                )
                              : Text(
                                  emoji,
                                  style: TextStyle(fontSize: 28),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: _getTextColor(isDark),
                              letterSpacing: -0.4,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 13,
                              color: _getSubtitleColor(isDark),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLoading)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getIconBackgroundColor(isDark),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.touch_app,
                          size: 18,
                          color: _getIconColor(isDark),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  constraints: BoxConstraints(
                    minHeight: isLoading ? 120 : (content.isEmpty ? 100 : 80),
                    maxHeight: isTablet ? 180 : 140,
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getContentAreaColor(isDark),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getContentBorderColor(isDark),
                      width: 1,
                    ),
                  ),
                  child: isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'AI đang phân tích dữ liệu...',
                              style: TextStyle(
                                fontSize: isTablet ? 15 : 14,
                                fontWeight: FontWeight.w600,
                                color: _getSubtitleColor(isDark),
                              ),
                            ),
                            SizedBox(height: 12),
                            LinearProgressIndicator(
                              backgroundColor:
                                  _getProgressBackgroundColor(isDark),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                              minHeight: 3,
                            ),
                          ],
                        )
                      : content.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 32,
                                  color: _getIconColor(isDark),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Nhấn để bắt đầu phân tích',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getSubtitleColor(isDark),
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Text(
                                content,
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 13,
                                  height: 1.6,
                                  color: _getContentTextColor(isDark),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildTrendingSection(
      BuildContext context, bool isTablet, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Xu hướng & Dự đoán',
            style: TextStyle(
              fontSize: isTablet ? 24 : 22,
              fontWeight: FontWeight.bold,
              color: _getTextColor(isDark),
              letterSpacing: -0.6,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _buildTrendingGradient(isDark),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _getAIShadowColor(isDark),
                blurRadius: 25,
                offset: Offset(0, 12),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.15 : 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Obx(() => AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: controller.isPredictiveLoading.value
                                ? SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                          )),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phân tích xu hướng',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Dự đoán thông minh cho tương lai',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 13,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: isTablet ? 140 : 120,
                    maxHeight: isTablet ? 200 : 160,
                  ),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.08 : 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.15 : 0.25),
                      width: 1,
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isPredictiveLoading.value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AI đang phân tích xu hướng...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 3,
                          ),
                        ],
                      );
                    }

                    final analysis = controller.predictiveData['analysis'];
                    if (analysis == null || analysis.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 36,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Phân tích xu hướng để có cái nhìn sâu sắc hơn về dữ liệu của bạn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 15 : 14,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Text(
                        analysis,
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          color: Colors.white,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildFAB(BuildContext context, bool isDark) {
    return Obx(() => AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: controller.isLoading.value ||
                  controller.isExpenseLoading.value ||
                  controller.isTaskLoading.value ||
                  controller.isPredictiveLoading.value
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        controller.getPredictiveAnalysis();
                      },
                      backgroundColor:
                          isDark ? Color(0xFF533483) : Color(0xFF667eea),
                      elevation: 12,
                      child: Icon(Icons.trending_up, color: Colors.white),
                    ).animate().scale(duration: 400.ms, delay: 600.ms),
                    SizedBox(height: 16),
                    FloatingActionButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        controller.generateSmartSuggestions();
                      },
                      backgroundColor:
                          isDark ? Color(0xFF0f3460) : Color(0xFF764ba2),
                      elevation: 8,
                      child: Icon(Icons.refresh, color: Colors.white),
                    ).animate().scale(duration: 400.ms, delay: 700.ms),
                  ],
                ),
        ));
  }

  Color _getBackgroundColor(bool isDark) {
    return isDark ? Color(0xFF0a0a0a) : Color(0xFFF8F9FA);
  }

  Color _getCardColor(bool isDark) {
    return isDark ? Color(0xFF1a1a1a) : Colors.white;
  }

  Color _getBorderColor(bool isDark) {
    return isDark ? Color(0xFF333333) : Color(0xFFE5E7EB);
  }

  Color _getTextColor(bool isDark) {
    return isDark ? Colors.white : Color(0xFF1F2937);
  }

  Color _getSubtitleColor(bool isDark) {
    return isDark ? Color(0xFFB0B0B0) : Color(0xFF6B7280);
  }

  Color _getContentTextColor(bool isDark) {
    return isDark ? Color(0xFFE0E0E0) : Color(0xFF374151);
  }

  Color _getIconColor(bool isDark) {
    return isDark ? Color(0xFF9CA3AF) : Color(0xFF6B7280);
  }

  Color _getIconBackgroundColor(bool isDark) {
    return isDark ? Color(0xFF2A2A2A) : Color(0xFFF3F4F6);
  }

  Color _getContentAreaColor(bool isDark) {
    return isDark ? Color(0xFF0F0F0F) : Color(0xFFF9FAFB);
  }

  Color _getContentBorderColor(bool isDark) {
    return isDark ? Color(0xFF2A2A2A) : Color(0xFFE5E7EB);
  }

  Color _getProgressBackgroundColor(bool isDark) {
    return isDark ? Color(0xFF333333) : Color(0xFFE5E7EB);
  }

  Color _getCardShadowColor(bool isDark) {
    return isDark
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.06);
  }

  Color _getAIShadowColor(bool isDark) {
    if (isDark) {
      return Color(0xFF0f3460).withOpacity(0.5);
    } else {
      return Color(0xFF667eea).withOpacity(0.3);
    }
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

  LinearGradient _buildContentGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1a1a2e).withOpacity(0.3),
          Color(0xFF0f3460).withOpacity(0.2),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea).withOpacity(0.1),
          Color(0xFF764ba2).withOpacity(0.1),
        ],
      );
    }
  }

  LinearGradient _buildTrendingGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
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
          Color(0xFFa8edea),
        ],
      );
    }
  }
}
