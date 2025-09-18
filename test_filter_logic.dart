// Test comprehensive logic cho pie chart filtering
class MockTask {
  final String id;
  final String title;  
  final String category;
  final bool isCompleted;
  final DateTime dueDate;

  MockTask({
    required this.id,
    required this.title,
    required this.category, 
    required this.isCompleted,
    required this.dueDate,
  });
}

class MockExpense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String type; // 'income' hoặc 'expense'
  final DateTime date;

  MockExpense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });
}

void testStrictFilterLogic() {
  print('=== TESTING STRICT FILTER LOGIC FOR PIE CHARTS ===\n');
  
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));
  final lastWeek = today.subtract(Duration(days: 7));
  
  // Mock data với different dates
  final tasks = [
    MockTask(id: '1', title: 'Work Task 1', category: 'work', isCompleted: true, dueDate: today),
    MockTask(id: '2', title: 'Personal Task', category: 'personal', isCompleted: false, dueDate: today),
    MockTask(id: '3', title: 'Work Task 2', category: 'work', isCompleted: true, dueDate: yesterday),
    MockTask(id: '4', title: 'Health Task', category: 'health', isCompleted: false, dueDate: today),
    MockTask(id: '5', title: 'Old Work Task', category: 'work', isCompleted: false, dueDate: lastWeek),
  ];

  final expenses = [
    MockExpense(id: '1', title: 'Food today', category: 'food', amount: -100000, type: 'expense', date: today),
    MockExpense(id: '2', title: 'Transport today', category: 'transport', amount: -50000, type: 'expense', date: today),
    MockExpense(id: '3', title: 'Food yesterday', category: 'food', amount: -80000, type: 'expense', date: yesterday),
    MockExpense(id: '4', title: 'Old food', category: 'food', amount: -120000, type: 'expense', date: lastWeek),
    MockExpense(id: '5', title: 'Salary', category: 'salary', amount: 2000000, type: 'income', date: today),
  ];

  testTaskLogic(tasks, today, yesterday, lastWeek);
  testExpenseLogic(expenses, today, yesterday, lastWeek);
}

void testTaskLogic(List<MockTask> tasks, DateTime today, DateTime yesterday, DateTime lastWeek) {
  print('🔹 TASK LOGIC TESTING');
  
  // Test Case 1: Không có filter gì cả
  print('\n1️⃣ NO FILTERS:');
  var categoryTotals = computeTaskCategoryTotals(tasks, '', '');
  print('   Result: $categoryTotals');
  print('   Expected: All categories with their counts');
  
  // Test Case 2: Có selectedCategory = 'work', không có search
  print('\n2️⃣ FILTER CATEGORY = "work":');
  categoryTotals = computeTaskCategoryTotals(tasks, 'work', '');
  print('   Result: $categoryTotals');
  print('   Expected: {work: 3} (all work tasks)');
  
  // Test Case 3: Có selectedCategory = 'work' + search = "Task 1"
  print('\n3️⃣ FILTER CATEGORY = "work" + SEARCH = "Task 1":');
  categoryTotals = computeTaskCategoryTotals(tasks, 'work', 'Task 1');
  print('   Result: $categoryTotals');
  print('   Expected: {work: 1} (chỉ Work Task 1)');
  
  // Test Case 4: Không có selectedCategory, có search = "Task"
  print('\n4️⃣ NO CATEGORY FILTER + SEARCH = "Task":');
  categoryTotals = computeTaskCategoryTotals(tasks, '', 'Task');
  print('   Result: $categoryTotals');
  print('   Expected: Multiple categories với tasks có chứa "Task"');
  
  // Test Case 5: selectedCategory không tồn tại
  print('\n5️⃣ FILTER CATEGORY = "nonexistent":');
  categoryTotals = computeTaskCategoryTotals(tasks, 'nonexistent', '');
  print('   Result: $categoryTotals');
  print('   Expected: {} (empty)');
}

