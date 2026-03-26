import 'package:flutter/material.dart';
import '../components/black_button.dart';
import 'voice_recording_screen.dart';

class IntroductionScreen extends StatelessWidget {
  final String meetingTitle;
  final List<Map<String, dynamic>> members;
  final String exportFormat;
  final bool includeTimestamps;

  const IntroductionScreen({
    super.key,
    this.meetingTitle = 'Meeting',
    this.members = const [],
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200, shape: BoxShape.circle),
                child: Icon(Icons.auto_fix_high_outlined,
                    size: 28, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              const Text('Introduction Round',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Text(
                "Let's get started. In this round, you'll provide a brief overview to help us personalize your experience. It only takes a minute.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade600, height: 1.6),
              ),
              const SizedBox(height: 40),
              BlackButton(
                label: 'Start Introduction',
                trailingIcon: Icons.arrow_forward,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoiceRecordingScreen(
                      meetingTitle: meetingTitle,
                      members: members,
                      exportFormat: exportFormat,
                      includeTimestamps: includeTimestamps,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
