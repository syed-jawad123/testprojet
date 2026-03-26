import 'package:flutter/material.dart';

class ToggleSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSetting({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Icon(icon, size: 20, color: Colors.teal.shade700),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            if (subtitle != null)
              Text(subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ]),
        ),
        Switch(value: value, onChanged: onChanged, activeThumbColor: Colors.teal, activeTrackColor: Colors.teal.shade200),
      ]),
    );
  }
}
