import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import '../../../core/services/theme_service.dart';
import '../../core/utils/snackbar_helper.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ThemeService themeService = Get.find<ThemeService>();
  final RxString _avatarUrl = ''.obs;
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final user = authController.currentUser.value;

    _nameController.text = user?.name ?? 'User';
    _avatarUrl.value = user?.avatarUrl ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isTablet ? 300 : 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF4A90E2),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF9B59B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _pickAndUploadImage(),
                          child: CircleAvatar(
                            radius: isTablet ? 60 : 50,
                            backgroundImage: _avatarUrl.value.isNotEmpty
                                ? _avatarUrl.value.startsWith('data:image')
                                    ? MemoryImage(base64Decode(
                                        _avatarUrl.value.split(',')[1]))
                                    : NetworkImage(_avatarUrl.value)
                                        as ImageProvider
                                : null,
                            child: _avatarUrl.value.isEmpty
                                ? Icon(Icons.person,
                                    size: isTablet ? 60 : 50,
                                    color: Colors.white)
                                : null,
                          ).animate().scale(duration: 200.ms),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? 'No email',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 18 : 16,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading:
                            const Icon(Icons.edit, color: Color(0xFF4A90E2)),
                        title: Text('editName'.tr),
                        subtitle: Text(_nameController.text),
                        onTap: () => _showEditNameDialog(context),
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'settings'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.language,
                            color: Color(0xFF4A90E2)),
                        title: Text('language'.tr),
                        trailing: DropdownButton<String>(
                          value: Get.locale?.languageCode ?? 'vi',
                          items: const [
                            DropdownMenuItem(
                                value: 'vi', child: Text('Tiếng Việt')),
                            DropdownMenuItem(
                                value: 'en', child: Text('English')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              Get.updateLocale(Locale(value));
                            }
                          },
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    ),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.brightness_6,
                            color: Color(0xFF4A90E2)),
                        title: Text('theme'.tr),
                        trailing: Obx(() => Switch(
                              value: themeService.isDarkModeRx.value,
                              onChanged: (value) => themeService.toggleTheme(),
                              activeColor: const Color(0xFF4A90E2),
                            )),
                      ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'dataManagement'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.lock_outline,
                            color: Color(0xFF4A90E2)),
                        title: const Text('Đổi mật khẩu'),
                        subtitle: const Text('Thay đổi mật khẩu của bạn'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showChangePasswordDialog(context),
                      ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.analytics_outlined,
                            color: Color(0xFF4A90E2)),
                        title: Text('reports'.tr),
                        subtitle: Text('Xuất báo cáo và chia sẻ dữ liệu'),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF4A90E2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Mới',
                            style: TextStyle(
                              color: Color(0xFF4A90E2),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Navigate to Reports Screen for full export options
                          Get.toNamed('/reports');
                        },
                      ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: Text('logout'.tr,
                            style: const TextStyle(color: Colors.red)),
                        onTap: () => _showLogoutDialog(context),
                      ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) throw Exception('User not logged in');

        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '${pickedFile.path}_compressed.jpg',
          quality: 70,
          minWidth: 200,
          minHeight: 200,
        );
        if (compressedFile == null) throw Exception('Compression failed');

        final bytes = await compressedFile.readAsBytes();
        final base64String = base64Encode(bytes);
        final avatarUrl = 'data:image/jpeg;base64,$base64String';

        // Update Firestore với avatarUrl
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'avatarUrl': avatarUrl,
        });

        // Update local state
        _avatarUrl.value = avatarUrl;

        // Update current user in controller
        final currentUser = authController.currentUser.value;
        if (currentUser != null) {
          authController.currentUser.value =
              currentUser.copyWith(avatarUrl: avatarUrl);
        }

        SnackbarHelper.showSuccess('avatarUpdated'.tr);
      } catch (e) {
        SnackbarHelper.showError('failedToUploadAvatar'.tr);
      }
    }
  }

  void _showEditNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('editName'.tr),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'name'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              try {
                final newName = _nameController.text.trim();

                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(newName);

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .update({'name': newName});

                final currentUser = authController.currentUser.value;
                if (currentUser != null) {
                  authController.currentUser.value =
                      currentUser.copyWith(name: newName);
                }

                Get.back();
                SnackbarHelper.showSuccess('nameUpdated'.tr);
              } catch (e) {
                SnackbarHelper.showError('failedToUpdateName'.tr);
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final RxBool obscureCurrentPassword = true.obs;
    final RxBool obscureNewPassword = true.obs;
    final RxBool obscureConfirmPassword = true.obs;
    final RxBool isLoading = false.obs;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Đổi mật khẩu'),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => TextFormField(
                      controller: currentPasswordController,
                      obscureText: obscureCurrentPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu hiện tại',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureCurrentPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => obscureCurrentPassword.toggle(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập mật khẩu hiện tại';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => obscureNewPassword.toggle(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        if (value!.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu mới',
                        prefixIcon: const Icon(Icons.lock_clock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => obscureConfirmPassword.toggle(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng xác nhận mật khẩu mới';
                        }
                        if (value != newPasswordController.text) {
                          return 'Mật khẩu xác nhận không khớp';
                        }
                        return null;
                      },
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          isLoading.value = true;
                          try {
                            await authController.changePassword(
                              currentPasswordController.text,
                              newPasswordController.text,
                            );
                            Get.back();
                          } catch (e) {
                            print('${e}');
                          } finally {
                            isLoading.value = false;
                          }
                        }
                      },
                child: isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Đổi mật khẩu'),
              )),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr),
        content: Text('logoutConfirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              authController.authUseCase.signOut();
              Get.offAllNamed('/login');
            },
            child:
                Text('confirm'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
