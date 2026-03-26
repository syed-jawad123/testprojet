import 'package:flutter/material.dart';
import 'waveform_widget.dart';

class RecordingCard extends StatelessWidget {
  final VoidCallback onStop;

  const RecordingCard({super.key, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: [
        // Recording status
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text('RECORDING...',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                  letterSpacing: 1)),
        ]),
        const SizedBox(height: 16),

        // Read this aloud label
        Text('READ THIS ALOUD',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 1.1)),
        const SizedBox(height: 12),

        // Quote text
        const Text(
          '"The quick brown fox jumps over the lazy dog."',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5),
        ),
        const SizedBox(height: 24),

        // Waveform
        const WaveformWidget(),
        const SizedBox(height: 24),

        // Stop button
        GestureDetector(
          onTap: onStop,
          child: Column(children: [
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(
                  color: Colors.black, shape: BoxShape.circle),
              child: const Icon(Icons.stop_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(height: 8),
            Text('Stop Recording',
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade600)),
          ]),
        ),
      ]),
    );
  }
}
