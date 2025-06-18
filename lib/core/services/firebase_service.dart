// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../features/task/data/models/task_model.dart';
// import '../constants/firebase_config.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<TaskModel>> getTasks(String userId) {
//     final result = _firestore
//         .collection(FirebaseConfig.usersCollection)
//         .doc(userId)
//         .collection(FirebaseConfig.tasksCollection)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => TaskModel.fromJson(doc.data()))
//             .toList());

//     return result;
//   }

//   Future<void> addTask(String userId, TaskModel task) async {
//     try {
//       await _firestore
//           .collection(FirebaseConfig.usersCollection)
//           .doc(userId)
//           .collection(FirebaseConfig.tasksCollection)
//           .doc(task.id)
//           .set(task.toJson());
//     } catch (e) {
//       print('Error adding task: $e');
//     }
//   }
// }
