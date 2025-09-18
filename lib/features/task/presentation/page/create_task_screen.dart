import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_enums.dart';
import '../../data/models/task_model.dart';
import '../controllers/task_controller.dart';

class CreateTaskScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final RxString _category = RxString('');
  final _dueDateController = TextEditingController();
  final DateTime? initialDate = Get.arguments?['date'];
  final TaskModel? task = Get.arguments?['task'];

  CreateTaskScreen() {
    if (task != null) {
      _titleController.text = task!.title;
      _descriptionController.text = task!.description;
      _estimatedCostController.text = task!.estimatedCost?.toString() ?? '';
      _category.value = task!.category;
      _dueDateController.text = DateFormat('dd/MM/yyyy').format(task!.dueDate);
    } else if (initialDate != null) {
      _dueDateController.text = DateFormat('dd/MM/yyyy').format(initialDate!);
    } else {
      // Mặc định ngày hạn là ngày hôm nay nếu không có initialDate hoặc task
      _dueDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
    // Đảm bảo category có giá trị mặc định nếu là tạo mới
    if (_category.value.isEmpty && Category.values.isNotEmpty) {
      _category.value = Category.values.first.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Tạo công việc mới' : 'Chỉnh sửa công việc',
            style: Theme.of(context)
                .appBarTheme
                .titleTextStyle
                ?.copyWith(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                context,
                controller: _titleController,
                label: 'Tiêu đề công việc',
                hint: 'Ví dụ: Hoàn thành báo cáo',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
                isTablet: isTablet,
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              SizedBox(height: isTablet ? 20 : 16),
              _buildTextField(
                context,
                controller: _descriptionController,
                label: 'Mô tả (Tùy chọn)',
                hint: 'Chi tiết công việc cần làm...',
                icon: Icons.description,
                maxLines: 3,
                isTablet: isTablet,
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
              SizedBox(height: isTablet ? 20 : 16),
              _buildCategoryDropdown(context, isTablet)
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 300.ms),
              SizedBox(height: isTablet ? 20 : 16),
              _buildDatePicker(context, isTablet)
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 400.ms),
              SizedBox(height: isTablet ? 20 : 16),
              _buildTextField(
                context,
                controller: _estimatedCostController,
                label: 'Chi phí dự kiến (Tùy chọn)',
                hint: 'Ví dụ: 500000',
                icon: Icons.monetization_on,
                keyboardType: TextInputType.number,
                isTablet: isTablet,
              ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
              SizedBox(height: isTablet ? 30 : 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 30,
                        vertical: isTablet ? 18 : 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newTask = TaskModel(
                        id: task?.id ?? UniqueKey().toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: DateFormat('dd/MM/yyyy')
                            .parse(_dueDateController.text),
                        estimatedCost: double.tryParse(_estimatedCostController
                            .text
                            .replaceAll('.', '')
                            .replaceAll(',', '')), // Xử lý dấu phân cách
                        category: _category.value,
                        isCompleted: task?.isCompleted ?? false,
                        createdAt: task?.createdAt ?? DateTime.now(),
                      );
                      if (task == null) {
                        await controller.addTask(newTask);
                        Get.snackbar(
                          'Thành công',
                          'Đã tạo công việc "${newTask.title}"',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        await controller.updateTask(newTask);
                        Get.snackbar(
                          'Thành công',
                          'Đã cập nhật công việc "${newTask.title}"',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                      Get.back();
                    } else {
                      Get.snackbar(
                          'Lỗi', 'Vui lòng điền đầy đủ các trường bắt buộc',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                    }
                  },
                  child: Text(task == null ? 'Tạo công việc' : 'Lưu công việc',
                      style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold)),
                ).animate().scale(duration: 200.ms, delay: 600.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon,
                    color: Theme.of(context).primaryColor.withOpacity(0.7))
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: isTablet ? 18 : 14, horizontal: isTablet ? 16 : 12),
          ),
          style: TextStyle(fontSize: isTablet ? 18 : 16),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        Obx(() => DropdownButtonFormField<String>(
              value: _category.value.isEmpty ? null : _category.value,
              hint: const Text('Chọn danh mục'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: isTablet ? 18 : 14,
                    horizontal: isTablet ? 16 : 12),
                prefixIcon: Icon(Icons.category,
                    color: Theme.of(context).primaryColor.withOpacity(0.7)),
              ),
              items: Category.values
                  .map((category) => DropdownMenuItem(
                        value: categoryToString(category.name),
                        child: Text(categoryToString(category.name),
                            style: TextStyle(fontSize: isTablet ? 18 : 16)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _category.value = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn danh mục';
                }
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày hạn chót',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        TextFormField(
          controller: _dueDateController,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: task?.dueDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      onSurface: Colors.black87,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              _dueDateController.text =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
            }
          },
          decoration: InputDecoration(
            hintText: 'Chọn ngày hạn chót',
            prefixIcon: Icon(Icons.calendar_today,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: isTablet ? 18 : 14, horizontal: isTablet ? 16 : 12),
          ),
          style: TextStyle(fontSize: isTablet ? 18 : 16),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn ngày hạn chót';
            }
            try {
              DateFormat('dd/MM/yyyy').parse(value);
              return null;
            } catch (e) {
              return 'Ngày không hợp lệ (dd/MM/yyyy)';
            }
          },
        ),
      ],
    );
  }
}
