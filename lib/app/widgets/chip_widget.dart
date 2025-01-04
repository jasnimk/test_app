import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class ChipWidget extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const ChipWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          category,
          style: AppTextStyles.montserratRegular.copyWith(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 11.5),
        ),
        selectedColor: Color(0xFF15384E),
        backgroundColor: Colors.grey[200],
        elevation: isSelected ? 5 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Color.fromARGB(255, 3, 37, 32)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        onSelected: (_) => onTap(),
        showCheckmark: false,
      ),
    );
  }
}
