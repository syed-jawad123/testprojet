import 'dart:async';
import 'package:flutter/material.dart';
import '../components/waveform_widget.dart';

class VoiceSetupScreen extends StatefulWidget {
  final String memberName;

  const VoiceSetupScreen({
    super.key,
    this.memberName = '',
  });

  @override
  State<VoiceSetupScreen> createState() => _VoiceSetupScreenState();
}

class _VoiceSetupScreenState extends State<VoiceSetupScreen> {
  bool _isRecording = false;
  bool _isDone = false;
  int _seconds = 0;
  Timer? _timer;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isDone = false;
      _seconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
      if (_seconds >= 10) _stopRecording();
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _isDone = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      size: 22, color: Colors.black87),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Voice Setup',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 22),
              ]),
              const SizedBox(height: 24),

              // Subtitle
              Text(
                'Please read the sentence below to re-setup your voice profile.',
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),

              const Spacer(),

              // READ ALOUD
              Center(
                child: Text('READ ALOUD',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.2)),
              ),
              const SizedBox(height: 16),

              // Quote
              const Center(
                child: Text(
                  '"The quick brown fox jumps over the lazy dog."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700, height: 1.4),
                ),
              ),
              const SizedBox(height: 32),

              // Waveform
              Center(
                child: _isRecording
                    ? const WaveformWidget()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(8, (i) => Container(
                          width: 3,
                          height: 12 + (i % 3) * 4.0,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )),
                      ),
              ),

              if (_isRecording) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(_formattedTime,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade600)),
                ),
              ],

              if (_isDone) ...[
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.teal, size: 18),
                      const SizedBox(width: 6),
                      Text('Voice profile saved!',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.teal.shade600,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      _isRecording ? _stopRecording : _startRecording,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic, size: 18),
                  label: Text(
                    _isRecording ? 'Stop Recording' : 'Start Recording',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isRecording ? Colors.red.shade600 : Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: Text(
                  _isDone ? 'Voice profile updated!' : 'Tap to begin calibration',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
