import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';

class RecentActivitiesWidget extends StatelessWidget {
  final bool isTablet;

  const RecentActivitiesWidget({
    Key? key,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final activities = homeController.getRecentActivities();

      if (activities.isEmpty) {
        return _buildEmptyStateCard(context);
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
                          child: Icon(Icons.history,
                              color: Theme.of(context).primaryColor,
                              size: isTablet ? 24 : 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoạt động gần đây',
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
                                '${activities.length} hoạt động',
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
                  TextButton(
                    onPressed: () => homeController.showAllActivities(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(0, 0),
                    ),
                    child: Text(
                      'Tất cả',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Container(
                height: isTablet ? 200 : 160,
                child: ListView.separated(
                  itemCount: activities.take(isTablet ? 4 : 3).length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityItem(context, activity, isTablet);
                  },
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    bool isTablet,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: (activity['color'] as Color).withOpacity(0.1),
        radius: isTablet ? 24 : 20,
        child: Icon(
          activity['icon'] as IconData,
          color: activity['color'] as Color,
          size: isTablet ? 24 : 18,
        ),
      ),
      title: Text(
        activity['title'] as String,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 16 : 14,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        activity['subtitle'] as String,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: isTablet ? 14 : 12,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        width: isTablet ? 80 : 70,
        child: Text(
          DateFormat('dd/MM HH:mm').format(activity['date'] as DateTime),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: isTablet ? 12 : 10,
              ),
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.history,
                    color: Theme.of(context).primaryColor,
                    size: isTablet ? 28 : 24),
                SizedBox(width: 12),
                Text(
                  'Hoạt động gần đây',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 32 : 24),
            Icon(
              Icons.inbox_outlined,
              size: isTablet ? 64 : 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Chưa có hoạt động nào gần đây',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              'Hãy thêm chi tiêu hoặc nhiệm vụ để xem hoạt động',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
        );
  }
}