void testExpenseLogic(List<MockExpense> expenses, DateTime today, DateTime yesterday, DateTime lastWeek) {
  print('\n\n🔹 EXPENSE LOGIC TESTING');
  
  // Test Case 1: Không có filter gì cả
  print('\n1️⃣ NO FILTERS:');
  var categoryTotals = computeExpenseCategoryTotals(expenses, '', (date) => true);
  print('   Result: $categoryTotals');
  print('   Expected: All expense categories với total amounts');
  
  // Test Case 2: Có selectedCategory = 'food', no time filter
  print('\n2️⃣ FILTER CATEGORY = "food":');
  categoryTotals = computeExpenseCategoryTotals(expenses, 'food', (date) => true);
  print('   Result: $categoryTotals');
  print('   Expected: {food: 300000.0} (tổng tất cả food expenses)');
  
  // Test Case 3: Có selectedCategory = 'food' + time filter = today only
  print('\n3️⃣ FILTER CATEGORY = "food" + TIME = today only:');
  categoryTotals = computeExpenseCategoryTotals(expenses, 'food', (date) => 
    date.day == today.day && date.month == today.month && date.year == today.year);
  print('   Result: $categoryTotals');
  print('   Expected: {food: 100000.0} (chỉ food hôm nay)');
  
  // Test Case 4: Không có selectedCategory, có time filter = today only
  print('\n4️⃣ NO CATEGORY FILTER + TIME = today only:');
  categoryTotals = computeExpenseCategoryTotals(expenses, '', (date) => 
    date.day == today.day && date.month == today.month && date.year == today.year);
  print('   Result: $categoryTotals');
  print('   Expected: Multiple categories với expenses hôm nay');
}

// Mock implementation của TaskController.categoryTotals logic mới
Map<String, int> computeTaskCategoryTotals(List<MockTask> tasks, String selectedCategory, String searchQuery) {
  final categoryTotals = <String, int>{};
  final categories = ['work', 'personal', 'health', 'study', 'lifestyle']; // Mock Category.values
  
  if (selectedCategory.isNotEmpty) {
    // Có filter category: chỉ hiển thị category đó với data đã filter theo search
    final categoryTasks = tasks.where((task) {
      final matchesCategory = task.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          task.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    });
    
    if (categoryTasks.isNotEmpty) {
      categoryTotals[selectedCategory] = categoryTasks.length;
    }
  } else {
    // Không có filter category: hiển thị tất cả categories với data đã filter theo search
    for (var category in categories) {
      final categoryTasks = tasks.where((task) {
        final matchesCategory = task.category == category;
        final matchesSearch = searchQuery.isEmpty ||
            task.title.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      });
      
      if (categoryTasks.isNotEmpty) {
        categoryTotals[category] = categoryTasks.length;
      }
    }
  }
  
  return categoryTotals;
}

// Mock implementation của ExpenseController.categoryTotals logic mới
Map<String, double> computeExpenseCategoryTotals(List<MockExpense> expenses, String selectedCategory, bool Function(DateTime) filterByTime) {
  final categoryTotals = <String, double>{};
  final categories = ['food', 'transport', 'entertainment', 'health', 'shopping']; // Mock Category.values
  
  if (selectedCategory.isNotEmpty) {
    // Có filter category: chỉ hiển thị category đó với data đã filter theo time
    final categoryExpenses = expenses.where((expense) {
      final matchesCategory = expense.category == selectedCategory;
      final matchesTime = filterByTime(expense.date);
      final isExpense = expense.amount < 0;
      return matchesCategory && matchesTime && isExpense;
    });
    
    if (categoryExpenses.isNotEmpty) {
      categoryTotals[selectedCategory] = categoryExpenses
          .fold(0.0, (sum, e) => sum + e.amount.abs());
    }
  } else {
    // Không có filter category: hiển thị tất cả categories với data đã filter theo time
    for (var category in categories) {
      final categoryExpenses = expenses.where((expense) {
        final matchesCategory = expense.category == category;
        final matchesTime = filterByTime(expense.date);
        final isExpense = expense.amount < 0;
        return matchesCategory && matchesTime && isExpense;
      });
      
      if (categoryExpenses.isNotEmpty) {
        categoryTotals[category] = categoryExpenses
            .fold(0.0, (sum, e) => sum + e.amount.abs());
      }
    }
  }
  
  return categoryTotals;
}

void main() {
  testStrictFilterLogic();
  print('\n✅ All test cases completed!');
}