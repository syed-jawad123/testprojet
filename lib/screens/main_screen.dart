import 'package:flutter/material.dart';
import '../components/bottom_navbar.dart';
import 'home_tab.dart';
import 'meetings_tab.dart';
import 'archive_tab.dart';
import 'settings_tab.dart';
import 'app_data.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final int pausedSeconds;
  final String meetingTitle;
  final String userEmail;
  final String userName;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.pausedSeconds = 0,
    this.meetingTitle = '',
    this.userEmail = '',
    this.userName = '',
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _navIndex;
  String _exportFormat = 'Portable Document Format (.pdf)';
  bool _includeTimestamps = true;
  int _version = 0; // har meeting add pe increment

  @override
  void initState() {
    super.initState();
    _navIndex = widget.initialIndex;
  }

  void _addMeeting(Map<String, dynamic> meeting) {
    upcomingMeetings.insert(0, {
      'title': meeting['title'],
      'date': meeting['date'],
      'duration': meeting['duration'],
      'color': meeting['color'],
      'icon': null,
      'members': meeting['members'] ?? [],
    });
    setState(() => _version++);
  }

  @override
  Widget build(BuildContext context) {
    // Meetings list har build pe fresh
    final meetings = List<Map<String, dynamic>>.from(upcomingMeetings);

    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: _buildBody(meetings),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> meetings) {
    switch (_navIndex) {
      case 0:
        return HomeTab(
          key: ValueKey('home_$_version'),
          pausedSeconds: widget.pausedSeconds,
          meetingTitle: widget.meetingTitle.isNotEmpty
              ? widget.meetingTitle
              : 'Project Sync Strategy',
          upcomingMeetings: meetings,
          userName: widget.userName.isNotEmpty ? widget.userName : 'User',
          totalMeetings: meetings.length,
          exportFormat: _exportFormat,
          includeTimestamps: _includeTimestamps,
          onGoToMeetings: () => setState(() => _navIndex = 1),
        );
      case 1:
        return MeetingsTab(
          key: ValueKey('meetings_$_version'),
          meetings: meetings,
          onMeetingAdded: _addMeeting,
          exportFormat: _exportFormat,
          includeTimestamps: _includeTimestamps,
        );
      case 2:
        return const ArchiveTab();
      case 3:
        return SettingsTab(
          userName: widget.userName.isNotEmpty ? widget.userName : 'User',
          userEmail: widget.userEmail.isNotEmpty
              ? widget.userEmail
              : 'user@email.com',
          exportFormat: _exportFormat,
          includeTimestamps: _includeTimestamps,
          onSettingsChanged: (format, timestamps) {
            setState(() {
              _exportFormat = format;
              _includeTimestamps = timestamps;
            });
          },
        );
      default:
        return const SizedBox();
    }
  }
}
