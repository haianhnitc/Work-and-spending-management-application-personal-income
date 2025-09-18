import 'dart:ui';

import 'package:flutter/material.dart';

enum Mood { happy, neutral, sad }

enum Reason { necessary, emotional, reward, other }

enum Category {
  study,
  lifestyle,
  skill,
  entertainment,
  work,
  personal,
  food,
  transport,
  shopping,
  health,
  education,
  utilities,
  salary,
  investment,
  gift,
  other,
}

enum IncomeType {
  none,
  variable,
  fixed,
}

String getMoodEmoji(Mood mood, bool istext) {
  switch (mood) {
    case Mood.happy:
      return istext ? 'Vui 😊' : '😊';
    case Mood.neutral:
      return istext ? 'Bình thường 😐' : '😐';
    case Mood.sad:
      return istext ? 'Buồn 😞' : '😞';
  }
}

Color getCategoryColor(int index) {
  const colors = [
    Color(0xFF4A90E2),
    Color(0xFF50C878),
    Color(0xFFF39C12),
    Color(0xFF9B59B6),
    Color(0xFFE74C3C),
    Color(0xFF1ABC9C),
    Color(0xFFF1C40F),
    Color(0xFF34495E),
    Color(0xFFD35400),
    Color(0xFFC0392B),
    Color(0xFF2ECC71),
    Color(0xFF7F8C8D),
  ];
  return colors[index % colors.length];
}

Color getCategoryColorByName(String categoryName) {
  switch (categoryName) {
    case 'study':
      return const Color(0xFF4A90E2);
    case 'lifestyle':
      return const Color(0xFF50C878);
    case 'skill':
      return const Color(0xFFF39C12);
    case 'entertainment':
      return const Color(0xFFE74C3C);
    case 'work':
      return const Color(0xFF8E44AD);
    case 'personal':
      return const Color(0xFF3498DB);
    default:
      return Colors.grey.shade600;
  }
}

String reasonToString(Reason reason) {
  switch (reason) {
    case Reason.necessary:
      return 'Cần thiết';
    case Reason.emotional:
      return 'Cảm xúc';
    case Reason.reward:
      return 'Tự thưởng';
    case Reason.other:
      return 'Khác';
    default:
      return 'Khác';
  }
}

String getIncomeTypeText(IncomeType type) {
  switch (type) {
    case IncomeType.fixed:
      return 'Thu nhập cố định';
    case IncomeType.variable:
      return 'Thu nhập không cố định';
    case IncomeType.none:
      return 'Không phải thu nhập';
    default:
      return 'Không phải thu nhập';
  }
}

String categoryToString(dynamic category) {
  switch (category) {
    case Category.study:
      return 'Học tập';
    case 'study':
      return 'Học tập';
    case Category.lifestyle:
      return 'Phong cách sống';
    case 'lifestyle':
      return 'Phong cách sống';
    case Category.skill:
      return 'Kỹ năng';
    case 'skill':
      return 'Kỹ năng';
    case Category.entertainment:
      return 'Giải trí';
    case 'entertainment':
      return 'Giải trí';
    case Category.work:
      return 'Công việc';
    case 'work':
      return 'Công việc';
    case Category.personal:
      return 'Cá nhân';
    case 'personal':
      return 'Cá nhân';
    case Category.food:
      return 'Ăn uống';
    case 'food':
      return 'Ăn uống';
    case Category.transport:
      return 'Đi lại';
    case 'transport':
      return 'Đi lại';
    case Category.shopping:
      return 'Mua sắm';
    case 'shopping':
      return 'Mua sắm';
    case Category.health:
      return 'Sức khỏe';
    case 'health':
      return 'Sức khỏe';
    case Category.education:
      return 'Giáo dục';
    case 'education':
      return 'Giáo dục';
    case Category.utilities:
      return 'Tiện ích';
    case 'utilities':
      return 'Tiện ích';
    case Category.salary:
      return 'Lương';
    case 'salary':
      return 'Lương';
    case Category.investment:
      return 'Đầu tư';
    case 'investment':
      return 'Đầu tư';
    case Category.gift:
      return 'Quà tặng';
    case 'gift':
      return 'Quà tặng';
    case Category.other:
      return 'Khác';
    case 'other':
      return 'Khác';
    default:
      return 'Khác';
  }
}
