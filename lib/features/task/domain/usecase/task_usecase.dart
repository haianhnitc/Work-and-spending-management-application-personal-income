import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/failure.dart';
import '../../data/models/task_model.dart';
import '../repository/task_repository.dart';

@injectable
class TaskUseCase {
  final TaskRepository _repository;

  TaskUseCase(this._repository);

  Stream<Either<Failure, List<TaskModel>>> getTasks(String userId) {
    return _repository.getTasks(userId);
  }

  Future<Either<Failure, void>> addTask(String userId, TaskModel task) {
    return _repository.addTask(userId, task);
  }

  Future<Either<Failure, void>> updateTask(String userId, TaskModel task) {
    return _repository.updateTask(userId, task);
  }

  Future<Either<Failure, void>> deleteTask(String userId, String taskId) {
    return _repository.deleteTask(userId, taskId);
  }
}
