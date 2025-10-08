// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Task & Expense Manager';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get createTask => 'Create Task';

  @override
  String get loginFailed => 'Login Failed';

  @override
  String get registerFailed => 'Register Failed';

  @override
  String get error => 'Error';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get password => 'Password';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get goToRegister => 'Go to Register';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get success => 'Success';

  @override
  String get expenseCreated => 'Expense created successfully';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address to receive password reset link';

  @override
  String get enterYourEmail => 'Enter your email address';

  @override
  String get enterEmailAddress => 'Enter email address';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get passwordResetEmailSent => 'Password reset email sent';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get passwordResetFailed => 'Password reset failed';

  @override
  String get changePasswordFailed => 'Change password failed';

  @override
  String get userNotFound => 'User not found';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get invalidEmailAddress => 'Invalid email address';

  @override
  String get userAccountDisabled => 'User account has been disabled';

  @override
  String get tooManyRequests => 'Too many requests. Please try again later';

  @override
  String get networkError => 'Network error. Please check your connection';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get emailAlreadyInUse =>
      'Email is already registered. Please login instead';

  @override
  String get requiresRecentLogin => 'Please login again to change password';

  @override
  String get authenticationError => 'Authentication error';

  @override
  String get loginCredentialsError =>
      'Incorrect email or password. Please try again';

  @override
  String get registrationError =>
      'Registration failed. Please check your information';
}
