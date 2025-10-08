import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static bool _isShowing = false;

  static void showSuccess(String message, {int durationSeconds = 3}) {
    _showSnackbar(
      title: 'Thành công',
      message: message,
      isError: false,
      durationSeconds: durationSeconds,
    );
  }

  static void showError(String message, {int durationSeconds = 4}) {
    _showSnackbar(
      title: 'Lỗi',
      message: message,
      isError: true,
      durationSeconds: durationSeconds,
    );
  }

  static void showInfo(String message, {int durationSeconds = 3}) {
    _showSnackbar(
      title: 'Thông báo',
      message: message,
      isError: false,
      durationSeconds: durationSeconds,
      isInfo: true,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required bool isError,
    int durationSeconds = 3,
    bool isInfo = false,
  }) {
    try {
      _isShowing = true;

      if (Get.isSnackbarOpen) {
        print(' Closing existing snackbar');
        Get.closeCurrentSnackbar();
      }

      Future.delayed(Duration(milliseconds: 50), () {
        Color backgroundColor;
        Color textColor;
        IconData iconData;

        if (isError) {
          backgroundColor = Colors.red.withOpacity(0.9);
          textColor = Colors.white;
          iconData = Icons.error_outline;
        } else if (isInfo) {
          backgroundColor = Colors.blue.withOpacity(0.9);
          textColor = Colors.white;
          iconData = Icons.info_outline;
        } else {
          backgroundColor = Colors.green.withOpacity(0.9);
          textColor = Colors.white;
          iconData = Icons.check_circle_outline;
        }

        Get.snackbar(
          title,
          message,
          backgroundColor: backgroundColor,
          colorText: textColor,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: durationSeconds),
          borderRadius: 10,
          icon: Icon(
            iconData,
            color: textColor,
            size: 28,
          ),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
          shouldIconPulse: false,
          barBlur: 0,
          overlayBlur: 0,
        );

        print(' Snackbar shown successfully');

        Future.delayed(Duration(seconds: durationSeconds + 1), () {
          _isShowing = false;
        });
      });
    } catch (e) {
      print(' Error showing snackbar: $e');
      _isShowing = false;
    }
  }

  static void testSnackbar() {
    showSuccess('Test snackbar - Thành công!');

    Future.delayed(Duration(seconds: 4), () {
      showError('Test snackbar - Lỗi!');
    });

    Future.delayed(Duration(seconds: 8), () {
      showInfo('Test snackbar - Thông tin!');
    });
  }
}
