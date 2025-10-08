import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_expense_manager/features/auth/presentation/controllers/auth_controller.dart';
import '../controllers/budget_controller.dart';
import '../../data/models/budget_model.dart';
import '../../../../core/constants/app_enums.dart';

class CreateBudgetScreen extends StatefulWidget {
  @override
  _CreateBudgetScreenState createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final BudgetController _budgetController = Get.find<BudgetController>();
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'general';
  String _selectedPeriod = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  List<String> _selectedTags = [];

  final List<String> _categories = [
    'general',
    'food',
    'transport',
    'shopping',
    'entertainment',
    'utilities',
    'health',
    'education',
    'travel',
    'other',
  ];

  final List<String> _periods = [
    'daily',
    'weekly',
    'monthly',
    'yearly',
    'custom',
  ];

  final List<String> _availableTags = [
    'quan trọng',
    'tiết kiệm',
    'chi tiêu cần thiết',
    'giải trí',
    'công việc',
    'gia đình',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tạo Ngân Sách Mới',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          Obx(() {
            if (_budgetController.isLoading.value) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: _saveBudget,
            );
          }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          children: [
            _buildBasicInfoSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildAmountSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildDateSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildCategorySection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildPeriodSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildTagsSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildSmartBudgetSection(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildActionButtons(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Thông Tin Cơ Bản',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên ngân sách',
                hintText: 'Ví dụ: Ngân sách tháng 12',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên ngân sách';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildAmountSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Số Tiền Ngân Sách',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền (VND)',
                hintText: 'Ví dụ: 5000000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance_wallet),
                suffixText: 'VND',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số tiền';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Số tiền phải lớn hơn 0';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _amountController.text = '1000000',
                    icon: Icon(Icons.touch_app),
                    label: Text('1M'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _amountController.text = '5000000',
                    icon: Icon(Icons.touch_app),
                    label: Text('5M'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _amountController.text = '10000000',
                    icon: Icon(Icons.touch_app),
                    label: Text('10M'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildDateSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Thời Gian',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Ngày bắt đầu'),
                    subtitle: Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                    leading: Icon(Icons.play_arrow),
                    onTap: () => _selectDate(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Ngày kết thúc'),
                    subtitle: Text(
                        '${_endDate.day}/${_endDate.month}/${_endDate.year}'),
                    leading: Icon(Icons.stop),
                    onTap: () => _selectDate(false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Thời gian: ${_endDate.difference(_startDate).inDays} ngày',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildCategorySection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Danh Mục',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Chọn danh mục',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(categoryToString(category)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildPeriodSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Chu Kỳ',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: InputDecoration(
                labelText: 'Chọn chu kỳ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.repeat),
              ),
              items: _periods.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(getPeriodDisplayName(period)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildTagsSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.label,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Nhãn (Tags)',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSmartBudgetSection(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Ngân Sách Thông Minh',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Tạo ngân sách thông minh dựa trên lịch sử chi tiêu của bạn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _createSmartBudget,
              icon: Icon(Icons.auto_awesome),
              label: Text('Tạo Ngân Sách Thông Minh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionButtons(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Hủy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Obx(() {
            return ElevatedButton(
              onPressed: _budgetController.isLoading.value ? null : _saveBudget,
              child: _budgetController.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Lưu Ngân Sách'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            );
          }),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final budget = BudgetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: authController.getCurrentUserId(),
      name: _nameController.text,
      category: _selectedCategory,
      amount: double.parse(_amountController.text),
      startDate: _startDate,
      endDate: _endDate,
      period: _selectedPeriod,
      tags: _selectedTags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _budgetController.createBudget(budget);
    Get.back();
  }

  void _createSmartBudget() async {
    await _budgetController.createSmartBudget(
      _selectedCategory,
      _startDate,
      _endDate,
    );
    Get.back();
  }
}
