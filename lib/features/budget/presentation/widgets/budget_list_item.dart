import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/constants/app_enums.dart';
import '../../data/models/budget_model.dart';
import '../pages/budget_detail_screen.dart';

class BudgetListItem extends StatefulWidget {
  final BudgetModel budget;
  final int index;

  const BudgetListItem({
    super.key,
    required this.budget,
    required this.index,
  });

  @override
  State<BudgetListItem> createState() => _BudgetListItemState();
}

class _BudgetListItemState extends State<BudgetListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final usagePercentage = widget.budget.amount > 0
        ? (widget.budget.spentAmount / widget.budget.amount) * 100
        : 0.0;

    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _handleTapUp(),
      onTap: () => _handleTap(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _buildMainCard(context, isDark, usagePercentage),
          ),
        ),
      ),
    )
        .animate(delay: (widget.index * 100).ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack);
  }

  Widget _buildMainCard(
      BuildContext context, bool isDark, double usagePercentage) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D3748).withValues(alpha: 0.8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          if (!isDark)
            BoxShadow(
              color: getCategoryColorByName(widget.budget.category)
                  .withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark, usagePercentage),
          SizedBox(height: 16),
          _buildAmountSection(context, usagePercentage),
          SizedBox(height: 16),
          _buildProgressSection(context, usagePercentage),
          SizedBox(height: 12),
          _buildMetadata(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, double usagePercentage) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getCategoryColorByName(widget.budget.category),
                getCategoryColorByName(widget.budget.category)
                    .withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: getCategoryColorByName(widget.budget.category)
                    .withValues(alpha: 0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            getCategoryIcon(widget.budget.category),
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
                widget.budget.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getCategoryColorByName(widget.budget.category)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  categoryToString(widget.budget.category),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: getCategoryColorByName(widget.budget.category),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(context, usagePercentage),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, double usagePercentage) {
    final statusColor = _getStatusColor(usagePercentage);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(usagePercentage),
            color: statusColor,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            '${usagePercentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, double usagePercentage) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đã sử dụng',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                FormatUtils.formatCompactCurrency(widget.budget.spentAmount),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Ngân sách',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                FormatUtils.formatCompactCurrency(widget.budget.amount),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, double usagePercentage) {
    final remaining = widget.budget.amount - widget.budget.spentAmount;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Còn lại: ${FormatUtils.formatCompactCurrency(remaining)}',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(usagePercentage),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  _getStatusText(usagePercentage),
                  style: TextStyle(
                    color: _getStatusColor(usagePercentage),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildAnimatedProgress(context, usagePercentage),
      ],
    );
  }

  Widget _buildAnimatedProgress(BuildContext context, double usagePercentage) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: _getProgressGradient(usagePercentage),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ).animate().scaleX(
                begin: 0,
                end: (usagePercentage / 100).clamp(0.0, 1.0),
                duration: 1200.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, bool isDark) {
    final daysLeft = widget.budget.endDate.difference(DateTime.now()).inDays;

    return Row(
      children: [
        _buildMetaItem(
          context,
          Icons.calendar_today_outlined,
          '${FormatUtils.formatDateShort(widget.budget.startDate)} - ${FormatUtils.formatDateShort(widget.budget.endDate)}',
        ),
        Spacer(),
        if (daysLeft >= 0)
          _buildMetaItem(
            context,
            Icons.access_time,
            daysLeft == 0 ? 'Hôm nay' : '$daysLeft ngày',
          ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showActionSheet(context),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.more_horiz,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _handleTapDown() {
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    _animationController.reverse();
  }

  void _handleTap() {
    Get.to(() => BudgetDetailScreen(budget: widget.budget));
  }

  void _showActionSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.blue),
              title: Text('Xem chi tiết'),
              onTap: () {
                Navigator.pop(context);
                _handleTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.orange),
              title: Text('Chỉnh sửa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.green),
              title: Text('Chia sẻ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(double usagePercentage) {
    if (usagePercentage >= 95) {
      return Color(0xFFDC2626);
    } else if (usagePercentage >= 85) {
      return Color(0xFFEA580C);
    } else if (usagePercentage >= 70) {
      return Color(0xFFD97706);
    } else if (usagePercentage >= 50) {
      return Color(0xFF059669);
    }
    return Color(0xFF047857);
  }

  IconData _getStatusIcon(double usagePercentage) {
    if (usagePercentage >= 95) {
      return Icons.warning_rounded;
    } else if (usagePercentage >= 85) {
      return Icons.trending_up_rounded;
    } else if (usagePercentage >= 70) {
      return Icons.show_chart_rounded;
    }
    return Icons.trending_flat_rounded;
  }

  String _getStatusText(double usagePercentage) {
    if (usagePercentage >= 95) {
      return 'Vượt mức';
    } else if (usagePercentage >= 85) {
      return 'Gần hết';
    } else if (usagePercentage >= 70) {
      return 'Cảnh báo';
    } else if (usagePercentage >= 50) {
      return 'Ổn định';
    }
    return 'Tốt';
  }

  List<Color> _getProgressGradient(double usagePercentage) {
    if (usagePercentage >= 95) {
      return [Color(0xFFDC2626), Color(0xFFEF4444)];
    } else if (usagePercentage >= 85) {
      return [Color(0xFFEA580C), Color(0xFFF97316)];
    } else if (usagePercentage >= 70) {
      return [Color(0xFFD97706), Color(0xFFF59E0B)];
    } else if (usagePercentage >= 50) {
      return [Color(0xFF059669), Color(0xFF10B981)];
    }
    return [Color(0xFF047857), Color(0xFF059669)];
  }
}
