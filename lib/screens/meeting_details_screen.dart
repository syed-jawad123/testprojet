import 'package:flutter/material.dart';
import '../components/black_button.dart';
import '../components/participant_summary_card.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String startTime;
  final String duration;

  const MeetingDetailsScreen({
    super.key,
    this.title = 'Q4 Strategy Planning Session',
    this.date = '05/04/2026',
    this.startTime = '10:00',
    this.duration = '01 Hours',
  });

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                const Text('Meeting Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 24),

              // Heading
              const Text('Meeting Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),

              // Meeting Title
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('MEETING TITLE',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1.1)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(title,
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              ]),
              const SizedBox(height: 16),

              // Date
              _readOnlyField('Date:', date),
              const SizedBox(height: 16),

              // Start Time + Duration
              Row(children: [
                Expanded(child: _readOnlyField('Start Time:', startTime)),
                const SizedBox(width: 16),
                Expanded(child: _readOnlyField('Duration:', duration)),
              ]),
              const SizedBox(height: 24),

              // Participants Summary
              const Text('PARTICIPANTS SUMMARY',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 1.1)),
              const SizedBox(height: 12),

              Row(children: [
                // Existing Members Card
                ParticipantSummaryCard(
                  count: '4',
                  label: 'EXISTING\nMEMBERS',
                  bottom: Row(children: [
                    ...List.generate(3, (i) => Transform.translate(
                      offset: Offset(i * -8.0, 0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: [
                          Colors.brown.shade300,
                          Colors.blueGrey.shade300,
                          Colors.orange.shade300,
                        ][i],
                        child: const Icon(Icons.person, size: 14, color: Colors.white),
                      ),
                    )),
                    Transform.translate(
                      offset: const Offset(-24, 0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade400,
                        child: const Text('+1',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 12),

                // New Members Card
                ParticipantSummaryCard(
                  count: '2',
                  label: 'NEW MEMBERS',
                  bottom: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade300, style: BorderStyle.solid),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_add_outlined,
                          size: 16, color: Colors.grey.shade400),
                    ),
                    const SizedBox(width: 8),
                    Text('Pending ID',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                  ]),
                ),
              ]),
              const SizedBox(height: 32),

              // Confirm Button
              BlackButton(label: 'Confirm and Save Meeting', onPressed: () {}),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
