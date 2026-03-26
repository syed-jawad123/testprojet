import 'package:flutter/material.dart';

class SelectMembersRow extends StatelessWidget {
  final VoidCallback? onTap;

  const SelectMembersRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.group_add_outlined, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Select Members',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
