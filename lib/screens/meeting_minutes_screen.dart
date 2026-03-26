import 'package:flutter/material.dart';
import '../components/black_button.dart';
import '../components/meeting_info_row.dart';
import '../components/transcript_entry.dart';
import '../components/export_minutes_sheet.dart';

class MeetingMinutesScreen extends StatefulWidget {
  final String meetingTitle;
  final String date;
  final String duration;
  final List<Map<String, dynamic>> members;
  final String exportFormat;
  final bool includeTimestamps;

  const MeetingMinutesScreen({
    super.key,
    this.meetingTitle = 'Meeting',
    this.date = 'Oct 24, 2023',
    this.duration = '45 minutes',
    this.members = const [],
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  State<MeetingMinutesScreen> createState() => _MeetingMinutesScreenState();
}

class _MeetingMinutesScreenState extends State<MeetingMinutesScreen> {
  int _selectedTab = 1;

  Widget _bulletPoint(String text) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('• ', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      Expanded(
        child: Text(text,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
      ),
    ]);
  }

  // Generate transcript dynamically from members
  List<Map<String, String>> get _transcription {
    if (widget.members.isEmpty) {
      return [
        {'timestamp': '[00:00]', 'speaker': 'Speaker 1', 'text': 'Meeting started.'},
      ];
    }

    final memberNames = widget.members.map((m) => m['name'].toString()).toList();
    final List<Map<String, String>> entries = [];
    final dialogues = [
      'Good morning everyone. Let\'s get started with our ${widget.meetingTitle} session. I want to make sure we cover all the key points today.',
      'Thank you. I\'ve been looking forward to this discussion. I have some important updates to share with the team.',
      'I agree with the points raised. From my perspective, we need to focus on our immediate priorities and set clear action items.',
      'That\'s a great point. I think we should also consider the timeline and make sure everyone is aligned on the next steps.',
      'I can take ownership of the follow-up tasks. Let\'s make sure we document everything clearly before we wrap up.',
      'Absolutely. I\'ll make sure to share the meeting notes with everyone after this session.',
      'Let\'s schedule a follow-up to review our progress and make any necessary adjustments.',
      'I think we\'ve covered all the key points. Thank you everyone for your valuable input today.',
    ];

    for (int i = 0; i < memberNames.length && i < dialogues.length; i++) {
      final totalSecs = i * 90;
      final minutes = totalSecs ~/ 60;
      final seconds = totalSecs % 60;
      entries.add({
        'timestamp': '[${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}]',
        'speaker': memberNames[i],
        'text': dialogues[i],
      });
    }
    return entries;
  }

  // Generate summary from members
  String get _summaryText {
    final names = widget.members.isNotEmpty
        ? widget.members.map((m) => m['name'].toString()).join(', ')
        : 'Team members';
    return 'The meeting "${widget.meetingTitle}" was held on ${widget.date} with the following participants: $names. '
        'The team reviewed key priorities and discussed action items. '
        'Important decisions were made regarding project timelines and responsibilities. '
        'All participants agreed on next steps and follow-up tasks.';
  }

  String get _attendees {
    if (widget.members.isEmpty) return 'No attendees';
    return widget.members.map((m) => m['name'].toString()).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Column(children: [
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
                      child: const Icon(Icons.arrow_back,
                          size: 22, color: Colors.black87),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Meeting Minutes',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const Icon(Icons.share_outlined,
                        size: 22, color: Colors.black87),
                  ]),
                  const SizedBox(height: 24),

                  // Meeting Title
                  Text(widget.meetingTitle,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),

                  // Info rows
                  MeetingInfoRow(label: 'Date', value: widget.date),
                  MeetingInfoRow(label: 'Duration', value: widget.duration),
                  MeetingInfoRow(label: 'Attendees', value: _attendees),
                  const SizedBox(height: 20),

                  // Tabs
                  Row(children: [
                    _tabItem('Minutes Summary', 0),
                    const SizedBox(width: 24),
                    _tabItem('Minutes Transcription', 1),
                  ]),
                  Divider(color: Colors.grey.shade300, height: 1),
                  const SizedBox(height: 20),

                  // Tab content
                  if (_selectedTab == 0) ...[
                    Row(children: [
                      const Icon(Icons.description_outlined,
                          size: 18, color: Colors.black54),
                      const SizedBox(width: 8),
                      const Text('Brief Overview',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.meetingTitle,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(_summaryText,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    height: 1.6)),
                            const SizedBox(height: 12),
                            const Text('Key Discussion Areas',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            _bulletPoint(
                                'Project priorities and timelines were discussed and agreed upon by all team members.'),
                            const SizedBox(height: 6),
                            _bulletPoint(
                                'Action items were assigned to respective team members with clear deadlines.'),
                            const SizedBox(height: 6),
                            _bulletPoint(
                                'Next steps and follow-up meeting scheduled to review progress.'),
                          ]),
                    ),
                  ] else
                    ..._transcription.map((e) => TranscriptEntry(
                          timestamp: e['timestamp']!,
                          speaker: e['speaker']!,
                          text: e['text']!,
                        )),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Export Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: BlackButton(
              label: '  Export Minutes',
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ExportMinutesSheet(
                  defaultFormat: widget.exportFormat,
                  defaultTimestamps: widget.includeTimestamps,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.teal : Colors.grey.shade500)),
        const SizedBox(height: 8),
        if (isSelected)
          Container(height: 2, width: 120, color: Colors.teal),
      ]),
    );
  }
}
