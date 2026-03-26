import 'package:flutter/material.dart';

class DividerWithLabel extends StatelessWidget {
  final String label;

  const DividerWithLabel({
    super.key,
    this.label = 'SECURE REGISTRATION',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: TextStyle(fontSize: 11, letterSpacing: 1.2,
                  color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}
