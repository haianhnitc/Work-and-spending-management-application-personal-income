import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';

class TodayOverviewWidget extends StatelessWidget {
  final bool isTablet;

  const TodayOverviewWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final overview = homeController.getTodayOverview();
      final todayExpenses = overview['todayExpenses'] as double;
      final todayIncome = overview['todayIncome'] as double;
      final todayTasks = overview['todayTasks'] as int;
      final completedTodayTasks = overview['completedTodayTasks'] as int;
      final balance = todayIncome - todayExpenses;

      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Color(0xFF1E293B),
                      Color(0xFF334155),
                    ]
                  : [
                      Color(0xFF4A90E2),
                      Color(0xFF7B68EE),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.today,
                      color: Colors.white, size: isTablet ? 28 : 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tổng quan hôm nay',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isTablet ? 20 : 18,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat('dd/MM').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 12 : 10,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
              if (balance.abs() > 0) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: balance >= 0
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: balance >= 0
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        balance >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: balance >= 0
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                        size: isTablet ? 18 : 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        balance >= 0 ? 'Thặng dư' : 'Thâm hụt',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 12 : 11,
                            ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${NumberFormat('#,###', 'vi').format(balance.abs())}₫',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: balance >= 0
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 12 : 11,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: _buildTodayItem(
                      context,
                      Icons.account_balance_wallet,
                      'Chi tiêu',
                      NumberFormat('#,###', 'vi').format(todayExpenses),
                      '₫',
                      isTablet,
                    ),
                  ),
                  Container(
                    height: isTablet ? 60 : 50,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildTodayItem(
                      context,
                      Icons.trending_up,
                      'Thu nhập',
                      NumberFormat('#,###', 'vi').format(todayIncome),
                      '₫',
                      isTablet,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTodayItem(
                      context,
                      Icons.task_alt,
                      'Nhiệm vụ',
                      '$completedTodayTasks/$todayTasks',
                      'hoàn thành',
                      isTablet,
                    ),
                  ),
                  Container(
                    height: isTablet ? 60 : 50,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildTodayItem(
                      context,
                      Icons.percent,
                      'Tỷ lệ',
                      todayTasks > 0
                          ? '${(completedTodayTasks / todayTasks * 100).toStringAsFixed(0)}'
                          : '0',
                      '%',
                      isTablet,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildTodayItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String unit,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: isTablet ? 24 : 20),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: isTablet ? 14 : 11,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isTablet ? 4 : 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: isTablet ? 18 : 14,
                  ),
            ),
          ),
          Text(
            unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: isTablet ? 12 : 9,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
