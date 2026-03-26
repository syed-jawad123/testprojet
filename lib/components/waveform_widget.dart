import 'package:flutter/material.dart';

class WaveformWidget extends StatelessWidget {
  const WaveformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = [10.0, 18.0, 28.0, 22.0, 35.0, 40.0, 30.0, 45.0,
                     38.0, 50.0, 42.0, 35.0, 28.0, 38.0, 20.0, 12.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: heights.map((h) => Container(
        width: 4,
        height: h,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4),
        ),
      )).toList(),
    );
  }
}
