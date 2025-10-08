import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';

class FinancialSummaryWidget extends StatelessWidget {
  final bool isTablet;

  const FinancialSummaryWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final summary = homeController.getFinancialSummary();
      final thisMonthExpenses = summary['thisMonthExpenses'] as double;
      final thisMonthIncome = summary['thisMonthIncome'] as double;
      final currentBudget = summary['currentBudget'] as double;
      final remainingBudget = summary['remainingBudget'] as double;
      final budgetSpentAmount =
          summary['budgetSpentAmount'] as double? ?? thisMonthExpenses;

      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Color(0xFF0F172A),
                      Color(0xFF1E293B),
                    ]
                  : [
                      Color(0xFF2E7D32),
                      Color(0xFF66BB6A),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance,
                      color: Colors.white, size: isTablet ? 28 : 24),
                  SizedBox(width: 12),
                  Text(
                    'Tóm tắt tài chính',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialStat(
                      context,
                      Icons.trending_down,
                      'Chi tiêu',
                      thisMonthExpenses,
                      Colors.red.shade300,
                      isTablet,
                    ),
                  ),
                  Expanded(
                    child: _buildFinancialStat(
                      context,
                      Icons.trending_up,
                      'Thu nhập',
                      thisMonthIncome,
                      Colors.green.shade300,
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
                    child: _buildFinancialStat(
                      context,
                      Icons.savings,
                      'Ngân sách',
                      currentBudget,
                      Colors.blue.shade300,
                      isTablet,
                    ),
                  ),
                  Expanded(
                    child: _buildFinancialStat(
                      context,
                      Icons.account_balance_wallet,
                      'Còn lại',
                      remainingBudget,
                      remainingBudget >= 0
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      isTablet,
                    ),
                  ),
                ],
              ),
              if (currentBudget > 0) ...[
                SizedBox(height: isTablet ? 16 : 12),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor:
                        (budgetSpentAmount / currentBudget).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: budgetSpentAmount > currentBudget
                            ? Colors.red.shade300
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${((budgetSpentAmount / currentBudget) * 100).toStringAsFixed(1)}% ngân sách đã sử dụng',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildFinancialStat(
    BuildContext context,
    IconData icon,
    String label,
    double amount,
    Color color,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: isTablet ? 24 : 18),
            SizedBox(width: isTablet ? 8 : 4),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 16 : 12,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 8 : 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${NumberFormat('#,###', 'vi').format(amount)}₫',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 14,
                ),
          ),
        ),
      ],
    );
  }
}
