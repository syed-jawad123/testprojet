import 'package:flutter/material.dart';

class MemberListItem extends StatelessWidget {
  final String name;
  final String email;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onDelete;

  const MemberListItem({
    super.key,
    required this.name,
    required this.email,
    required this.isSelected,
    required this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isSelected,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: Colors.black,
            side: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
            const SizedBox(height: 2),
            Text(email,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ]),
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade400),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ]),
    );
  }
}
