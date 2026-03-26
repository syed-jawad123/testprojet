import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String title;

  const SectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600,
            color: Colors.grey, letterSpacing: 1.1));
  }
}
