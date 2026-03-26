import 'package:flutter/material.dart';
import '../components/meeting_search_bar.dart';
import '../components/member_card.dart';
import 'member_profile_screen.dart';
import 'app_data.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return existingMembers;
    return existingMembers
        .where((m) =>
            m['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m['role'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Members',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                const Icon(Icons.more_vert, size: 22, color: Colors.black54),
              ]),
              const SizedBox(height: 16),
              MeetingSearchBar(
                hint: 'Search members...',
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ]),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final member = _filtered[i];
                return MemberCard(
                  name: member['name'],
                  role: member['role'],
                  initials: member['initials'],
                  imageBytes: member['imageBytes'],
                  onTap: () async {
                    // Find index in existingMembers
                    final idx = existingMembers.indexWhere(
                        (m) => m['name'] == member['name']);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberProfileScreen(
                          memberIndex: idx,
                          name: member['name'],
                          role: member['role'],
                          initials: member['initials'],
                          recordingSeconds:
                              int.tryParse(member['seconds'] ?? '45') ?? 45,
                          onDelete: () {
                            setState(() {
                              existingMembers.removeWhere(
                                  (m) => m['name'] == member['name']);
                            });
                          },
                        ),
                      ),
                    );
                    // Refresh to show updated image
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
