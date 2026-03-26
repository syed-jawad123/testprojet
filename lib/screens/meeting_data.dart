// Shared meeting data model
class MeetingTranscriptEntry {
  final String timestamp;
  final String speaker;
  final String text;

  const MeetingTranscriptEntry({
    required this.timestamp,
    required this.speaker,
    required this.text,
  });
}

class MeetingData {
  final String title;
  final String date;
  final String duration;
  final String attendees;
  final String summary;
  final List<MeetingTranscriptEntry> transcript;

  const MeetingData({
    required this.title,
    required this.date,
    required this.duration,
    required this.attendees,
    required this.summary,
    required this.transcript,
  });
}

// Meeting recordings storage - populated during voice recording
class MeetingRecordingStore {
  static final Map<String, List<Map<String, dynamic>>> _recordings = {};
  static final Map<String, MeetingData> _meetingData = {};

  static void saveRecording(String meetingTitle, String memberName, int durationSeconds) {
    _recordings.putIfAbsent(meetingTitle, () => []);
    _recordings[meetingTitle]!.removeWhere((r) => r['name'] == memberName);
    _recordings[meetingTitle]!.add({
      'name': memberName,
      'duration': durationSeconds,
    });
  }

  static List<Map<String, dynamic>> getRecordings(String meetingTitle) {
    return _recordings[meetingTitle] ?? [];
  }

  static MeetingData generateMeetingData(String meetingTitle, String date) {
    final recordings = getRecordings(meetingTitle);
    final attendees = recordings.isEmpty
        ? 'Ali Ahmed, Saad, Sara Khan'
        : recordings.map((r) => r['name'] as String).join(', ');

    final totalMinutes = recordings.isEmpty
        ? 45
        : recordings.fold<int>(0, (sum, r) => sum + (r['duration'] as int)) ~/ 60 + 1;

    // Generate transcript based on recorded members
    final transcript = recordings.isEmpty
        ? _defaultTranscript(meetingTitle)
        : _generateTranscript(meetingTitle, recordings);

    final summary = _generateSummary(meetingTitle, attendees, totalMinutes);

    return MeetingData(
      title: meetingTitle,
      date: date,
      duration: '$totalMinutes minutes',
      attendees: attendees,
      summary: summary,
      transcript: transcript,
    );
  }

  static List<MeetingTranscriptEntry> _generateTranscript(
      String title, List<Map<String, dynamic>> recordings) {
    final entries = <MeetingTranscriptEntry>[];
    int seconds = 0;

    for (final rec in recordings) {
      final name = rec['name'] as String;
      final duration = rec['duration'] as int;
      final timestamp = '[${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}]';

      entries.add(MeetingTranscriptEntry(
        timestamp: timestamp,
        speaker: name,
        text: _getSpeakerText(name, title),
      ));
      seconds += duration + 15;
    }
    return entries;
  }

  static List<MeetingTranscriptEntry> _defaultTranscript(String title) {
    return [
      MeetingTranscriptEntry(
        timestamp: '[00:00]',
        speaker: 'Ali Ahmed',
        text: 'Good morning everyone. Let\'s get started with our $title session.',
      ),
      MeetingTranscriptEntry(
        timestamp: '[01:20]',
        speaker: 'Saad',
        text: 'I\'ve reviewed the preliminary data and we have some key points to discuss today.',
      ),
      MeetingTranscriptEntry(
        timestamp: '[02:45]',
        speaker: 'Sara Khan',
        text: 'From my side, everything looks good. We just need to finalize the action items.',
      ),
    ];
  }

  static String _getSpeakerText(String name, String title) {
    final texts = {
      'Shahzaib': 'I wanted to share my thoughts on $title. We need to focus on the key deliverables and ensure everyone is aligned on the timeline.',
      'Sara Khan': 'Based on my analysis, the main priorities for $title should be quality and efficiency. I suggest we break this into smaller milestones.',
      'Ali Zain': 'From a technical perspective, $title requires careful planning. I can handle the implementation side if we agree on the approach today.',
      'Zainab': 'I think we should also consider the user experience aspect of $title. Our customers expect a seamless workflow.',
      'Muhammad Wasay': 'Agreed. For $title, I\'ll prepare the documentation and make sure all stakeholders are informed about our progress.',
    };
    return texts[name] ?? '$name shared their perspective on $title and agreed to follow up with the team by end of week.';
  }

  static String _generateSummary(String title, String attendees, int minutes) {
    return 'The team held a productive session for "$title" with participants: $attendees. '
        'The meeting lasted approximately $minutes minutes and covered key discussion points. '
        'All attendees contributed valuable insights and action items were assigned. '
        'Follow-up tasks have been identified and the team agreed to reconvene to track progress. '
        'Key decisions were made regarding priorities and next steps for successful execution.';
  }
}
