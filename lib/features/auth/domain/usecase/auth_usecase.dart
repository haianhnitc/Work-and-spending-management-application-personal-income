import 'package:task_expense_manager/features/auth/data/models/user_model.dart';

import '../../data/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<UserModel> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }

  Future<UserModel> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Future<void> sendPasswordResetEmail(String email) async {
  //   await _authRepository.sendPasswordResetEmail(email);
  // }

  String? getCurrentUserId() {
    return _authRepository.getCurrentUser()?.uid;
  }
}
