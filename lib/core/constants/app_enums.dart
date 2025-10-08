import 'package:flutter/material.dart';

enum AppBarType {
  primary,
  secondary,
  modal,
}

enum Mood { happy, neutral, sad }

enum Reason { necessary, emotional, reward, other }

enum ChartType { pie, bar, line }

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
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFFFFC107),
    Color(0xFF607D8B),
    Color(0xFFF44336),
    Color(0xFF673AB7),
    Color(0xFF009688),
    Color(0xFF795548),
    Color(0xFF3F51B5),
    Color(0xFFE1BEE7),
    Color(0xFF9E9E9E),
    Color(0xFF8BC34A),
  ];
  return colors[index % colors.length];
}

Color getCategoryColorByName(String categoryName) {
  switch (categoryName) {
    case 'study':
      return const Color(0xFF2196F3);
    case 'lifestyle':
      return const Color(0xFF4CAF50);
    case 'skill':
      return const Color(0xFFFF9800);
    case 'entertainment':
      return const Color(0xFFE91E63);
    case 'work':
      return const Color(0xFF9C27B0);
    case 'personal':
      return const Color(0xFF00BCD4);
    case 'food':
      return const Color(0xFFFF5722);
    case 'transport':
      return const Color(0xFFFFC107);
    case 'shopping':
      return const Color(0xFF607D8B);
    case 'health':
      return const Color(0xFFF44336);
    case 'education':
      return const Color(0xFF673AB7);
    case 'utilities':
      return const Color(0xFF009688);
    case 'salary':
      return const Color(0xFF795548);
    case 'investment':
      return const Color(0xFF3F51B5);
    case 'gift':
      return const Color(0xFFE1BEE7);
    case 'other':
      return const Color(0xFF9E9E9E);
  }
  return const Color(0xFF8BC34A);
}

Color getCategoryColorByEnum(Category category) {
  switch (category) {
    case Category.study:
      return const Color(0xFF2196F3);
    case Category.lifestyle:
      return const Color(0xFF4CAF50);
    case Category.skill:
      return const Color(0xFFFF9800);
    case Category.entertainment:
      return const Color(0xFFE91E63);
    case Category.work:
      return const Color(0xFF9C27B0);
    case Category.personal:
      return const Color(0xFF00BCD4);
    case Category.food:
      return const Color(0xFFFF5722);
    case Category.transport:
      return const Color(0xFFFFC107);
    case Category.shopping:
      return const Color(0xFF607D8B);
    case Category.health:
      return const Color(0xFFF44336);
    case Category.education:
      return const Color(0xFF673AB7);
    case Category.utilities:
      return const Color(0xFF009688);
    case Category.salary:
      return const Color(0xFF795548);
    case Category.investment:
      return const Color(0xFF3F51B5);
    case Category.gift:
      return const Color(0xFFE1BEE7);
    case Category.other:
      return const Color(0xFF9E9E9E);
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

String chartTypeToString(ChartType chartType) {
  switch (chartType) {
    case ChartType.pie:
      return 'Tròn';
    case ChartType.bar:
      return 'Cột';
    case ChartType.line:
      return 'Đường';
  }
}

IconData getChartTypeIcon(ChartType chartType) {
  switch (chartType) {
    case ChartType.pie:
      return Icons.pie_chart;
    case ChartType.bar:
      return Icons.bar_chart;
    case ChartType.line:
      return Icons.show_chart;
  }
}

String displayNameToCategory(String displayName) {
  switch (displayName) {
    case 'Học tập':
      return 'study';
    case 'Phong cách sống':
      return 'lifestyle';
    case 'Kỹ năng':
      return 'skill';
    case 'Giải trí':
      return 'entertainment';
    case 'Công việc':
      return 'work';
    case 'Cá nhân':
      return 'personal';
    case 'Ăn uống':
      return 'food';
    case 'Đi lại':
      return 'transport';
    case 'Mua sắm':
      return 'shopping';
    case 'Sức khỏe':
      return 'health';
    case 'Giáo dục':
      return 'education';
    case 'Tiện ích':
      return 'utilities';
    case 'Lương':
      return 'salary';
    case 'Đầu tư':
      return 'investment';
    case 'Quà tặng':
      return 'gift';
    case 'Khác':
      return 'other';
    default:
      return 'other';
  }
}

IconData getCategoryIcon(dynamic category) {
  switch (category) {
    case Category.study:
    case 'study':
      return Icons.school_rounded;
    case Category.lifestyle:
    case 'lifestyle':
      return Icons.style_rounded;
    case Category.skill:
    case 'skill':
      return Icons.build_rounded;
    case Category.entertainment:
    case 'entertainment':
      return Icons.celebration_rounded;
    case Category.work:
    case 'work':
      return Icons.work_rounded;
    case Category.personal:
    case 'personal':
      return Icons.person_rounded;
    case Category.food:
    case 'food':
      return Icons.restaurant_rounded;
    case Category.transport:
    case 'transport':
      return Icons.directions_car_rounded;
    case Category.shopping:
    case 'shopping':
      return Icons.shopping_bag_rounded;
    case Category.health:
    case 'health':
      return Icons.health_and_safety_rounded;
    case Category.education:
    case 'education':
      return Icons.menu_book_rounded;
    case Category.utilities:
    case 'utilities':
      return Icons.electrical_services_rounded;
    case Category.salary:
    case 'salary':
      return Icons.payments_rounded;
    case Category.investment:
    case 'investment':
      return Icons.trending_up_rounded;
    case Category.gift:
    case 'gift':
      return Icons.card_giftcard_rounded;
    case Category.other:
    case 'other':
    default:
      return Icons.more_horiz_rounded;
  }
}

String getPeriodDisplayName(String period) {
  switch (period) {
    case 'daily':
      return 'Hằng ngày';
    case 'weekly':
      return 'Hằng tuần';
    case 'monthly':
      return 'Hằng tháng';
    case 'yearly':
      return 'Hằng năm';
    case 'custom':
      return 'Tùy chỉnh';
    default:
      return period;
  }
}
