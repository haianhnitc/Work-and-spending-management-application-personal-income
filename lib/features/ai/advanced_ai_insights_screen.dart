import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/services/advanced_ai_service.dart';
import '../expense/presentation/controllers/expense_controller.dart';
import '../task/presentation/controllers/task_controller.dart';

class AdvancedAIInsightsScreen extends StatelessWidget {
  final AdvancedAIService _aiService = Get.find<AdvancedAIService>();
  final ExpenseController _expenseController = Get.find<ExpenseController>();
  final TaskController _taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Insights Nâng Cao',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sync, color: Colors.white),
            onPressed: () => _refreshAllData(),
          ).animate().rotate(duration: 1000.ms),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshAllData(),
        child: ListView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          children: [
            _buildStatusCards(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildAIFeatures(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildPredictiveAnalytics(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildBehavioralAnalysis(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildAnomalyDetection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildTrendForecasting(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context, bool isTablet) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                context,
                'AI Status',
                _aiService.isInitialized.value ? 'Online' : 'Offline',
                _aiService.isInitialized.value ? Colors.green : Colors.red,
                Icons.psychology,
                isTablet,
              ),
            ),
          ],
        ));
  }

  Widget _buildStatusCard(BuildContext context, String title, String status,
      Color color, IconData icon, bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          children: [
            Icon(icon, size: isTablet ? 32 : 28, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0);
  }

  // AI Features
  Widget _buildAIFeatures(BuildContext context, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🤖 Tính Năng AI Nâng Cao',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: isTablet ? 16 : 12,
              runSpacing: isTablet ? 16 : 12,
              children: [
                _buildFeatureButton(
                  context,
                  'Dự Đoán Chi Tiêu',
                  Icons.trending_up,
                  () => _showPredictiveAnalytics(context),
                  isTablet,
                ),
                _buildFeatureButton(
                  context,
                  'Phân Tích Hành Vi',
                  Icons.analytics,
                  () => _showBehavioralAnalysis(context),
                  isTablet,
                ),
                _buildFeatureButton(
                  context,
                  'Phát Hiện Bất Thường',
                  Icons.warning,
                  () => _showAnomalyDetection(context),
                  isTablet,
                ),
                _buildFeatureButton(
                  context,
                  'Dự Báo Xu Hướng',
                  Icons.insights,
                  () => _showTrendForecasting(context),
                  isTablet,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildFeatureButton(BuildContext context, String title, IconData icon,
      VoidCallback onTap, bool isTablet) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isTablet ? 160 : 140,
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: isTablet ? 32 : 28,
                color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Predictive Analytics
  Widget _buildPredictiveAnalytics(BuildContext context, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔮 Dự Đoán Chi Tiêu Tương Lai',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showPredictiveAnalytics(context),
              icon: Icon(Icons.auto_graph),
              label: Text('Xem Dự Đoán 6 Tháng Tới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms, delay: 400.ms);
  }

  // Behavioral Analysis
  Widget _buildBehavioralAnalysis(BuildContext context, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Phân Tích Hành Vi & Năng Suất',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showBehavioralAnalysis(context),
              icon: Icon(Icons.psychology),
              label: Text('Phân Tích Hành Vi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 500.ms);
  }

  // Anomaly Detection
  Widget _buildAnomalyDetection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚠️ Phát Hiện Giao Dịch Bất Thường',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAnomalyDetection(context),
              icon: Icon(Icons.warning),
              label: Text('Kiểm Tra Bất Thường'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 900.ms, delay: 600.ms);
  }

  // Trend Forecasting
  Widget _buildTrendForecasting(BuildContext context, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Dự Báo Xu Hướng Tài Chính',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showTrendForecasting(context),
              icon: Icon(Icons.trending_up),
              label: Text('Xem Dự Báo Xu Hướng'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms, delay: 700.ms);
  }

  // Helper methods
  Future<void> _refreshAllData() async {
    _expenseController.fetchExpenses();
    _taskController.fetchTasks();
    Get.snackbar('Thành công', 'Đã làm mới dữ liệu');
  }

  void _showPredictiveAnalytics(BuildContext context) {
    // Implement predictive analytics display
    Get.snackbar('Thông báo', 'Tính năng đang phát triển!');
  }

  void _showBehavioralAnalysis(BuildContext context) {
    // Implement behavioral analysis display
    Get.snackbar('Thông báo', 'Tính năng đang phát triển!');
  }

  void _showAnomalyDetection(BuildContext context) {
    // Implement anomaly detection display
    Get.snackbar('Thông báo', 'Tính năng đang phát triển!');
  }

  void _showTrendForecasting(BuildContext context) {
    // Implement trend forecasting display
    Get.snackbar('Thông báo', 'Tính năng đang phát triển!');
  }
}
