import 'package:flutter/material.dart';

class RecordingMemberRow extends StatelessWidget {
  final String name;
  final bool isDone;
  final bool isExisting;
  final VoidCallback onTap;

  const RecordingMemberRow({
    super.key,
    required this.name,
    required this.isDone,
    required this.onTap,
    this.isExisting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.brown.shade300,
          child: const Icon(Icons.person, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        GestureDetector(
          onTap: isExisting ? onTap : (isDone ? null : onTap),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.teal, shape: BoxShape.circle),
            child: Icon(
              isDone
                  ? Icons.check
                  : (isExisting ? Icons.replay : Icons.mic),
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ]),
    );
  }
}
