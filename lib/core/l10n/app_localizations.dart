import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Công việc & Chi tiêu'**
  String get appName;

  /// No description provided for @taskTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề Công việc'**
  String get taskTitle;

  /// No description provided for @createTask.
  ///
  /// In vi, this message translates to:
  /// **'Tạo Công việc'**
  String get createTask;

  /// No description provided for @loginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng kí thất bại'**
  String get registerFailed;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng kí'**
  String get register;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @invalidPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không hợp lệ'**
  String get invalidPassword;

  /// No description provided for @goToRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đi tới trang đăng kí'**
  String get goToRegister;

  /// No description provided for @goToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đi tới trang đăng nhập'**
  String get goToLogin;

  /// No description provided for @success.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get success;

  /// No description provided for @expenseCreated.
  ///
  /// In vi, this message translates to:
  /// **'Tạo chi phí thành công'**
  String get expenseCreated;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ email để nhận liên kết khôi phục mật khẩu'**
  String get forgotPasswordSubtitle;

  /// No description provided for @enterYourEmail.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ email của bạn'**
  String get enterYourEmail;

  /// No description provided for @enterEmailAddress.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ email'**
  String get enterEmailAddress;

  /// No description provided for @emailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get emailRequired;

  /// No description provided for @sendResetEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email khôi phục'**
  String get sendResetEmail;

  /// No description provided for @backToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get backToLogin;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In vi, this message translates to:
  /// **'Email khôi phục mật khẩu đã được gửi'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu thành công'**
  String get passwordChangedSuccessfully;

  /// No description provided for @passwordResetFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email khôi phục thất bại'**
  String get passwordResetFailed;

  /// No description provided for @changePasswordFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu thất bại'**
  String get changePasswordFailed;

  /// No description provided for @userNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người dùng'**
  String get userNotFound;

  /// No description provided for @incorrectPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không chính xác'**
  String get incorrectPassword;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email không hợp lệ'**
  String get invalidEmailAddress;

  /// No description provided for @userAccountDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị vô hiệu hóa'**
  String get userAccountDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In vi, this message translates to:
  /// **'Quá nhiều yêu cầu. Vui lòng thử lại sau'**
  String get tooManyRequests;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi mạng. Vui lòng kiểm tra kết nối'**
  String get networkError;

  /// No description provided for @weakPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu quá yếu'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In vi, this message translates to:
  /// **'Email đã được đăng ký. Vui lòng đăng nhập'**
  String get emailAlreadyInUse;

  /// No description provided for @requiresRecentLogin.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập lại để đổi mật khẩu'**
  String get requiresRecentLogin;

  /// No description provided for @authenticationError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xác thực'**
  String get authenticationError;

  /// No description provided for @loginCredentialsError.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại'**
  String get loginCredentialsError;

  /// No description provided for @registrationError.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại. Vui lòng kiểm tra lại thông tin'**
  String get registrationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
