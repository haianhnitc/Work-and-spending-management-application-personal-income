import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final String? Function(String?)? validator;

  const BasicInfoSection({
    super.key,
    required this.nameController,
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
            SizedBox(height: 16),
            _buildNameField(),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSectionHeader(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.info_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Thông Tin Cơ Bản',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Tên ngân sách',
        hintText: 'Ví dụ: Ngân sách tháng 12',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(Icons.edit_outlined),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 50,
      buildCounter: (context,
          {required currentLength, required isFocused, maxLength}) {
        return Text(
          '$currentLength/$maxLength',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        );
      },
    );
  }
}
