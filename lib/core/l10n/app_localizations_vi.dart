// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Quản lý Công việc & Chi tiêu';

  @override
  String get taskTitle => 'Tiêu đề Công việc';

  @override
  String get createTask => 'Tạo Công việc';

  @override
  String get loginFailed => 'Đăng nhập thất bại';

  @override
  String get registerFailed => 'Đăng kí thất bại';

  @override
  String get error => 'Lỗi';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng kí';

  @override
  String get email => 'Email';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get password => 'Mật khẩu';

  @override
  String get invalidPassword => 'Mật khẩu không hợp lệ';

  @override
  String get goToRegister => 'Đi tới trang đăng kí';

  @override
  String get goToLogin => 'Đi tới trang đăng nhập';

  @override
  String get success => 'Thành công';

  @override
  String get expenseCreated => 'Tạo chi phí thành công';

  @override
  String get forgotPassword => 'Quên mật khẩu';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập địa chỉ email để nhận liên kết khôi phục mật khẩu';

  @override
  String get enterYourEmail => 'Nhập địa chỉ email của bạn';

  @override
  String get enterEmailAddress => 'Nhập địa chỉ email';

  @override
  String get emailRequired => 'Vui lòng nhập email';

  @override
  String get sendResetEmail => 'Gửi email khôi phục';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get passwordResetEmailSent => 'Email khôi phục mật khẩu đã được gửi';

  @override
  String get passwordChangedSuccessfully => 'Đổi mật khẩu thành công';

  @override
  String get passwordResetFailed => 'Gửi email khôi phục thất bại';

  @override
  String get changePasswordFailed => 'Đổi mật khẩu thất bại';

  @override
  String get userNotFound => 'Không tìm thấy người dùng';

  @override
  String get incorrectPassword => 'Mật khẩu không chính xác';

  @override
  String get invalidEmailAddress => 'Địa chỉ email không hợp lệ';

  @override
  String get userAccountDisabled => 'Tài khoản đã bị vô hiệu hóa';

  @override
  String get tooManyRequests => 'Quá nhiều yêu cầu. Vui lòng thử lại sau';

  @override
  String get networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối';

  @override
  String get weakPassword => 'Mật khẩu quá yếu';

  @override
  String get emailAlreadyInUse => 'Email đã được đăng ký. Vui lòng đăng nhập';

  @override
  String get requiresRecentLogin => 'Vui lòng đăng nhập lại để đổi mật khẩu';

  @override
  String get authenticationError => 'Lỗi xác thực';

  @override
  String get loginCredentialsError =>
      'Tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại';

  @override
  String get registrationError =>
      'Đăng ký thất bại. Vui lòng kiểm tra lại thông tin';
}
