import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';

class SmartInsightsWidget extends StatelessWidget {
  final bool isTablet;

  const SmartInsightsWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final insights = homeController.getSmartInsights();

      if (insights.isEmpty) {
        return SizedBox.shrink();
      }

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Color(0xFF1F2937),
                      Color(0xFF374151),
                    ]
                  : [
                      Color(0xFFFFF8E1),
                      Color(0xFFFFECB3),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.amber.shade900.withOpacity(0.3)
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lightbulb,
                        color: isDark
                            ? Colors.amber.shade300
                            : Colors.orange.shade700,
                        size: isTablet ? 24 : 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gợi ý thông minh',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.amber.shade300
                                : Colors.orange.shade700,
                            fontSize: isTablet ? 18 : 16,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.amber.shade900.withOpacity(0.3)
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${insights.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? Colors.amber.shade300
                                : Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 12 : 10,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Column(
                children: insights.take(isTablet ? 3 : 2).map((insight) {
                  return _buildInsightCard(context, insight, isTablet);
                }).toList(),
              ),
              if (insights.length > (isTablet ? 3 : 2)) ...[
                SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showAllInsights(context, insights),
                    icon: Icon(Icons.expand_more, size: 16),
                    label: Text(
                      'Xem thêm ${insights.length - (isTablet ? 3 : 2)} gợi ý',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildInsightCard(
    BuildContext context,
    Map<String, dynamic> insight,
    bool isTablet,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[800]?.withOpacity(0.5)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (insight['color'] as Color).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: (insight['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              insight['icon'] as IconData,
              color: insight['color'] as Color,
              size: isTablet ? 22 : 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: insight['color'] as Color,
                        fontSize: isTablet ? 14 : 13,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  insight['message'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        fontSize: isTablet ? 13 : 11,
                        height: 1.3,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (insight['action'] != null)
            Container(
              child: TextButton(
                onPressed: insight['action'] as VoidCallback,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  insight['actionText'] as String,
                  style: TextStyle(
                    color: insight['color'] as Color,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 12 : 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAllInsights(
      BuildContext context, List<Map<String, dynamic>> insights) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tất cả gợi ý thông minh',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: insights.length,
                itemBuilder: (context, index) {
                  return _buildInsightCard(context, insights[index], false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
