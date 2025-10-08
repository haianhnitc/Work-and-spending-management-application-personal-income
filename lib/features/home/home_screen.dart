import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../../core/widgets/common_app_bar.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/widgets/today_overview_widget.dart';
import 'presentation/widgets/financial_summary_widget.dart';
import 'presentation/widgets/smart_insights_widget.dart';
import 'presentation/widgets/quick_actions_widget.dart';
import 'presentation/widgets/recent_activities_widget.dart';
import 'presentation/widgets/monthly_charts_widget.dart';
import '../../core/utils/snackbar_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surface,
      appBar: CommonAppBar(
        title: 'Xin chào! 👋',
        subtitle: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        type: AppBarType.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              SnackbarHelper.showInfo('Chức năng đang phát triển!');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.95),
                  ]
                : [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surfaceContainerLowest,
                  ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
          },
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TodayOverviewWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 24 : 16),
                FinancialSummaryWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 24 : 16),
                SmartInsightsWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 24 : 16),
                QuickActionsWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 24 : 16),
                RecentActivitiesWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 24 : 16),
                MonthlyChartsWidget(isTablet: isTablet),
                SizedBox(height: isTablet ? 32 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
