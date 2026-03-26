import 'package:flutter/material.dart';
import 'black_button.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final String elapsed;
  final String total;
  final double progress;
  final VoidCallback onResume;

  const SessionCard({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.elapsed,
    required this.total,
    required this.progress,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFFE8F5F0), borderRadius: BorderRadius.circular(6)),
            child: const Text('DRAFT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: Colors.teal, letterSpacing: 0.5)),
          ),
        ]),
        const SizedBox(height: 4),
        Text('$status • $date',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(elapsed, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(total, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
        const SizedBox(height: 14),
        BlackButton(label: '▶  Resume Recording', onPressed: onResume),
      ]),
    );
  }
}
