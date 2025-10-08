import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../task/presentation/controllers/task_controller.dart';
import '../../data/models/expense_model.dart';
import '../controllers/expense_controller.dart';
import '../../../../core/utils/snackbar_helper.dart';

class CreateExpenseScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final RxString _category = RxString('');
  final _dateController = TextEditingController();
  final Rx<Mood> _mood = Rx<Mood>(Mood.neutral);
  final Rx<Reason> _reason = Rx<Reason>(Reason.necessary);
  final Rx<String?> _linkedTaskId = Rx<String?>(null);
  final Rx<IncomeType> _incomeType = Rx<IncomeType>(IncomeType.none);
  final DateTime? initialDate = Get.arguments?['date'];
  final ExpenseModel? expense = Get.arguments?['expense'];
  final IncomeType? initialIncomeType = Get.arguments?['incomeType'];

  CreateExpenseScreen() {
    if (expense != null) {
      _titleController.text = expense!.title;
      _amountController.text = expense!.amount.toString();
      _category.value = expense!.category;
      _dateController.text = DateFormat('dd/MM/yyyy').format(expense!.date);
      _mood.value = expense!.mood;
      _reason.value = expense!.reason;
      _linkedTaskId.value = expense!.linkedTaskId;
      _incomeType.value = expense!.incomeType;
    } else {
      if (initialIncomeType != null) {
        _incomeType.value = initialIncomeType!;
      }
      if (initialDate != null) {
        _dateController.text = DateFormat('dd/MM/yyyy').format(initialDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    final TaskController taskController = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() => Scaffold(
          appBar: CommonAppBar(
            title: expense == null
                ? (_incomeType.value == IncomeType.none
                    ? 'Tạo chi tiêu'
                    : 'Tạo thu nhập')
                : (_incomeType.value == IncomeType.none
                    ? 'Sửa chi tiêu'
                    : 'Sửa thu nhập'),
            type: AppBarType.modal,
          ),
          body: Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Bắt buộc' : null,
                  ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                  SizedBox(height: 16),
                  Obx(() => Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loại giao dịch',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: 12),
                              RadioListTile<IncomeType>(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text('Chi tiêu'),
                                subtitle: Text('Tiền đi ra'),
                                secondary: Icon(Icons.trending_down,
                                    color: Colors.red),
                                value: IncomeType.none,
                                groupValue: _incomeType.value,
                                onChanged: (value) {
                                  _incomeType.value = value ?? IncomeType.none;
                                },
                              ),
                              RadioListTile<IncomeType>(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text('Thu nhập'),
                                subtitle: Text('Tiền đi vào'),
                                secondary: Icon(Icons.trending_up,
                                    color: Colors.green),
                                value: IncomeType.fixed,
                                groupValue: _incomeType.value,
                                onChanged: (value) {
                                  _incomeType.value = value ?? IncomeType.fixed;
                                },
                              ),
                            ],
                          ),
                        ),
                      )).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: _incomeType.value == IncomeType.none
                          ? 'Số tiền chi tiêu'
                          : 'Số tiền thu nhập',
                      prefixIcon: Icon(
                        _incomeType.value == IncomeType.none
                            ? Icons.money_off
                            : Icons.attach_money,
                        color: _incomeType.value == IncomeType.none
                            ? Colors.red
                            : Colors.green,
                      ),
                      helperText: 'Chỉ nhập số dương',
                      prefixText: '₫ ',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Vui lòng nhập số tiền';
                      final amount = double.tryParse(value);
                      if (amount == null) return 'Số tiền không hợp lệ';
                      if (amount <= 0) return 'Số tiền phải lớn hơn 0';
                      if (amount > 999999999) return 'Số tiền quá lớn';

                      return null;
                    },
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Danh mục',
                          prefixIcon: Icon(Icons.category),
                        ),
                        value: _category.value.isEmpty ? null : _category.value,
                        isExpanded: true,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                value: category.name,
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    categoryToString(category),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) => _category.value = value ?? '',
                        validator: (value) => value == null ? 'Bắt buộc' : null,
                      )).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                  SizedBox(height: 16),
                  Obx(() => _incomeType.value != IncomeType.none
                      ? DropdownButtonFormField<IncomeType>(
                          decoration: InputDecoration(
                            labelText: 'Loại thu nhập',
                            prefixIcon:
                                Icon(Icons.trending_up, color: Colors.green),
                          ),
                          value: _incomeType.value,
                          isExpanded: true,
                          items: [IncomeType.fixed, IncomeType.variable]
                              .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      getIncomeTypeText(type),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )))
                              .toList(),
                          onChanged: (value) =>
                              _incomeType.value = value ?? IncomeType.fixed,
                        ).animate().fadeIn(duration: 300.ms)
                      : SizedBox.shrink()),
                  SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<Mood>(
                        decoration: InputDecoration(
                          labelText: 'Tâm trạng',
                          prefixIcon: Icon(Icons.mood),
                        ),
                        value: _mood.value,
                        isExpanded: true,
                        items: Mood.values
                            .map((mood) => DropdownMenuItem(
                                value: mood,
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    getMoodEmoji(mood, true),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) =>
                            _mood.value = value ?? Mood.neutral,
                        validator: (value) => value == null ? 'Bắt buộc' : null,
                      )).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                  SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<Reason>(
                        decoration: InputDecoration(
                          labelText: 'Lý do',
                          prefixIcon: Icon(Icons.info),
                        ),
                        value: _reason.value,
                        isExpanded: true,
                        items: Reason.values
                            .map((reason) => DropdownMenuItem(
                                value: reason,
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    reasonToString(reason),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) =>
                            _reason.value = value ?? Reason.necessary,
                        validator: (value) => value == null ? 'Bắt buộc' : null,
                      )).animate().fadeIn(duration: 300.ms, delay: 600.ms),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            expense?.date ?? initialDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        _dateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      }
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Bắt buộc' : null,
                  ).animate().fadeIn(duration: 300.ms, delay: 700.ms),
                  SizedBox(height: 16),
                  Obx(() {
                    final availableTasks = taskController.tasks
                        .where((task) => !task.isCompleted)
                        .toList();

                    final isCurrentTaskAvailable =
                        _linkedTaskId.value == null ||
                            availableTasks
                                .any((task) => task.id == _linkedTaskId.value);

                    if (!isCurrentTaskAvailable) {
                      _linkedTaskId.value = null;
                    }

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Công việc liên kết',
                        prefixIcon: Icon(Icons.link),
                        helperText: availableTasks.isEmpty
                            ? 'Không có công việc chưa hoàn thành'
                            : null,
                      ),
                      value: _linkedTaskId.value,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('Không liên kết',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                        ...availableTasks
                            .map((task) => DropdownMenuItem(
                                value: task.id,
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    task.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )))
                            .toList(),
                      ],
                      onChanged: (value) => _linkedTaskId.value = value,
                    );
                  }).animate().fadeIn(duration: 300.ms, delay: 800.ms),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final newExpense = ExpenseModel(
                            id: expense?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            userId: Get.find<AuthController>()
                                    .authUseCase
                                    .getCurrentUserId() ??
                                '',
                            title: _titleController.text,
                            amount: double.parse(_amountController.text),
                            date: DateFormat('dd/MM/yyyy')
                                .parse(_dateController.text),
                            category: _category.value,
                            mood: _mood.value,
                            reason: _reason.value,
                            linkedTaskId: _linkedTaskId.value,
                            incomeType: _incomeType.value,
                          );
                          if (expense == null) {
                            await expenseController.addExpense(newExpense);
                          } else {
                            await expenseController.updateExpense(newExpense);
                          }
                          await Future.delayed(Duration(milliseconds: 100));
                          Get.back();
                        } catch (e) {
                          SnackbarHelper.showError('Không thể lưu giao dịch');
                        }
                      }
                    },
                    child: Text(expense == null ? 'Tạo' : 'Lưu',
                        style: TextStyle(fontSize: isTablet ? 18 : 16)),
                  ).animate().scale(duration: 200.ms, delay: 900.ms),
                ],
              ),
            ),
          ),
        ));
  }
}
