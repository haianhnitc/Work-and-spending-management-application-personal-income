import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthForm extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final String errorMessage;
  final Function(String, String) onSubmit;
  final VoidCallback onSwitch;

  AuthForm({
    required this.isLogin,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
    required this.onSwitch,
  });

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'email'.tr),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@'))
                return 'invalidEmail'.tr;
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'password'.tr),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6)
                return 'invalidPassword'.tr;
              return null;
            },
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(errorMessage, style: TextStyle(color: Colors.red)),
            ),
          SizedBox(height: 16),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onSubmit(_emailController.text, _passwordController.text);
                    }
                  },
                  child: Text(isLogin ? 'login'.tr : 'register'.tr),
                ),
          TextButton(
            onPressed: onSwitch,
            child: Text(isLogin ? 'goToRegister'.tr : 'goToLogin'.tr),
          ),
        ],
      ),
    );
  }
}
