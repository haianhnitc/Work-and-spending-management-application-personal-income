import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/format_utils.dart';
import '../controllers/budget_controller.dart';

class BudgetOverviewCard extends StatelessWidget {
  final BudgetController budgetController;

  const BudgetOverviewCard({
    super.key,
    required this.budgetController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        children: [
          _buildMainCard(context),
          SizedBox(height: 16),
          _buildStatsGrid(context),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color(0xFF2D3748),
                  Color(0xFF1A202C),
                ]
              : [
                  Color(0xFF667EEA),
                  Color(0xFF764BA2),
                ],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Theme.of(context).primaryColor.withValues(alpha: 0.3),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 24),
          _buildAmountDisplay(context),
          SizedBox(height: 20),
          _buildProgressSection(context),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng quan ngân sách',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Quản lý tài chính thông minh',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _triggerHapticFeedback(),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng ngân sách',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                FormatUtils.formatCompactCurrency(
                    budgetController.totalBudgetAmount),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                budgetController.overallUsagePercentage >= 90
                    ? Icons.trending_up
                    : Icons.trending_flat,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '${budgetController.overallUsagePercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final percentage = budgetController.overallUsagePercentage;
    final remaining = budgetController.totalRemainingAmount;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Còn lại: ${FormatUtils.formatCompactCurrency(remaining)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Đã sử dụng ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildAnimatedProgress(context, percentage),
      ],
    );
  }

  Widget _buildAnimatedProgress(BuildContext context, double percentage) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: _getProgressColors(percentage),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ).animate().scaleX(
                begin: 0,
                end: (percentage / 100).clamp(0.0, 1.0),
                duration: 1500.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Đã Chi',
            budgetController.totalSpentAmount,
            Icons.arrow_upward,
            Colors.orange,
            0,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Còn Lại',
            budgetController.totalRemainingAmount,
            Icons.arrow_downward,
            Colors.green,
            100,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Tiết Kiệm',
            budgetController.totalRemainingAmount * 0.1,
            Icons.savings,
            Colors.blue,
            200,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    Color color,
    int delay,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D3748).withValues(alpha: 0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            FormatUtils.formatCompactCurrency(amount),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate(delay: delay.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack);
  }

  List<Color> _getProgressColors(double percentage) {
    if (percentage >= 90) {
      return [Color(0xFFE53E3E), Color(0xFFFC8181)];
    } else if (percentage >= 80) {
      return [Color(0xFFED8936), Color(0xFFFBB042)];
    } else if (percentage >= 60) {
      return [Color(0xFFECC94B), Color(0xFFF6E05E)];
    }
    return [Color(0xFF38A169), Color(0xFF68D391)];
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }
}
