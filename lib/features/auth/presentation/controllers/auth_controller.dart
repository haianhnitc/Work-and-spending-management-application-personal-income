import 'package:get/get.dart';
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
      Get.offAllNamed('/main');
    } catch (e) {
      print('SignIn error: $e');
      errorMessage.value = e.toString().split(':').last.trim();
      // Get.snackbar('error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userModel = await authUseCase.signUp(email, password);
      currentUser.value = userModel;
      print('SignUp successful: ${userModel.uid}');
      Get.offAllNamed('/home');
    } catch (e) {
      print('SignUp error: $e');
      errorMessage.value = e.toString().split(':').last.trim();
      // Get.snackbar('error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await authUseCase.signOut();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
