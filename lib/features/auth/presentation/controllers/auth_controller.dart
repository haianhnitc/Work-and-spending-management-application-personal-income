import 'package:get/get.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecase/auth_usecase.dart';

class AuthController extends GetxController {
  final AuthUseCase authUseCase;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentUser = Rxn<UserModel>();

  AuthController(this.authUseCase);

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userModel = await authUseCase.signIn(email, password);
      currentUser.value = userModel;
      print('SignIn successful: ${userModel.uid}');

      SnackbarHelper.showSuccess(
        'Đăng nhập thành công!',
        durationSeconds: 2,
      );

      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed('/main');
      });
    } catch (e) {
      print('SignIn error: $e');
      final errorText = e.toString();
      String friendlyError;

      if (errorText.contains('userNotFound') ||
          errorText.contains('user-not-found')) {
        friendlyError = 'Không tìm thấy tài khoản với email này';
      } else if (errorText.contains('invalid-email')) {
        friendlyError = 'Email không hợp lệ';
      } else if (errorText.contains('too-many-requests')) {
        friendlyError = 'Quá nhiều lần thử. Vui lòng thử lại sau';
      } else {
        friendlyError = 'Đăng nhập thất bại. Kiểm tra lại email và mật khẩu';
      }

      errorMessage.value = friendlyError;
      SnackbarHelper.showError(friendlyError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userModel = await authUseCase.signUpWithName(name, email, password);
      currentUser.value = userModel;
      print('SignUp successful: ${userModel.uid} - ${userModel.name}');

      SnackbarHelper.showSuccess(
        'Đăng ký thành công! Chào mừng ${userModel.name}',
        durationSeconds: 3,
      );

      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed('/home');
      });
    } catch (e) {
      print('SignUp error: $e');
      String friendlyError;
      final errorText = e.toString();

      if (errorText.contains('email-already-in-use')) {
        friendlyError = 'Email này đã được sử dụng';
      } else if (errorText.contains('invalid-email')) {
        friendlyError = 'Email không hợp lệ';
      } else if (errorText.contains('weak-password')) {
        friendlyError = 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn';
      } else {
        friendlyError = 'Đăng ký thất bại. Vui lòng thử lại';
      }

      errorMessage.value = friendlyError;
      SnackbarHelper.showError(friendlyError);
    } finally {
      isLoading.value = false;
    }
  }

  String getCurrentUserId() {
    return authUseCase.getCurrentUserId() ?? '';
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await authUseCase.sendPasswordResetEmail(email);

      SnackbarHelper.showSuccess(
        'Email đặt lại mật khẩu đã được gửi đến $email.\nVui lòng kiểm tra hộp thư (kể cả thư spam).',
        durationSeconds: 5,
      );

      Future.delayed(Duration(seconds: 1), () {
        if (Get.currentRoute != '/login') {
          Get.back();
        }
      });
    } catch (e) {
      print('Password reset error: $e');
      String friendlyError;
      final errorText = e.toString();

      if (errorText.contains('user-not-found')) {
        friendlyError = 'Không tìm thấy tài khoản với email này';
      } else if (errorText.contains('invalid-email')) {
        friendlyError = 'Email không hợp lệ';
      } else if (errorText.contains('network') ||
          errorText.contains('timeout')) {
        friendlyError = 'Không thể kết nối. Kiểm tra internet và thử lại';
      } else if (errorText.contains('too-many-requests')) {
        friendlyError = 'Quá nhiều yêu cầu. Vui lòng thử lại sau 5 phút';
      } else {
        friendlyError = 'Không thể gửi email đặt lại mật khẩu. Thử lại sau';
      }

      errorMessage.value = friendlyError;
      SnackbarHelper.showError(friendlyError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await authUseCase.changePassword(currentPassword, newPassword);

      SnackbarHelper.showSuccess(
        'Đổi mật khẩu thành công!',
        durationSeconds: 3,
      );
    } catch (e) {
      print('Change password error: $e');
      String friendlyError;
      final errorText = e.toString();

      if (errorText.contains('wrong-password')) {
        friendlyError = 'Mật khẩu hiện tại không đúng';
      } else if (errorText.contains('weak-password')) {
        friendlyError = 'Mật khẩu mới quá yếu. Chọn mật khẩu mạnh hơn';
      } else if (errorText.contains('requires-recent-login')) {
        friendlyError = 'Cần đăng nhập lại để thực hiện thao tác này';
      } else {
        friendlyError = 'Không thể đổi mật khẩu. Thử lại sau';
      }

      errorMessage.value = friendlyError;
      SnackbarHelper.showError(friendlyError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await authUseCase.signOut();
      currentUser.value = null;

      SnackbarHelper.showSuccess(
        'Đã đăng xuất thành công',
        durationSeconds: 2,
      );

      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed('/login');
      });
    } catch (e) {
      print('Sign out error: $e');
      Get.offAllNamed('/login');
    }
  }
}
