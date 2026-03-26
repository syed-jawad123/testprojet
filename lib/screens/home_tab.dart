import 'package:flutter/material.dart';
import '../components/logo.dart';
import '../components/section_label.dart';
import 'app_data.dart';
import '../components/session_card.dart';
import '../components/stats_card.dart';
import '../components/meeting_row.dart';
import '../components/meeting_search_bar.dart';
import 'meeting_in_progress_screen.dart';
import 'introduction_screen.dart';
import 'new_meeting_screen.dart';

class HomeTab extends StatefulWidget {
  final int pausedSeconds;
  final String meetingTitle;
  final List<Map<String, dynamic>> upcomingMeetings;
  final String userName;
  final int totalMeetings;
  final String exportFormat;
  final bool includeTimestamps;
  final VoidCallback? onGoToMeetings;

  const HomeTab({
    super.key,
    this.pausedSeconds = 765,
    this.meetingTitle = 'Project Sync Strategy',
    this.upcomingMeetings = const [],
    this.userName = 'Sheharyar',
    this.totalMeetings = 0,
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
    this.onGoToMeetings,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late int _elapsedSeconds;
  late String _meetingTitle;
  bool _isPaused = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.pausedSeconds;
    _meetingTitle = widget.meetingTitle;
  }

  @override
  void didUpdateWidget(HomeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pausedSeconds != widget.pausedSeconds ||
        oldWidget.meetingTitle != widget.meetingTitle) {
      setState(() {
        _elapsedSeconds = widget.pausedSeconds;
        _meetingTitle = widget.meetingTitle;
        _isPaused = true;
      });
    }
    // upcomingMeetings update hone pe rebuild
    if (oldWidget.upcomingMeetings.length != widget.upcomingMeetings.length) {
      setState(() {});
    }
  }

  String get _formattedElapsed {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _resumeRecording() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingInProgressScreen(
          initialSeconds: _elapsedSeconds,
          meetingTitle: _meetingTitle,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _elapsedSeconds = result['seconds'];
        _isPaused = result['paused'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    const AppLogoWidget(),
                    const SizedBox(width: 10),
                    const Text('Minoto',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                  Row(children: [
                    const Icon(Icons.notifications_outlined, color: Colors.black54, size: 24),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                  ]),
                ]),
                const SizedBox(height: 24),

                Text('Good morning,',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                Text('Hello, ${widget.userName}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),

                // Active Session
                const SectionLabel(title: 'ACTIVE SESSION'),
                const SizedBox(height: 12),
                SessionCard(
                  title: _meetingTitle,
                  status: _isPaused ? 'Paused' : 'Recording',
                  date: '12 Oct',
                  elapsed: _formattedElapsed,
                  total: '00:45:00',
                  progress: (_elapsedSeconds / 2700).clamp(0.0, 1.0),
                  onResume: _resumeRecording,
                ),
                const SizedBox(height: 24),

                // Quick Stats
                const SectionLabel(title: 'QUICK STATS'),
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  // Is week ki meetings — date parse karke check karo
                  final now = DateTime.now();
                  final weekStart = now.subtract(Duration(days: now.weekday - 1));
                  final weekEnd = weekStart.add(const Duration(days: 6));
                  final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
                  final weekEndDate = DateTime(weekEnd.year, weekEnd.month, weekEnd.day, 23, 59);

                  int thisWeekCount = 0;
                  for (final m in upcomingMeetings) {
                    try {
                      // Date formats: 'Oct 12, 2023' ya 'DD/MM/YYYY'
                      final dateStr = m['date'].toString();
                      DateTime? meetingDate;

                      // DD/MM/YYYY format
                      if (dateStr.contains('/')) {
                        final parts = dateStr.split('/');
                        if (parts.length == 3) {
                          meetingDate = DateTime(
                            int.parse(parts[2]),
                            int.parse(parts[1]),
                            int.parse(parts[0]),
                          );
                        }
                      }
                      // MMM DD, YYYY format (e.g., Oct 12, 2023)
                      else if (dateStr.contains(',')) {
                        const months = {
                          'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
                          'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
                          'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
                        };
                        final parts = dateStr.replaceAll(',', '').split(' ');
                        if (parts.length == 3) {
                          meetingDate = DateTime(
                            int.parse(parts[2]),
                            months[parts[0]] ?? 1,
                            int.parse(parts[1]),
                          );
                        }
                      }

                      if (meetingDate != null &&
                          !meetingDate.isBefore(weekStartDate) &&
                          !meetingDate.isAfter(weekEndDate)) {
                        thisWeekCount++;
                      }
                    } catch (_) {}
                  }

                  final totalArchived = archivedMeetings.length;

                  return Row(children: [
                    StatsCard(
                      icon: Icons.calendar_today_outlined,
                      value: '$thisWeekCount',
                      label: 'Meetings this week',
                    ),
                    const SizedBox(width: 12),
                    StatsCard(
                      icon: Icons.bar_chart_outlined,
                      value: '$totalArchived',
                      label: 'Total recorded',
                    ),
                  ]);
                }),
                const SizedBox(height: 24),

                // Upcoming Meetings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('UPCOMING MEETINGS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                            color: Colors.grey, letterSpacing: 1.1)),
                    InkWell(
                      onTap: () => widget.onGoToMeetings?.call(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('View All',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                                color: Colors.teal)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search bar
                MeetingSearchBar(
                  hint: 'Search meetings...',
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: 12),

                // Filtered meetings
                Builder(builder: (context) {
                  final all = upcomingMeetings; // global list direct
                  final filtered = _searchQuery.isEmpty
                      ? all.take(3).toList()
                      : all.where((m) => m['title']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: Column(children: [
                        Icon(Icons.search_off_outlined,
                            size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          'No meeting found for "$_searchQuery"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ]),
                    );
                  }

                  return Column(
                    children: filtered.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MeetingRow(
                        title: m['title'],
                        date: m['date'],
                        duration: m['duration'],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntroductionScreen(
                              meetingTitle: m['title'],
                              members: m['members'] != null
                                  ? (m['members'] as List)
                                      .map((e) => Map<String, dynamic>.from(e))
                                      .toList()
                                  : [],
                              exportFormat: widget.exportFormat,
                              includeTimestamps: widget.includeTimestamps,
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // FAB
          Positioned(
            bottom: 16, right: 16,
            child: FloatingActionButton(
              heroTag: 'home_fab',
              onPressed: () async {
                final newMeeting = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewMeetingScreen()),
                );
                if (newMeeting != null) {
                  widget.onGoToMeetings?.call();
                }
              },
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}