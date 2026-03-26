import 'dart:async';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../components/waveform_widget.dart';
import 'app_data.dart';
import 'voice_setup_screen.dart';

class MemberProfileScreen extends StatefulWidget {
  final int memberIndex;
  final String name;
  final String role;
  final String email;
  final String memberSince;
  final String? initials;
  final int recordingSeconds;
  final VoidCallback? onDelete;

  const MemberProfileScreen({
    super.key,
    required this.memberIndex,
    required this.name,
    required this.role,
    this.email = '',
    this.memberSince = '',
    this.initials,
    this.recordingSeconds = 45,
    this.onDelete,
  });

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  Timer? _playTimer;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    // Load saved image from global list
    if (widget.memberIndex >= 0 &&
        widget.memberIndex < existingMembers.length) {
      _imageBytes = existingMembers[widget.memberIndex]['imageBytes'];
    }
  }

  @override
  void dispose() {
    _playTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_isPlaying) {
      _playTimer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      if (_currentSeconds >= widget.recordingSeconds) _currentSeconds = 0;
      setState(() => _isPlaying = true);
      _playTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _currentSeconds++;
          if (_currentSeconds >= widget.recordingSeconds) {
            _currentSeconds = widget.recordingSeconds;
            _isPlaying = false;
            _playTimer?.cancel();
          }
        });
      });
    }
  }

  Future<void> _pickImage() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file == null) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((_) {
        final bytes = reader.result as Uint8List;
        setState(() => _imageBytes = bytes);
        // Save to global list so it persists
        if (widget.memberIndex >= 0 &&
            widget.memberIndex < existingMembers.length) {
          existingMembers[widget.memberIndex]['imageBytes'] = bytes;
        }
      });
    });
  }

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.recordingSeconds > 0
        ? _currentSeconds / widget.recordingSeconds
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    child: Text('Member Profile',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 22),
              ]),
              const SizedBox(height: 24),

              // Avatar
              Center(
                child: Stack(children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.brown.shade200,
                      backgroundImage: _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : null,
                      child: _imageBytes == null
                          ? Text(
                              widget.initials ??
                                  widget.name[0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_outlined,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 14),

              // Name + Role
              Center(
                child: Column(children: [
                  Text(widget.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(widget.role,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                ]),
              ),
              const SizedBox(height: 24),

              // Voice Profile header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('VOICE PROFILE',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1.1)),
                  Row(children: [
                    const Icon(Icons.edit_outlined,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoiceSetupScreen(
                            memberName: widget.name,
                          ),
                        ),
                      ),
                      child: Text('Edit',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500)),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 10),

              // Audio Player
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  Row(children: [
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white, size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(children: [
                        const WaveformWidget(),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(_currentSeconds),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                      Text(_formatTime(widget.recordingSeconds),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // Email
              _infoRow(
                Icons.email_outlined,
                'EMAIL ADDRESS',
                widget.email.isNotEmpty
                    ? widget.email
                    : '${widget.name.toLowerCase().replaceAll(' ', '')}@minoto.app',
              ),
              const SizedBox(height: 10),

              // Member Since
              _infoRow(
                Icons.calendar_today_outlined,
                'MEMBER SINCE',
                widget.memberSince.isNotEmpty
                    ? widget.memberSince
                    : 'October 2023',
              ),
              const SizedBox(height: 32),

              // Delete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Member'),
                      content: Text(
                          'Are you sure you want to delete ${widget.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onDelete?.call();
                            Navigator.pop(context);
                          },
                          child: Text('Delete',
                              style:
                                  TextStyle(color: Colors.red.shade600)),
                        ),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete Member',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}