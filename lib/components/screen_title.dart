import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const ScreenTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black)),
        const SizedBox(height: 6),
        Text(subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }
}
