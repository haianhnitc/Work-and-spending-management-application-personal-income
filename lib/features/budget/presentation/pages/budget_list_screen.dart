import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../controllers/budget_controller.dart';
import '../widgets/budget_overview_card.dart';
import '../widgets/budget_list_item.dart';
import '../widgets/budget_error_widget.dart';
import '../widgets/budget_empty_state.dart';
import 'create_budget_screen.dart';

class BudgetListScreen extends StatelessWidget {
  final BudgetController _budgetController = Get.find<BudgetController>();

  BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Quản Lý Ngân Sách',
        type: AppBarType.primary,
        actions: [
          Obx(() => IconButton(
                icon: _budgetController.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.refresh, color: Colors.white),
                onPressed: _budgetController.isLoading.value
                    ? null
                    : () async {
                        print('🔄 User nhấn nút refresh');
                        await _budgetController.loadBudgets();
                        await _budgetController.loadBudgetOverview();
                      },
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _budgetController.loadBudgets(),
        child: Obx(() {
          if (_budgetController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_budgetController.errorMessage.value.isNotEmpty) {
            return BudgetErrorWidget(
              errorMessage: _budgetController.errorMessage.value,
              onRetry: () => _budgetController.loadBudgets(),
            );
          }

          if (_budgetController.budgets.isEmpty) {
            return BudgetEmptyState();
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BudgetOverviewCard(
                  budgetController: _budgetController,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final budget = _budgetController.budgets[index];
                      return BudgetListItem(
                        budget: budget,
                        index: index,
                      );
                    },
                    childCount: _budgetController.budgets.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "budget_fab",
        onPressed: () => Get.to(() => CreateBudgetScreen()),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
