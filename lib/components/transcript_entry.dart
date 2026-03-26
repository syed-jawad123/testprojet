import 'package:flutter/material.dart';

class TranscriptEntry extends StatelessWidget {
  final String timestamp;
  final String speaker;
  final String text;

  const TranscriptEntry({
    super.key,
    required this.timestamp,
    required this.speaker,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(timestamp,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ),
          const SizedBox(width: 8),
          Text(speaker,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: Colors.teal)),
        ]),
        const SizedBox(height: 6),
        Text(text,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
      ]),
    );
  }
}
