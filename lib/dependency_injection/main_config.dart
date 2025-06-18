import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:task_expense_manager/dependency_injection/main_config.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
}
