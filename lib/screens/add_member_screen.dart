import 'package:flutter/material.dart';
import '../components/input_field.dart';
import '../components/black_button.dart';
import '../components/labeled_checkbox.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});
  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saveToExisting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                  // Top Bar
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    const Text('Add New Member',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 32),

                  // Full Name
                  InputField(
                    label: 'Full Name',
                    hint: 'Enter full name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),

                  // Email Address
                  InputField(
                    label: 'Email Address',
                    hint: 'Enter email address',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),

                  // Save to existing members checkbox
                  LabeledCheckbox(
                    value: _saveToExisting,
                    label: 'Save to existing members',
                    onChanged: (val) => setState(() => _saveToExisting = val ?? false),
                  ),
                ],
              ),
            ),
          ),

          // Add Member Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlackButton(
              label: 'Add Member',
              onPressed: () {
                if (_nameController.text.trim().isEmpty ||
                    _emailController.text.trim().isEmpty) return;
                Navigator.pop(context, {
                  'name': _nameController.text.trim(),
                  'email': _emailController.text.trim(),
                  'selected': true,
                });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
