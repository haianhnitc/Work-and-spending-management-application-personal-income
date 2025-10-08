import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 32 : 24),
                  child: Column(
                    children: [
                      _buildHeader(context, isTablet),
                      SizedBox(height: isTablet ? 48 : 32),
                      _buildForgotPasswordCard(context, isTablet),
                      SizedBox(height: isTablet ? 32 : 24),
                      _buildBackToLoginButton(context, isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset,
            size: isTablet ? 64 : 48,
            color: Colors.white,
          ),
        ).animate().scale(duration: 800.ms).then().shimmer(duration: 2000.ms),
        SizedBox(height: isTablet ? 32 : 24),
        Text(
          'forgotPassword'.tr,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 32 : 28,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        SizedBox(height: isTablet ? 16 : 12),
        Text(
          'forgotPasswordSubtitle'.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: isTablet ? 18 : 16,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
      ],
    );
  }

  Widget _buildForgotPasswordCard(BuildContext context, bool isTablet) {
    return Card(
      elevation: 20,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
      ),
      child: Container(
        width: isTablet ? 500 : double.infinity,
        padding: EdgeInsets.all(isTablet ? 40 : 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'enterYourEmail'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 22 : 20,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isTablet ? 32 : 24),
              _buildEmailField(context, isTablet),
              SizedBox(height: isTablet ? 32 : 24),
              Obx(() => _buildSendButton(context, isTablet)),
              SizedBox(height: 16),
              Obx(() => _buildErrorMessage(context)),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildEmailField(BuildContext context, bool isTablet) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: isTablet ? 18 : 16),
      decoration: InputDecoration(
        labelText: 'email'.tr,
        hintText: 'enterEmailAddress'.tr,
        prefixIcon: Icon(Icons.email_outlined, size: isTablet ? 24 : 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'emailRequired'.tr;
        }
        if (!GetUtils.isEmail(value)) {
          return 'invalidEmail'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildSendButton(BuildContext context, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 56 : 48,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : _onSendPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'sendResetEmail'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    if (controller.errorMessage.value.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context, bool isTablet) {
    return TextButton.icon(
      onPressed: () => Get.back(),
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white.withOpacity(0.9),
      ),
      label: Text(
        'backToLogin'.tr,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 1000.ms);
  }

  void _onSendPressed() {
    if (_formKey.currentState!.validate()) {
      controller.sendPasswordResetEmail(_emailController.text.trim());
    }
  }
}
