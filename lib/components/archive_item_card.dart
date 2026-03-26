import 'package:flutter/material.dart';

class ArchiveItemCard extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final List<Color> avatarColors;
  final int extraCount;
  final VoidCallback onViewDetails;

  const ArchiveItemCard({
    super.key,
    required this.title,
    required this.date,
    required this.duration,
    required this.avatarColors,
    this.extraCount = 0,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
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
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            ...List.generate(
              avatarColors.length,
              (i) => Transform.translate(
                offset: Offset(i * -8.0, 0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: avatarColors[i],
                  child: const Icon(Icons.person, size: 14, color: Colors.white),
                ),
              ),
            ),
            if (extraCount > 0)
              Transform.translate(
                offset: Offset(avatarColors.length * -8.0, 0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.teal.shade400,
                  child: Text('+$extraCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
          ]),
          ElevatedButton(
            onPressed: onViewDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('View Details', style: TextStyle(fontSize: 13)),
          ),
        ]),
      ]),
    ),
    );
  }
}
