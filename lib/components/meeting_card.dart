import 'package:flutter/material.dart';
import 'black_button.dart';

class MeetingCard extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final Widget avatar;
  final VoidCallback onStart;
  final VoidCallback? onShare;

  const MeetingCard({
    super.key,
    required this.title,
    required this.date,
    required this.duration,
    required this.avatar,
    required this.onStart,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                const SizedBox(width: 12),
                Icon(Icons.access_time_outlined, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(duration, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ]),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: 48, height: 48, child: avatar),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: BlackButton(label: 'Start Meeting', onPressed: onStart)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onShare,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.share_outlined, size: 20, color: Colors.black54),
            ),
          ),
        ]),
      ]),
    );
  }
}
