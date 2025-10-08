import 'package:intl/intl.dart';

class FormatUtils {
  static String formatCurrency(double amount) {
    return NumberFormat('#,###', 'vi').format(amount);
  }

  static String formatCurrencyWithSymbol(double amount) {
    return '${formatCurrency(amount)} ₫';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  static String formatNumber(double number) {
    return NumberFormat('#,###', 'vi').format(number);
  }

  static String formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M ₫';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K ₫';
    } else {
      return formatCurrencyWithSymbol(amount);
    }
  }
}
