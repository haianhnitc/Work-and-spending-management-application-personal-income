import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final bool isLoading;
  final String? errorMessage;
  final Function(String email, String password)? onSubmit;
  final Function(String name, String email, String password)? onSubmitWithName;
  final VoidCallback onSwitch;

  const AuthForm({
    Key? key,
    required this.isLogin,
    required this.isLoading,
    this.errorMessage,
    this.onSubmit,
    this.onSubmitWithName,
    required this.onSwitch,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        widget.onSubmit
            ?.call(_emailController.text.trim(), _passwordController.text);
      } else {
        widget.onSubmitWithName?.call(_nameController.text.trim(),
            _emailController.text.trim(), _passwordController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isLogin) ...[
            _buildInputField(
              controller: _nameController,
              label: 'Họ và tên',
              hint: 'Nhập họ và tên của bạn',
              icon: Icons.person_rounded,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ và tên';
                }
                if (value.trim().length < 2) {
                  return 'Tên phải có ít nhất 2 ký tự';
                }
                return null;
              },
              isTablet: isTablet,
            ),
            SizedBox(height: isTablet ? 24 : 20),
          ],
          _buildInputField(
            controller: _emailController,
            label: 'Email',
            hint: 'Nhập email của bạn',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildInputField(
            controller: _passwordController,
            label: 'Mật khẩu',
            hint: 'Nhập mật khẩu của bạn',
            icon: Icons.lock_rounded,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
            isTablet: isTablet,
          ),
          if (!widget.isLogin) ...[
            SizedBox(height: isTablet ? 24 : 20),
            _buildInputField(
              controller: _confirmPasswordController,
              label: 'Xác nhận mật khẩu',
              hint: 'Nhập lại mật khẩu của bạn',
              icon: Icons.lock_rounded,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận mật khẩu';
                }
                if (value != _passwordController.text) {
                  return 'Mật khẩu không khớp';
                }
                return null;
              },
              isTablet: isTablet,
            ),
          ],
          SizedBox(height: isTablet ? 32 : 24),
          if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w500,
                            fontSize: isTablet ? 16 : 14,
                          ),
                    ),
                  ),
                ],
              ),
            ).animate().slideX(
                  begin: 0.2,
                  end: 0,
                  duration: 200.ms,
                  curve: Curves.easeOutCubic,
                ),
          if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
            SizedBox(height: isTablet ? 24 : 20),
          SizedBox(
            height: isTablet ? 56 : 48,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 8,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: isTablet ? 24 : 20,
                      height: isTablet ? 24 : 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      widget.isLogin ? 'Đăng nhập' : 'Đăng ký',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: isTablet ? 18 : 16,
                          ),
                    ),
            ),
          ).animate().scale(
                duration: 150.ms,
                curve: Curves.easeOutCubic,
              ),
          if (widget.isLogin) ...[
            SizedBox(height: isTablet ? 16 : 12),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
              child: Text(
                'Quên mật khẩu?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 15 : 13,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ],
          SizedBox(height: isTablet ? 24 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.isLogin ? 'Chưa có tài khoản? ' : 'Đã có tài khoản? ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                        fontSize: isTablet ? 16 : 14,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: widget.onSwitch,
                child: Text(
                  widget.isLogin ? 'Đăng ký ngay' : 'Đăng nhập',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 16 : 14,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: isTablet ? 16 : 14,
              ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 18 : 16,
              ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: isTablet ? 16 : 14,
                ),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: isTablet ? 26 : 22,
            ),
            suffixIcon: obscureText
                ? IconButton(
                    icon: Icon(
                      obscureText == _obscurePassword
                          ? (_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility)
                          : (_obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      size: isTablet ? 24 : 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (obscureText == _obscurePassword) {
                          _obscurePassword = !_obscurePassword;
                        } else {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }
                      });
                    },
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 20 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
