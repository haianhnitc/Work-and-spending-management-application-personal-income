import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DateSection extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  const DateSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, isTablet),
            SizedBox(height: 16),
            _buildDateRow(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSectionHeader(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Thời Gian Áp Dụng',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateCard(
            context,
            'Ngày bắt đầu',
            startDate,
            Icons.play_arrow_rounded,
            onStartDateTap,
          ),
        ),
        SizedBox(width: 12),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDateCard(
            context,
            'Ngày kết thúc',
            endDate,
            Icons.stop_rounded,
            onEndDateTap,
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(
    BuildContext context,
    String title,
    DateTime date,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getDateDescription(date),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateDescription(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Ngày mai';
    } else if (difference == -1) {
      return 'Hôm qua';
    } else if (difference > 0) {
      return 'Còn $difference ngày';
    } else {
      return '${difference.abs()} ngày trước';
    }
  }
}
