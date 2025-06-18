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
      throw Exception('${'loginFailed'.tr}: $e');
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
      throw Exception('${'registerFailed'.tr}: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      throw Exception('Failed to get user data: $e');
    }
  }
}
