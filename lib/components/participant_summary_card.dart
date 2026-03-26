import 'package:flutter/material.dart';

class ParticipantSummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Widget bottom;

  const ParticipantSummaryCard({
    super.key,
    required this.count,
    required this.label,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(count,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5)),
            const SizedBox(height: 12),
            bottom,
          ],
        ),
      ),
    );
  }
}
