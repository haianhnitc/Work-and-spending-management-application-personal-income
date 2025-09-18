import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../task/presentation/controllers/task_controller.dart';
import '../../data/models/expense_model.dart';
import '../controllers/expense_controller.dart';

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
    } else if (initialDate != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(initialDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    final TaskController taskController = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense == null ? 'Tạo giao dịch' : 'Chỉnh sửa giao dịch',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ).animate().scale(duration: 200.ms),
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
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bắt buộc';
                  final amount = double.tryParse(value);
                  if (amount == null) return 'Số không hợp lệ';
                  if (amount == 0) return 'Số tiền không được bằng 0';
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
                    items: Category.values
                        .map((category) => DropdownMenuItem(
                            value: categoryToString(category.name),
                            child: Text(categoryToString(category))))
                        .toList(),
                    onChanged: (value) => _category.value = value ?? '',
                    validator: (value) => value == null ? 'Bắt buộc' : null,
                  )).animate().fadeIn(duration: 300.ms, delay: 300.ms),
              SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<IncomeType>(
                    decoration: InputDecoration(
                      labelText: 'Loại thu nhập',
                      prefixIcon: Icon(Icons.money),
                    ),
                    value: _incomeType.value,
                    items: IncomeType.values
                        .map((type) => DropdownMenuItem(
                            value: type, child: Text(getIncomeTypeText(type))))
                        .toList(),
                    onChanged: (value) =>
                        _incomeType.value = value ?? IncomeType.none,
                  )).animate().fadeIn(duration: 300.ms, delay: 400.ms),
              SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<Mood>(
                    decoration: InputDecoration(
                      labelText: 'Tâm trạng',
                      prefixIcon: Icon(Icons.mood),
                    ),
                    value: _mood.value,
                    items: Mood.values
                        .map((mood) => DropdownMenuItem(
                            value: mood, child: Text(getMoodEmoji(mood, true))))
                        .toList(),
                    onChanged: (value) => _mood.value = value ?? Mood.neutral,
                    validator: (value) => value == null ? 'Bắt buộc' : null,
                  )).animate().fadeIn(duration: 300.ms, delay: 500.ms),
              SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<Reason>(
                    decoration: InputDecoration(
                      labelText: 'Lý do',
                      prefixIcon: Icon(Icons.info),
                    ),
                    value: _reason.value,
                    items: Reason.values
                        .map((reason) => DropdownMenuItem(
                            value: reason, child: Text(reasonToString(reason))))
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
                    initialDate: expense?.date ?? initialDate ?? DateTime.now(),
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
              Obx(() => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Công việc liên kết',
                      prefixIcon: Icon(Icons.link),
                    ),
                    value: _linkedTaskId.value,
                    items: taskController.tasks
                        .where((task) => !task.isCompleted)
                        .map((task) => DropdownMenuItem(
                            value: task.id, child: Text(task.title)))
                        .toList(),
                    onChanged: (value) => _linkedTaskId.value = value,
                  )).animate().fadeIn(duration: 300.ms, delay: 800.ms),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final newExpense = ExpenseModel(
                        id: expense?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
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
                      Get.back();
                    } catch (e) {
                      Get.snackbar('Lỗi', 'Không thể lưu giao dịch');
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
    );
  }
}
