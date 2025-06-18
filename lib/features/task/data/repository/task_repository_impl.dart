import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/failure.dart';
import '../../domain/repository/task_repository.dart';
import '../datasource/task_datasource.dart';
import '../models/task_model.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<TaskModel>>> getTasks(String userId) async* {
    try {
      final stream = _dataSource.getTasks(userId);
      await for (final tasks in stream) {
        yield Right(tasks);
      }
    } catch (e) {
      yield Left(Failure('Không thể lấy danh sách công việc: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(String userId, TaskModel task) async {
    try {
      await _dataSource.addTask(userId, task);
      return Right(null);
    } catch (e) {
      return Left(Failure('Không thể thêm công việc: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(
      String userId, TaskModel task) async {
    try {
      await _dataSource.updateTask(userId, task);
      return Right(null);
    } catch (e) {
      return Left(Failure('Failed to update task: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) async {
    try {
      await _dataSource.deleteTask(userId, taskId);
      return Right(null);
    } catch (e) {
      return Left(Failure('Failed to delete task: $e'));
    }
  }
}
