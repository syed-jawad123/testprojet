import 'dart:async';
import 'package:flutter/material.dart';
import 'meeting_minutes_screen.dart';
import '../main.dart';
import 'app_data.dart';

class TranscriptScreen extends StatefulWidget {
  final String meetingTitle;
  final int pausedSeconds;
  final List<Map<String, dynamic>> members;
  final String duration;
  final String exportFormat;
  final bool includeTimestamps;

  const TranscriptScreen({
    super.key,
    this.meetingTitle = 'Meeting',
    this.pausedSeconds = 0,
    this.members = const [],
    this.duration = '45 minutes',
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  State<TranscriptScreen> createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  int _step = 0; // 0=identifying, 1=matching, 2=generating
  Timer? _timer;
  late AnimationController _spinController;

  final List<String> _steps = [
    'Identifying speakers',
    'Matching voices',
    'Generating transcript',
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate progress
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 0.33 && _step == 0) _step = 1;
        if (_progress >= 0.66 && _step == 1) _step = 2;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer?.cancel();
          _spinController.stop();
          Future.delayed(const Duration(milliseconds: 500), () {
            final now = DateTime.now();
            final date = '${now.day.toString().padLeft(2,'0')}/${now.month.toString().padLeft(2,'0')}/${now.year}';
            // Archive the completed meeting
            archiveMeeting({
              'title': widget.meetingTitle,
              'duration': widget.duration,
            });
            // Remove from upcoming if exists
            upcomingMeetings.removeWhere((m) => m['title'] == widget.meetingTitle);

            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MeetingMinutesScreen(
                  meetingTitle: widget.meetingTitle,
                  date: date,
                  duration: widget.duration,
                  members: widget.members,
                  exportFormat: widget.exportFormat,
                  includeTimestamps: widget.includeTimestamps,
                ),
              ),
              (route) => false,
            );
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spinController.dispose();
    super.dispose();
  }

  Widget _stepRow(String label, int index) {
    final isDone = index < _step;
    final isActive = index == _step;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone
                  ? Colors.teal
                  : isActive
                      ? Colors.black
                      : Colors.grey.shade300,
              width: 2,
            ),
            color: isDone ? Colors.teal : Colors.transparent,
          ),
          child: isDone
              ? const Icon(Icons.check, size: 13, color: Colors.white)
              : isActive
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    )
                  : null,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isDone || isActive ? Colors.black : Colors.grey.shade400,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Spinner
              Center(
                child: RotationTransition(
                  turns: _spinController,
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                    child: CustomPaint(painter: _DashedCirclePainter()),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text('Generating your transcript',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Please stay on this screen while we process your audio',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 28),

              // Progress
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Overall progress',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${(_progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
              const SizedBox(height: 28),

              // Steps
              ..._steps.asMap().entries.map((e) => _stepRow(e.value, e.key)),
              const SizedBox(height: 28),

              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: Icon(Icons.info_outline, size: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI models are busy analyzing audio frequencies and patterns to distinguish between different speakers. This usually takes less than a minute.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const dashCount = 12;
    const dashAngle = 3.14159 * 2 / dashCount;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          i * dashAngle,
          dashAngle * 0.6,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
