import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';

class QuickActionsWidget extends StatelessWidget {
  final bool isTablet;

  const QuickActionsWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    final actions = [
      {
        'icon': Icons.add_task,
        'label': 'Tạo nhiệm vụ',
        'color': Colors.blue,
        'action': () => homeController.navigateToCreateTask(),
      },
      {
        'icon': Icons.remove_circle_outline,
        'label': 'Tạo chi tiêu',
        'color': Colors.red,
        'action': () => homeController.navigateToCreateExpense(),
      },
      {
        'icon': Icons.add_circle_outline,
        'label': 'Tạo thu nhập',
        'color': Colors.green,
        'action': () => homeController.navigateToCreateIncome(),
      },
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Tạo ngân sách',
        'color': Colors.orange,
        'action': () => homeController.navigateToCreateBudget(),
      },
    ];

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
                Icon(Icons.dashboard,
                    color: Theme.of(context).primaryColor,
                    size: isTablet ? 28 : 24),
                SizedBox(width: 12),
                Text(
                  'Thao tác nhanh',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 20 : 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: isTablet ? 2.5 : 2.0,
                crossAxisSpacing: isTablet ? 16 : 8,
                mainAxisSpacing: isTablet ? 16 : 8,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return _buildActionButton(context, action, isTablet);
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
        );
  }

  Widget _buildActionButton(
    BuildContext context,
    Map<String, dynamic> action,
    bool isTablet,
  ) {
    return Material(
      color: (action['color'] as Color).withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: action['action'] as VoidCallback,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (action['color'] as Color).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 10),
                decoration: BoxDecoration(
                  color: action['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: Colors.white,
                  size: isTablet ? 28 : 24,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 6),
              Flexible(
                child: Text(
                  action['label'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: action['color'] as Color,
                        fontSize: isTablet ? 14 : 11,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
