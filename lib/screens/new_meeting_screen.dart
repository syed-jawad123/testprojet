import 'package:flutter/material.dart';
import '../components/input_field.dart';
import '../components/black_button.dart';
import '../components/date_picker_field.dart';
import 'manage_members_screen.dart';
import 'app_data.dart';

class NewMeetingScreen extends StatefulWidget {
  const NewMeetingScreen({super.key});
  @override
  State<NewMeetingScreen> createState() => _NewMeetingScreenState();
}

class _NewMeetingScreenState extends State<NewMeetingScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _durationController = TextEditingController();

  // Use shared existingMembers — copy to allow selection state
  late List<Map<String, dynamic>> _members;

  @override
  void initState() {
    super.initState();
    _members = existingMembers
        .map((m) => {
              'name': m['name'],
              'email': '${m['name'].toString().toLowerCase().replaceAll(' ', '').replaceAll('-', '')}@minoto.com',
              'selected': false,
            })
        .toList();
  }

  int get _selectedCount => _members.where((m) => m['selected'] == true).length;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void _saveMeeting() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a meeting title')),
      );
      return;
    }
    Navigator.pop(context, {
      'title': _titleController.text.trim(),
      'date': _dateController.text.isEmpty ? 'No date' : _dateController.text,
      'duration': _durationController.text.isEmpty ? '—' : _durationController.text,
      'members': _members,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('New Meeting',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 22),
                  ]),
                  const SizedBox(height: 24),

                  InputField(
                    label: 'Title',
                    hint: 'Enter meeting title',
                    controller: _titleController,
                  ),
                  const SizedBox(height: 20),

                  DatePickerField(
                    label: 'Select Date:',
                    hint: 'DD/MM/YYYY',
                    controller: _dateController,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),

                  Row(children: [
                    Expanded(
                      child: InputField(
                        label: 'Start Time:',
                        hint: '00:00',
                        controller: _startTimeController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputField(
                        label: 'Duration:',
                        hint: '00 Hours',
                        controller: _durationController,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // Select Members - shows count of selected
                  GestureDetector(
                    onTap: () async {
                      final updatedMembers =
                          await Navigator.push<List<Map<String, dynamic>>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageMembersScreen(
                            initialMembers: _members,
                          ),
                        ),
                      );
                      if (updatedMembers != null) {
                        setState(() => _members = updatedMembers);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(children: [
                        Icon(Icons.group_add_outlined,
                            size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedCount > 0
                                ? '$_selectedCount member(s) selected'
                                : 'Select Members',
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedCount > 0
                                    ? Colors.black87
                                    : Colors.grey.shade600),
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 20, color: Colors.grey.shade500),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlackButton(label: 'Save Meeting', onPressed: _saveMeeting),
          ),
        ]),
      ),
    );
  }
}
