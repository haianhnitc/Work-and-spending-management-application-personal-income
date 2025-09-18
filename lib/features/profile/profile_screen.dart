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

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ThemeService themeService = Get.find<ThemeService>();
  final RxString _avatarBase64 = ''.obs;
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final user = authController.currentUser.value;

    _nameController.text = user?.name ?? 'User';
    _loadAvatarBase64(user?.uid);

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
                            backgroundImage: _avatarBase64.value.isNotEmpty
                                ? MemoryImage(base64Decode(_avatarBase64.value))
                                : null,
                            child: _avatarBase64.value.isEmpty
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
                              value: themeService.isDarkMode,
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
                        leading: const Icon(Icons.download,
                            color: Color(0xFF4A90E2)),
                        title: Text('exportData'.tr),
                        onTap: () => _showExportDataDialog(context),
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

  Future<void> _loadAvatarBase64(String? userId) async {
    if (userId == null) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    if (data != null && data.containsKey('avatar')) {
      _avatarBase64.value = data['avatar'];
    }
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

        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {'avatar': base64String},
          SetOptions(merge: true),
        );

        _avatarBase64.value = base64String;
        Get.snackbar('success'.tr, 'avatarUpdated'.tr);
      } catch (e) {
        Get.snackbar('error'.tr, 'failedToUploadAvatar'.tr);
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
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(_nameController.text);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set(
                  {'displayName': _nameController.text},
                  SetOptions(merge: true),
                );
                authController.currentUser.refresh();
                Get.back();
                Get.snackbar('success'.tr, 'nameUpdated'.tr);
              } catch (e) {
                Get.snackbar('error'.tr, 'failedToUpdateName'.tr);
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  void _showExportDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('exportData'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('exportPDF'.tr),
              onTap: () {
                Get.back();
                Get.snackbar('Export', 'Export PDF (TBD)');
              },
            ),
            ListTile(
              title: Text('exportCSV'.tr),
              onTap: () {
                Get.back();
                Get.snackbar('Export', 'Export CSV (TBD)');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
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
