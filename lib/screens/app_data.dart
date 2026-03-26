import 'dart:typed_data';

// Shared global members list used across the app
final List<Map<String, dynamic>> existingMembers = [
  {
    'name': 'Zain Khan',
    'role': 'Product Manager',
    'initials': 'ZK',
    'seconds': '45',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'Syed Jawad',
    'role': 'UX Designer',
    'initials': 'SJ',
    'seconds': '38',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'ALI',
    'role': 'Software Engineer',
    'initials': 'Al',
    'seconds': '52',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'Muhammad Bilal',
    'role': 'QA Engineer',
    'initials': 'MB',
    'seconds': '29',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'Danish',
    'role': 'Full Stack Developer',
    'initials': 'DH',
    'seconds': '41',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'Umer',
    'role': 'Creative Director',
    'initials': 'UM',
    'seconds': '35',
    'selected': false,
    'imageBytes': null,
  },
  {
    'name': 'Ayesha',
    'role': 'DevOps Specialist',
    'initials': 'AH',
    'seconds': '48',
    'selected': false,
    'imageBytes': null,
  },
];

// Registered users store
final List<Map<String, String>> registeredUsers = [];

// Register new user
void registerUser(String name, String email, String password) {
  registeredUsers.add({
    'name': name,
    'email': email,
    'password': password,
  });
}

// Login - returns user map if found, null if not
Map<String, String>? loginUser(String email, String password) {
  try {
    return registeredUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
    );
  } catch (_) {
    return null;
  }
}

// Shared upcoming meetings list — icon: null (IconData String nahi)
final List<Map<String, dynamic>> upcomingMeetings = [
  {
    'title': 'Design Sync',
    'date': 'Oct 12, 2023',
    'duration': '45 mins',
    'color': null,
    'icon': null,
    'members': [],
  },
  {
    'title': 'Weekly Standup',
    'date': 'Oct 13, 2023',
    'duration': '15 mins',
    'color': 'orange',
    'icon': null,
    'members': [],
  },
  {
    'title': 'Client Workshop',
    'date': 'Oct 15, 2023',
    'duration': '2 hours',
    'color': 'teal',
    'icon': null,
    'members': [],
  },
];

// Shared archive meetings list
final List<Map<String, dynamic>> archivedMeetings = [
  {
    'title': 'Project Sync: Alpha Launch',
    'displayDate': 'Oct 12, 2023',
    'date': '2023-10-12',
    'duration': '45 mins',
    'startTime': '10:00',
    'extraCount': 4,
  },
  {
    'title': 'Design Review: Mobile UI',
    'displayDate': 'Oct 10, 2023',
    'date': '2023-10-10',
    'duration': '1 hr 15 mins',
    'startTime': '11:00',
    'extraCount': 0,
  },
  {
    'title': 'Stakeholder Weekly',
    'displayDate': 'Sep 28, 2023',
    'date': '2023-09-28',
    'duration': '30 mins',
    'startTime': '09:00',
    'extraCount': 0,
  },
];

// Move meeting to archive after completion
void archiveMeeting(Map<String, dynamic> meeting) {
  final now = DateTime.now();
  archivedMeetings.insert(0, {
    'title': meeting['title'],
    'displayDate':
        '${now.day.toString().padLeft(2, '0')} ${_monthShort(now.month)} ${now.year}',
    'date':
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    'duration': meeting['duration'] ?? '—',
    'startTime':
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    'extraCount': 0,
  });
}

String _monthShort(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}
