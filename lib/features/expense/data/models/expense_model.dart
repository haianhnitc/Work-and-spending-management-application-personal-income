import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_enums.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  factory ExpenseModel({
    required String id,
    required String userId,
    required String title,
    required double amount,
    required DateTime date,
    required String category,
    String? linkedTaskId,
    required Mood mood,
    required Reason reason,
    @Default(IncomeType.none) IncomeType incomeType,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
