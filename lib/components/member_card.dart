import 'dart:typed_data';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String? initials;
  final Uint8List? imageBytes;
  final VoidCallback? onTap;

  const MemberCard({
    super.key,
    required this.name,
    required this.role,
    this.initials,
    this.imageBytes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                imageBytes != null ? MemoryImage(imageBytes!) : null,
            child: imageBytes == null
                ? Text(
                    initials ?? name[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(role,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ]),
          ),
          Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
        ]),
      ),
    );
  }
}
