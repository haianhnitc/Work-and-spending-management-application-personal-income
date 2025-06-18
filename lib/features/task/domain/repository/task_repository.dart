import 'package:dartz/dartz.dart';
import '../../../../core/constants/failure.dart';
import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Stream<Either<Failure, List<TaskModel>>> getTasks(String userId);
  Future<Either<Failure, void>> addTask(String userId, TaskModel task);
  Future<Either<Failure, void>> updateTask(String userId, TaskModel task);
  Future<Either<Failure, void>> deleteTask(String userId, String taskId);
}
