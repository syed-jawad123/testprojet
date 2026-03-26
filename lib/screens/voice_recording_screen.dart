import 'dart:async';
import 'package:flutter/material.dart';
import '../components/black_button.dart';
import '../components/section_label.dart';
import '../components/recording_card.dart';
import 'meeting_in_progress_screen.dart';
import 'app_data.dart';

class VoiceRecordingScreen extends StatefulWidget {
  final String meetingTitle;
  final List<Map<String, dynamic>> members;
  final String exportFormat;
  final bool includeTimestamps;

  const VoiceRecordingScreen({
    super.key,
    this.meetingTitle = 'Meeting',
    this.members = const [],
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
  int? _recordingIndex;
  bool _isNewMember = true;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  final Map<String, int> _recordingDurations = {};

  late List<Map<String, dynamic>> _newMembers;
  late List<Map<String, dynamic>> _existingMembers;

  @override
  void initState() {
    super.initState();

    final existingNames = existingMembers.map((m) => m['name'].toString()).toSet();

    if (widget.members.isNotEmpty) {
      // NEW MEMBERS: jo AddMemberScreen se add kiye gaye (isNew: true ya existingMembers mein nahi)
      _newMembers = widget.members
          .where((m) =>
              m['isNew'] == true ||
              !existingNames.contains(m['name'].toString()))
          .map((m) => {
                'name': m['name'],
                'email': m['email'] ?? '',
                'done': false,
              })
          .toList();

      // EXISTING MEMBERS: sirf woh jo existingMembers mein hain aur selected == true
      _existingMembers = widget.members
          .where((m) =>
              existingNames.contains(m['name'].toString()) &&
              m['selected'] == true &&
              m['isNew'] != true)
          .map((m) {
            final existing = existingMembers.firstWhere(
              (e) => e['name'] == m['name'],
              orElse: () => {'role': '', 'initials': ''},
            );
            return {
              'name': m['name'],
              'role': existing['role'] ?? '',
              'initials': existing['initials'] ?? '',
              'done': false,
            };
          })
          .toList();
    } else {
      _newMembers = [];
      _existingMembers = [];
    }
  }

  String _memberKey(int index, bool isNew) =>
      '${isNew ? 'new' : 'existing'}_$index';

  void _startRecording(int index, bool isNew) {
    _recordingTimer?.cancel();
    _recordingSeconds = 0;
    setState(() {
      _recordingIndex = index;
      _isNewMember = isNew;
    });
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordingSeconds++);
    });
  }

  void _stopRecording() {
    if (_recordingIndex == null) return;
    _recordingTimer?.cancel();
    final key = _memberKey(_recordingIndex!, _isNewMember);
    setState(() {
      _recordingDurations[key] = _recordingSeconds;
      if (_isNewMember) {
        _newMembers[_recordingIndex!]['done'] = true;
      } else {
        _existingMembers[_recordingIndex!]['done'] = true;
      }
      _recordingIndex = null;
      _recordingSeconds = 0;
    });
  }

  String _formattedDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _formattedRecordingTime {
    final m = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_recordingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _currentName {
    if (_recordingIndex == null) return '';
    return _isNewMember
        ? _newMembers[_recordingIndex!]['name']
        : _existingMembers[_recordingIndex!]['name'];
  }

  Widget _membersCard(List<Map<String, dynamic>> members, bool isExisting) {
    if (members.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: List.generate(members.length, (i) {
          final key = _memberKey(i, !isExisting);
          final duration = _recordingDurations[key];
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.brown.shade300,
                  child: const Icon(Icons.person, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(members[i]['name'],
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    if (duration != null)
                      Text('Recorded: ${_formattedDuration(duration)}',
                          style: TextStyle(fontSize: 11, color: Colors.teal.shade600)),
                  ]),
                ),
                GestureDetector(
                  onTap: () => _startRecording(i, !isExisting),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.teal, shape: BoxShape.circle),
                    child: Icon(
                      members[i]['done'] == true
                          ? Icons.check
                          : (isExisting ? Icons.replay : Icons.mic),
                      color: Colors.white, size: 18,
                    ),
                  ),
                ),
              ]),
            ),
            if (i < members.length - 1)
              Divider(height: 1, color: Colors.grey.shade100),
          ]);
        }),
      ),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text('Voice Recording',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 22),
                    ]),
                    const SizedBox(height: 24),

                    if (_newMembers.isNotEmpty) ...[
                      const SectionLabel(title: 'NEW MEMBERS'),
                      const SizedBox(height: 12),
                      _membersCard(_newMembers, false),
                      const SizedBox(height: 24),
                    ],

                    if (_existingMembers.isNotEmpty) ...[
                      const SectionLabel(title: 'EXISTING MEMBERS'),
                      const SizedBox(height: 12),
                      _membersCard(_existingMembers, true),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: BlackButton(
                label: 'Continue',
                onPressed: () {
                  // New members: sirf woh jo record kar chuke hain (done = true)
                  final recordedNewMembers = _newMembers
                      .where((m) => m['done'] == true)
                      .toList();

                  // Agar koi new member record nahi hua to warning
                  final unrecordedNew = _newMembers
                      .where((m) => m['done'] != true)
                      .toList();

                  if (unrecordedNew.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${unrecordedNew.map((m) => m['name']).join(', ')} ki recording zaroori hai!',
                        ),
                        backgroundColor: Colors.red.shade600,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return;
                  }

                  // Existing members: sab pass ho jayen (recording optional)
                  final allMembers = [
                    ...recordedNewMembers,
                    ..._existingMembers,
                  ];

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetingInProgressScreen(
                        meetingTitle: widget.meetingTitle,
                        members: allMembers,
                        exportFormat: widget.exportFormat,
                        includeTimestamps: widget.includeTimestamps,
                      ),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ]),

          // Recording overlay
          if (_recordingIndex != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.brown.shade300,
                        child: const Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_currentName,
                              style: const TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w600, color: Colors.white)),
                          Text(_formattedRecordingTime,
                              style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.teal, shape: BoxShape.circle),
                        child: const Icon(Icons.mic, color: Colors.white, size: 16),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    child: RecordingCard(onStop: _stopRecording),
                  ),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}
