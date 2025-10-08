import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'ai_controller.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';
import '../../core/services/theme_service.dart';

class AIChatScreen extends StatelessWidget {
  final AIController controller = Get.find<AIController>();
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      final isDark = themeService.isDarkMode;

      return Scaffold(
        backgroundColor: _getBackgroundColor(isDark),
        body: Column(
          children: [
            _buildHeader(context, isTablet, isDark),
            Expanded(
              child: _buildChatArea(context, isTablet, isDark),
            ),
            ChatInput(isTablet: isTablet),
          ],
        ),
      );
    });
  }

  Color _getBackgroundColor(bool isDark) {
    return isDark ? Color(0xFF121212) : Color(0xFFFAFAFA);
  }

  Widget _buildHeader(BuildContext context, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isTablet ? 24 : 16,
            isTablet ? 24 : 16,
            isTablet ? 24 : 16,
            isTablet ? 24 : 20,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: isTablet ? 24 : 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: isTablet ? 28 : 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                            .animate(
                                onPlay: (controller) => controller.repeat())
                            .fadeIn(duration: 1000.ms)
                            .then()
                            .fadeOut(duration: 1000.ms),
                        SizedBox(width: 8),
                        Text(
                          'Trực tuyến',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: isTablet ? 24 : 20,
                  ),
                  color: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(
                            Icons.clear_all,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Xóa lịch sử chat',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'help',
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Hướng dẫn sử dụng',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'clear':
                        _showClearConfirmDialog(context, isDark);
                        break;
                      case 'help':
                        _showHelpDialog(context, isDark);
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea(BuildContext context, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: controller.chatMessages.isEmpty
                ? _buildEmptyState(isTablet, isDark)
                : ListView.builder(
                    controller: controller.chatScrollController,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: controller.chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = controller.chatMessages[index];
                      return ChatBubble(
                        message: message,
                        isTablet: isTablet,
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: index * 100),
                            duration: 400.ms,
                          )
                          .slideY(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isTablet ? 120 : 100,
            height: isTablet ? 120 : 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isTablet ? 60 : 50),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: isTablet ? 50 : 40,
            ),
          )
              .animate()
              .scale(delay: 300.ms, duration: 600.ms, curve: Curves.elasticOut),
          SizedBox(height: 24),
          Text(
            'Bắt đầu cuộc trò chuyện',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF2A2A2A),
            ),
          ).animate().fadeIn(delay: 600.ms),
          SizedBox(height: 8),
          Text(
            'Hỏi AI bất cứ điều gì về tài chính\nvà quản lý thời gian',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.4,
            ),
          ).animate().fadeIn(delay: 800.ms),
          SizedBox(height: 32),
          _buildSuggestionChips(isTablet, isDark),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(bool isTablet, bool isDark) {
    final suggestions = [
      'Phân tích chi tiêu của tôi',
      'Gợi ý tiết kiệm tiền',
      'Quản lý thời gian hiệu quả',
      'Dự đoán chi tiêu tháng tới',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: suggestions.asMap().entries.map((entry) {
        final index = entry.key;
        final suggestion = entry.value;

        return GestureDetector(
          onTap: () => controller.sendChatMessage(suggestion),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Color(0xFF3A3A3A) : Color(0xFFE0E0E0),
              ),
            ),
            child: Text(
              suggestion,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: isDark ? Colors.white : Color(0xFF2A2A2A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 1000 + index * 200));
      }).toList(),
    );
  }

  void _showClearConfirmDialog(BuildContext context, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Xóa lịch sử chat?',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tất cả tin nhắn sẽ bị xóa và không thể khôi phục.',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Xóa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Color(0xFF667eea),
            ),
            SizedBox(width: 8),
            Text(
              'Hướng dẫn sử dụng',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('💰', 'Phân tích chi tiêu',
                  'Hỏi về chi tiêu, tiết kiệm, đầu tư', isDark),
              _buildHelpItem('⏰', 'Quản lý thời gian',
                  'Lập kế hoạch, ưu tiên công việc', isDark),
              _buildHelpItem('📊', 'Báo cáo và dự đoán',
                  'Xem xu hướng, dự báo tương lai', isDark),
              _buildHelpItem('💡', 'Gợi ý cá nhân',
                  'Nhận lời khuyên phù hợp với bạn', isDark),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Đã hiểu',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
      String emoji, String title, String description, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
