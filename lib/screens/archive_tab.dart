import 'package:flutter/material.dart';
import '../components/meeting_search_bar.dart';
import '../components/filter_tabs.dart';
import '../components/archive_item_card.dart';
import 'meeting_minutes_screen.dart';
import 'app_data.dart';

class ArchiveTab extends StatefulWidget {
  const ArchiveTab({super.key});
  @override
  State<ArchiveTab> createState() => _ArchiveTabState();
}

class _ArchiveTabState extends State<ArchiveTab> {
  int _filterIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get _filteredMeetings {
    List<Map<String, dynamic>> list = archivedMeetings;

    // Last 30 days filter
    if (_filterIndex == 1) {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      list = list.where((m) {
        try {
          final date = DateTime.parse(m['date']);
          return date.isAfter(thirtyDaysAgo);
        } catch (_) {
          return false;
        }
      }).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((m) => m['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  // Group by month
  Map<String, List<Map<String, dynamic>>> get _grouped {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final m in _filteredMeetings) {
      try {
        final date = DateTime.parse(m['date']);
        final key = '${_monthName(date.month).toUpperCase()} ${date.year}';
        grouped.putIfAbsent(key, () => []).add(m);
      } catch (_) {
        grouped.putIfAbsent('OTHER', () => []).add(m);
      }
    }
    return grouped;
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _monthLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 1.1)),
      );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Icon(Icons.menu, color: Colors.black87, size: 24),
              const Text('Archive',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Icon(Icons.more_vert, color: Colors.black54, size: 24),
            ]),
            const SizedBox(height: 16),
            MeetingSearchBar(
              hint: 'Search meetings...',
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            const SizedBox(height: 16),
            FilterTabs(
              options: const ['All Time', 'Last 30 days'],
              selectedIndex: _filterIndex,
              onSelected: (i) => setState(() => _filterIndex = i),
            ),
            const SizedBox(height: 24),

            if (grouped.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    _filterIndex == 1
                        ? 'No meetings in the last 30 days.'
                        : 'No meetings found.',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              ...grouped.entries.map((entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _monthLabel(entry.key),
                      ...entry.value.map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ArchiveItemCard(
                              title: m['title'],
                              date: m['displayDate'],
                              duration: m['duration'],
                              avatarColors: [
                                Colors.brown.shade300,
                                Colors.blueGrey.shade300,
                              ],
                              extraCount: m['extraCount'] ?? 0,
                              onViewDetails: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MeetingMinutesScreen(
                                    meetingTitle: m['title'],
                                    date: m['displayDate'],
                                    duration: m['duration'],
                                    members: existingMembers,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(height: 12),
                    ],
                  )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
