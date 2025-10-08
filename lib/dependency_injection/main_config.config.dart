// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:task_expense_manager/dependency_injection/main_config.dart'
    as _i168;
import 'package:task_expense_manager/features/budget/data/datasources/budget_remote_data_source.dart'
    as _i626;
import 'package:task_expense_manager/features/budget/data/repository/budget_repository_impl.dart'
    as _i813;
import 'package:task_expense_manager/features/budget/domain/repository/budget_repository.dart'
    as _i127;
import 'package:task_expense_manager/features/budget/domain/usecase/budget_usecase.dart'
    as _i921;
import 'package:task_expense_manager/features/budget/presentation/controllers/budget_controller.dart'
    as _i960;
import 'package:task_expense_manager/features/expense/data/datasource/expense_datasource.dart'
    as _i302;
import 'package:task_expense_manager/features/expense/data/repository/expense_repository_impl.dart'
    as _i272;
import 'package:task_expense_manager/features/expense/domain/repository/expense_repository.dart'
    as _i40;
import 'package:task_expense_manager/features/expense/domain/usecase/expense_usecase.dart'
    as _i469;
import 'package:task_expense_manager/features/expense/presentation/controllers/expense_controller.dart'
    as _i433;
import 'package:task_expense_manager/features/task/data/datasource/task_datasource.dart'
    as _i1041;
import 'package:task_expense_manager/features/task/data/repository/task_repository_impl.dart'
    as _i1051;
import 'package:task_expense_manager/features/task/domain/repository/task_repository.dart'
    as _i334;
import 'package:task_expense_manager/features/task/domain/usecase/task_usecase.dart'
    as _i539;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.factory<_i302.ExpenseDatasource>(() => _i302.ExpenseDatasourceImpl());
    gh.factory<_i626.BudgetRemoteDataSource>(
        () => _i626.BudgetRemoteDataSourceImpl());
    gh.factory<_i1041.TaskDataSource>(
        () => _i1041.TaskDatasourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i127.BudgetRepository>(
        () => _i813.BudgetRepositoryImpl(gh<_i626.BudgetRemoteDataSource>()));
    gh.factory<_i40.ExpenseRepository>(
        () => _i272.ExpenseRepositoryImpl(gh<_i302.ExpenseDatasource>()));
    gh.factory<_i921.BudgetUseCase>(
        () => _i921.BudgetUseCase(gh<_i127.BudgetRepository>()));
    gh.factory<_i334.TaskRepository>(
        () => _i1051.TaskRepositoryImpl(gh<_i1041.TaskDataSource>()));
    gh.factory<_i469.ExpenseUseCase>(
        () => _i469.ExpenseUseCase(gh<_i40.ExpenseRepository>()));
    gh.factory<_i960.BudgetController>(
        () => _i960.BudgetController(gh<_i921.BudgetUseCase>()));
    gh.factory<_i433.ExpenseController>(
        () => _i433.ExpenseController(gh<_i469.ExpenseUseCase>()));
    gh.factory<_i539.TaskUseCase>(
        () => _i539.TaskUseCase(gh<_i334.TaskRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i168.RegisterModule {}
