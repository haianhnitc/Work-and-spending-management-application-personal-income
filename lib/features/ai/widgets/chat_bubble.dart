import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../../../core/services/theme_service.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTablet;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final isDark = themeService.isDarkMode;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment:
              message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) _buildAvatar(isDark),
            if (!message.isUser) SizedBox(width: 12),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: _buildMessageBubble(isDark),
              ),
            ),
            if (message.isUser) SizedBox(width: 12),
            if (message.isUser) _buildUserAvatar(isDark),
          ],
        ),
      );
    });
  }

  Widget _buildAvatar(bool isDark) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.smart_toy_outlined,
        color: Colors.white,
        size: 20,
      ),
    ).animate().scale(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildUserAvatar(bool isDark) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4facfe),
            Color(0xFF00f2fe),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4facfe).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.person_outline,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMessageBubble(bool isDark) {
    if (message.type == MessageType.typing) {
      return _buildTypingIndicator(isDark);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: message.isUser
            ? LinearGradient(
                colors: [
                  Color(0xFF4facfe),
                  Color(0xFF00f2fe),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: message.isUser
            ? null
            : (isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(message.isUser ? 20 : 4),
          bottomRight: Radius.circular(message.isUser ? 4 : 20),
        ),
        border: message.isUser
            ? null
            : Border.all(
                color: isDark ? Color(0xFF3A3A3A) : Color(0xFFE0E0E0),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: message.isUser
                ? Color(0xFF4facfe).withOpacity(0.2)
                : (isDark ? Colors.black26 : Colors.black12),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessageContent(isDark),
          SizedBox(height: 4),
          _buildMessageTime(isDark),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(
          begin: message.isUser ? 0.3 : -0.3,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Color(0xFF3A3A3A) : Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTypingDot()
              .animate(onPlay: (controller) => controller.repeat())
              .fade(duration: 600.ms),
          SizedBox(width: 4),
          _buildTypingDot()
              .animate(onPlay: (controller) => controller.repeat())
              .fade(duration: 600.ms, delay: 200.ms),
          SizedBox(width: 4),
          _buildTypingDot()
              .animate(onPlay: (controller) => controller.repeat())
              .fade(duration: 600.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildTypingDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMessageContent(bool isDark) {
    return SelectableText(
      message.content,
      style: TextStyle(
        fontSize: isTablet ? 16 : 14,
        color: message.isUser
            ? Colors.white
            : (isDark ? Colors.white : Color(0xFF2A2A2A)),
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }

  Widget _buildMessageTime(bool isDark) {
    final time =
        "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}";

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: message.isUser
                ? Colors.white.withOpacity(0.8)
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
            fontWeight: FontWeight.w400,
          ),
        ),
        if (message.isUser) ...[
          SizedBox(width: 4),
          Icon(
            message.status == MessageStatus.error
                ? Icons.error_outline
                : message.status == MessageStatus.sent
                    ? Icons.check
                    : message.status == MessageStatus.delivered
                        ? Icons.done_all
                        : Icons.access_time,
            size: 12,
            color: message.status == MessageStatus.error
                ? Colors.red[300]
                : Colors.white.withOpacity(0.8),
          ),
        ],
      ],
    );
  }
}
