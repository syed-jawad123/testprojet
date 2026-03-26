import 'package:flutter/material.dart';
import '../components/meeting_search_bar.dart';
import '../components/section_label.dart';
import '../components/meeting_card.dart';
import 'new_meeting_screen.dart';
import 'introduction_screen.dart';
import 'app_data.dart';

class MeetingsTab extends StatefulWidget {
  final List<Map<String, dynamic>> meetings;
  final Function(Map<String, dynamic>) onMeetingAdded;
  final String exportFormat;
  final bool includeTimestamps;

  const MeetingsTab({
    super.key,
    required this.meetings,
    required this.onMeetingAdded,
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
  });

  @override
  State<MeetingsTab> createState() => _MeetingsTabState();
}

class _MeetingsTabState extends State<MeetingsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MeetingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meetings.length != widget.meetings.length) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> get _filtered {
    // Direct global list se read karo — hamesha latest data
    final source = upcomingMeetings;
    if (_searchQuery.isEmpty) return List.from(source);
    return source
        .where((m) => m['title']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildAvatar(Map<String, dynamic> m) {
    Color bg = m['color'] == 'orange'
        ? Colors.orange.shade200
        : m['color'] == 'teal'
            ? Colors.teal.shade700
            : Colors.grey.shade300;

    IconData iconData = Icons.event_note_outlined;
    if (m['icon'] != null && m['icon'] is IconData) {
      iconData = m['icon'] as IconData;
    }

    return Container(
      decoration: m['color'] != null
          ? BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10))
          : BoxDecoration(color: bg),
      child: Icon(iconData,
          color: Colors.white,
          size: m['color'] == null ? 32 : 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Meetings',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                const Icon(Icons.more_vert, color: Colors.black54, size: 24),
              ]),
              const SizedBox(height: 16),

              // Search Bar
              MeetingSearchBar(
                hint: 'Search meetings...',
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              const SizedBox(height: 24),

              // Count row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionLabel(title: 'UPCOMING'),
                  Text(
                    _searchQuery.isEmpty
                        ? '${upcomingMeetings.length} scheduled'
                        : '${filtered.length} found',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // No results
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(children: [
                      Icon(Icons.search_off_outlined,
                          size: 56, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No meetings yet.\nTap + to add a meeting.'
                            : 'No meeting found for\n"$_searchQuery"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            height: 1.5),
                      ),
                    ]),
                  ),
                )
              else
                ...filtered.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MeetingCard(
                        title: m['title'],
                        date: m['date'],
                        duration: m['duration'],
                        avatar: _buildAvatar(m),
                        onStart: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntroductionScreen(
                              meetingTitle: m['title'],
                              members: m['members'] != null
                                  ? List<Map<String, dynamic>>.from(
                                      m['members'])
                                  : [],
                              exportFormat: widget.exportFormat,
                              includeTimestamps: widget.includeTimestamps,
                            ),
                          ),
                        ),
                        onShare: () {},
                      ),
                    )),

              const SizedBox(height: 16),
              if (filtered.isNotEmpty)
                Center(
                  child: Text(
                    'Looking for more? Check the archives.',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade500),
                  ),
                ),
            ],
          ),
        ),

        // FAB
        Positioned(
          bottom: 16, right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final newMeeting =
                  await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewMeetingScreen()),
              );
              if (newMeeting != null && mounted) {
                widget.onMeetingAdded({
                  'title': newMeeting['title'],
                  'date': newMeeting['date'],
                  'duration': newMeeting['duration'],
                  'color': null,
                  'icon': null,
                  'members': newMeeting['members'] ?? [],
                });
                // Force local refresh
                setState(() {});
              }
            },
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ]),
    );
  }
}