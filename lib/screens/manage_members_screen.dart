import 'package:flutter/material.dart';
import '../components/meeting_search_bar.dart';
import '../components/black_button.dart';
import '../components/member_list_item.dart';
import 'add_member_screen.dart';

class ManageMembersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> initialMembers;

  const ManageMembersScreen({
    super.key,
    required this.initialMembers,
  });

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  late List<Map<String, dynamic>> _members;

  @override
  void initState() {
    super.initState();
    _members = List<Map<String, dynamic>>.from(
        widget.initialMembers.map((m) => Map<String, dynamic>.from(m)));
  }

  int get _selectedCount => _members.where((m) => m['selected'] == true).length;

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
                      onTap: () => Navigator.pop(context, _members),
                      child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Manage Members',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, _members),
                      child: const Text('Done',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  const MeetingSearchBar(hint: 'Search members by name or email'),
                  const SizedBox(height: 24),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('EXISTING MEMBERS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: Colors.grey, letterSpacing: 1.1)),
                    Text('$_selectedCount selected',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                  ]),
                  const SizedBox(height: 8),

                  ...List.generate(_members.length, (i) => Column(children: [
                    MemberListItem(
                      name: _members[i]['name'],
                      email: _members[i]['email'],
                      isSelected: _members[i]['selected'],
                      onChanged: (val) =>
                          setState(() => _members[i]['selected'] = val ?? false),
                      onDelete: () => setState(() => _members.removeAt(i)),
                    ),
                    if (i < _members.length - 1)
                      Divider(height: 1, color: Colors.grey.shade200),
                  ])),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Add New Member Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: BlackButton(
              label: '  Add New Member',
              onPressed: () async {
                final newMember = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMemberScreen()),
                );
                if (newMember != null) {
                  setState(() => _members.add({
                    ...newMember,
                    'selected': true,
                    'isNew': true,  // tag karo taake VoiceRecording mein NEW section mein aaye
                  }));
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
