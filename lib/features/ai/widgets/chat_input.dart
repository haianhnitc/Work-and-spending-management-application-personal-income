import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../ai_controller.dart';
import '../../../core/services/theme_service.dart';

class ChatInput extends StatefulWidget {
  final bool isTablet;

  const ChatInput({
    Key? key,
    this.isTablet = false,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final AIController controller = Get.find<AIController>();
  final ThemeService themeService = Get.find<ThemeService>();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeService.isDarkMode;

      return Container(
        padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Color(0xFF2A2A2A) : Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(isDark),
              ),
              SizedBox(width: 12),
              _buildSendButton(isDark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextField(bool isDark) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 48,
        maxHeight: 120,
      ),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Color(0xFF3A3A3A) : Color(0xFFE8E8E8),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller.chatTextController,
        focusNode: _focusNode,
        maxLines: null,
        textInputAction: TextInputAction.send,
        enabled: !controller.isChatLoading.value,
        style: TextStyle(
          fontSize: widget.isTablet ? 16 : 14,
          color: isDark ? Colors.white : Color(0xFF2A2A2A),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: controller.isChatLoading.value
              ? 'AI đang suy nghĩ...'
              : 'Nhắn tin với AI Assistant...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: widget.isTablet ? 16 : 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.chat_bubble_outline,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 20,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
        ),
        onSubmitted:
            controller.isChatLoading.value ? null : (value) => _sendMessage(),
      ),
    );
  }

  Widget _buildSendButton(bool isDark) {
    return Obx(() => AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: _getSendButtonGradient(),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF4facfe).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: controller.isChatLoading.value ||
                      controller.chatTextController.text.trim().isEmpty
                  ? null
                  : _sendMessage,
              child: _buildSendIcon(),
            ),
          ),
        ));
  }

  LinearGradient _getSendButtonGradient() {
    if (controller.isChatLoading.value) {
      return LinearGradient(
        colors: [Colors.grey[400]!, Colors.grey[500]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    if (controller.chatTextController.text.trim().isEmpty) {
      return LinearGradient(
        colors: [Colors.grey[300]!, Colors.grey[400]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return LinearGradient(
      colors: [
        Color(0xFF4facfe),
        Color(0xFF00f2fe),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Widget _buildSendIcon() {
    return Center(
      child: controller.isChatLoading.value
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20,
            ).animate().scale(
                duration: 200.ms,
                curve: Curves.easeInOut,
              ),
    );
  }

  void _sendMessage() {
    final message = controller.chatTextController.text.trim();
    if (message.isNotEmpty && !controller.isChatLoading.value) {
      controller.sendChatMessage(message);
      _focusNode.unfocus();
    }
  }
}
