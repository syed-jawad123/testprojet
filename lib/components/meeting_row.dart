import 'package:flutter/material.dart';

class MeetingRow extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const MeetingRow({
    super.key,
    required this.title,
    required this.date,
    required this.duration,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F0), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.insert_drive_file_outlined, size: 20, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_outlined, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(duration, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ]),
          ),
          IconButton(
            onPressed: onMoreTap,
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ]),
      ),
    );
  }
}
