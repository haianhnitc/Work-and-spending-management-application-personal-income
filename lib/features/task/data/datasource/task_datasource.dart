import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_config.dart';
import '../models/task_model.dart';
import 'package:injectable/injectable.dart';

abstract class TaskDataSource {
  Stream<List<TaskModel>> getTasks(String userId);
  Future<void> addTask(String userId, TaskModel task);
  Future<void> updateTask(String userId, TaskModel task);
  Future<void> deleteTask(String userId, String taskId);
}

@Injectable(as: TaskDataSource)
class TaskDatasourceImpl implements TaskDataSource {
  final FirebaseFirestore _firestore;

  TaskDatasourceImpl(this._firestore);

  @override
  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.tasksCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> addTask(String userId, TaskModel task) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.tasksCollection)
        .doc(task.id)
        .set(task.toJson());
  }

  @override
  Future<void> updateTask(String userId, TaskModel task) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.tasksCollection)
        .doc(task.id)
        .update(task.toJson());
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.tasksCollection)
        .doc(taskId)
        .delete();
  }
}
