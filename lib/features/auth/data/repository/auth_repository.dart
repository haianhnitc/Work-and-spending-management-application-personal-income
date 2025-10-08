import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../core/constants/firebase_config.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User not found after sign-in');
      }
      final userModel = await _getUserData(user.uid);
      if (userModel == null) {
        throw Exception('User data not found in Firestore');
      }
      print('User signed in: ${userModel.uid}');
      return userModel;
    } catch (e) {
      print('SignIn error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User not found after sign-up');
      }
      final userModel = UserModel(
        uid: user.uid,
        email: email,
      );
      await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());
      print('User signed up: ${userModel.uid}');
      return userModel;
    } catch (e) {
      print('SignUp error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signUpWithName(
      String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User not found after sign-up');
      }
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name.trim(),
      );
      await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());
      print('User signed up: ${userModel.uid} - ${userModel.name}');
      return userModel;
    } catch (e) {
      print('SignUp error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Password reset error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      print('Password changed successfully for user: ${user.uid}');
    } catch (e) {
      print('Change password error: $e');
      throw _handleAuthException(e);
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserModel?> _getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          uid: uid,
          email: data['email'] ?? '',
          name: data['name'],
          avatarUrl: data['avatarUrl'] ?? data['avatar'],
        );
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      throw Exception('Failed to get user data: $e');
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('userNotFound'.tr);
        case 'wrong-password':
          return Exception('incorrectPassword'.tr);
        case 'invalid-email':
          return Exception('invalidEmailAddress'.tr);
        case 'user-disabled':
          return Exception('userAccountDisabled'.tr);
        case 'too-many-requests':
          return Exception('tooManyRequests'.tr);
        case 'network-request-failed':
          return Exception('networkError'.tr);
        case 'weak-password':
          return Exception('weakPassword'.tr);
        case 'email-already-in-use':
          return Exception('emailAlreadyInUse'.tr);
        case 'requires-recent-login':
          return Exception('requiresRecentLogin'.tr);
        default:
          return Exception('authenticationError'.tr);
      }
    }
    return Exception(e.toString());
  }
}
