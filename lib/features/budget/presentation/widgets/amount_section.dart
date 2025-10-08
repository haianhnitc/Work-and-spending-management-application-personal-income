import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AmountSection extends StatelessWidget {
  final TextEditingController amountController;
  final String? Function(String?)? validator;

  const AmountSection({
    super.key,
    required this.amountController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, isTablet),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildQuickAmountButtons(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSectionHeader(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.attach_money,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Số tiền ngân sách',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Số tiền (VND)',
        hintText: 'Ví dụ: 5,000,000',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
        suffixText: 'VND',
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final number = value.replaceAll(',', '');
          if (number.isNotEmpty && RegExp(r'^\d+$').hasMatch(number)) {
            final formatted = _formatNumber(number);
            if (formatted != value) {
              amountController.value = amountController.value.copyWith(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildQuickAmountButtons(BuildContext context) {
    final amounts = [
      {'label': '1M', 'value': '1,000,000'},
      {'label': '5M', 'value': '5,000,000'},
      {'label': '10M', 'value': '10,000,000'},
      {'label': '20M', 'value': '20,000,000'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Số tiền phổ biến',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) {
            return ElevatedButton(
              onPressed: () => amountController.text = amount['value']!,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                elevation: 1,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Text(
                amount['label']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatNumber(String number) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.replaceAllMapped(regex, (Match match) => '${match[1]},');
  }
}
