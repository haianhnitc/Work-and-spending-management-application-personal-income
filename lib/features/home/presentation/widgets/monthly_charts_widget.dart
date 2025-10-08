import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../controllers/home_controller.dart';

class MonthlyChartsWidget extends StatelessWidget {
  final bool isTablet;

  const MonthlyChartsWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final categoryAmounts = homeController.getMonthlyExpensesByCategory();

      if (categoryAmounts.isEmpty) {
        return _buildEmptyChart(context);
      }

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.pie_chart,
                              color: Theme.of(context).primaryColor,
                              size: isTablet ? 24 : 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chi tiêu theo danh mục',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: isTablet ? 18 : 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Tháng ${DateFormat('MM/yyyy').format(DateTime.now())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 12 : 9,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6,
                      vertical: isTablet ? 4 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${categoryAmounts.length} danh mục',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 11 : 8,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              SizedBox(
                height: isTablet ? 250 : 180,
                child: PieChart(
                  PieChartData(
                    sections: _createPieChartSections(categoryAmounts),
                    centerSpaceRadius: isTablet ? 60 : 35,
                    sectionsSpace: 4,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildChartLegend(categoryAmounts, isTablet),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  List<PieChartSectionData> _createPieChartSections(
    Map<String, double> categoryAmounts,
  ) {
    final total =
        categoryAmounts.values.fold<double>(0, (sum, amount) => sum + amount);
    int colorIndex = 0;

    return categoryAmounts.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = getCategoryColor(colorIndex++);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: isTablet ? 80 : 60,
        titleStyle: TextStyle(
          fontSize: isTablet ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildChartLegend(Map<String, double> categoryAmounts, bool isTablet) {
    int colorIndex = 0;
    return Wrap(
      spacing: isTablet ? 16 : 8,
      runSpacing: isTablet ? 12 : 6,
      children: categoryAmounts.entries.map((entry) {
        final color = getCategoryColor(colorIndex++);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 16 : 12,
              height: isTablet ? 16 : 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            SizedBox(width: isTablet ? 8 : 4),
            Flexible(
              child: Text(
                categoryToString(entry.key),
                style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 14 : 11,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart,
                    color: Theme.of(context).primaryColor,
                    size: isTablet ? 28 : 24),
                SizedBox(width: 12),
                Text(
                  'Chi tiêu theo danh mục',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 32 : 24),
            Icon(
              Icons.pie_chart_outline,
              size: isTablet ? 64 : 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Chưa có dữ liệu chi tiêu',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              'Thêm chi tiêu để xem biểu đồ phân tích',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
        );
  }
}
