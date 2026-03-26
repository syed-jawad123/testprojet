import 'package:flutter/material.dart';
import '../components/user_profile_card.dart';
import '../components/settings_group.dart';
import '../components/settings_row.dart';
import '../components/dropdown_setting.dart';
import '../components/toggle_setting.dart';
import 'members_screen.dart';

class SettingsTab extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String exportFormat;
  final bool includeTimestamps;
  final Function(String format, bool timestamps)? onSettingsChanged;

  const SettingsTab({
    super.key,
    this.userName = 'Sheharyar',
    this.userEmail = 'shery@email.com',
    this.exportFormat = 'Portable Document Format (.pdf)',
    this.includeTimestamps = true,
    this.onSettingsChanged,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late String _exportFormat;
  late bool _includeTimestamps;

  @override
  void initState() {
    super.initState();
    _exportFormat = widget.exportFormat;
    _includeTimestamps = widget.includeTimestamps;
  }

  @override
  void didUpdateWidget(SettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exportFormat != widget.exportFormat) {
      setState(() => _exportFormat = widget.exportFormat);
    }
    if (oldWidget.includeTimestamps != widget.includeTimestamps) {
      setState(() => _includeTimestamps = widget.includeTimestamps);
    }
  }

  void _updateSettings(String format, bool timestamps) {
    setState(() {
      _exportFormat = format;
      _includeTimestamps = timestamps;
    });
    widget.onSettingsChanged?.call(format, timestamps);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Expanded(
              child: Center(
                child: Text('Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          UserProfileCard(name: widget.userName, email: widget.userEmail),
          const SizedBox(height: 24),
          SettingsGroup(
            title: 'PREFERENCES',
            children: [
              DropdownSetting(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Default Export Format',
                value: _exportFormat,
                options: const [
                  'Portable Document Format (.pdf)',
                  'Word Document (.docx)',
                  'Plain Text (.txt)',
                ],
                onChanged: (v) => _updateSettings(v!, _includeTimestamps),
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              ToggleSetting(
                icon: Icons.access_time_outlined,
                title: 'Include timestamps',
                subtitle: 'Add time data to exported files',
                value: _includeTimestamps,
                onChanged: (v) => _updateSettings(_exportFormat, v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsGroup(
            title: 'EXISTING MEMBERS',
            children: [
              SettingsRow(
                icon: Icons.group_outlined,
                title: 'Existing Members',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembersScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsGroup(
            title: 'ACCOUNT',
            children: [
              SettingsRow(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
              Divider(height: 1, color: Colors.grey.shade100),
              SettingsRow(icon: Icons.shield_outlined, title: 'Privacy & Security', onTap: () {}),
              Divider(height: 1, color: Colors.grey.shade100),
              SettingsRow(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(children: [
              Text('Version 2.4.0 (Build 892)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              const SizedBox(height: 4),
              Text('© 2024 NexaStream Systems',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ]),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
