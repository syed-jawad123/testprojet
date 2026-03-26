import 'dart:async';
import 'package:flutter/material.dart';
import '../components/waveform_widget.dart';
import '../main.dart';
import 'main_screen.dart';
import 'transcript_screen.dart';

class MeetingInProgressScreen extends StatefulWidget {
  final int initialSeconds;
  final String meetingTitle;
  final List<Map<String, dynamic>> members;
  final String exportFormat;
  final bool includeTimestamps;

  const MeetingInProgressScreen({
    super.key,
    this.initialSeconds = 0,
    this.meetingTitle = 'Meeting',
    this.members = const [],
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  State<MeetingInProgressScreen> createState() => _MeetingInProgressScreenState();
}

class _MeetingInProgressScreenState extends State<MeetingInProgressScreen> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _pauseRecording() {
    _timer?.cancel();
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MainScreen(
          initialIndex: 0,
          pausedSeconds: _seconds,
          meetingTitle: widget.meetingTitle,
        ),
      ),
      (route) => false,
    );
  }

  void _stopRecording() {
    _timer?.cancel();
    final minutes = _seconds ~/ 60;
    final secs = _seconds % 60;
    final duration = minutes > 0
        ? '$minutes min${secs > 0 ? ' $secs sec' : ''}'
        : '$secs seconds';
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => TranscriptScreen(
          meetingTitle: widget.meetingTitle,
          pausedSeconds: _seconds,
          members: widget.members,
          duration: duration,
          exportFormat: widget.exportFormat,
          includeTimestamps: widget.includeTimestamps,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text('MEETING IN PROGRESS',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: Colors.red, letterSpacing: 1.1)),
                ]),
                const SizedBox(height: 32),
                Text(_formattedTime,
                    style: const TextStyle(fontSize: 72,
                        fontWeight: FontWeight.w300, color: Colors.black,
                        letterSpacing: -2)),
                const SizedBox(height: 48),
                const WaveformWidget(),
                const SizedBox(height: 64),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pauseRecording,
                    icon: const Icon(Icons.pause, size: 18),
                    label: const Text('Pause Recording',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _stopRecording,
                    icon: const Icon(Icons.stop, size: 18),
                    label: const Text('Stop Recording',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
