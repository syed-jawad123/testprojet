import 'package:flutter/material.dart';

class ExportMinutesSheet extends StatefulWidget {
  final String defaultFormat;
  final bool defaultTimestamps;

  const ExportMinutesSheet({
    super.key,
    this.defaultFormat = 'Portable Document Format (.pdf)',
    this.defaultTimestamps = true,
  });

  @override
  State<ExportMinutesSheet> createState() => _ExportMinutesSheetState();
}

class _ExportMinutesSheetState extends State<ExportMinutesSheet> {
  late int _selectedFormat;
  late bool _includeTimestamps;
  bool _includeSummary = false;

  @override
  void initState() {
    super.initState();
    _includeTimestamps = widget.defaultTimestamps;
    // Map format string to index
    if (widget.defaultFormat.contains('pdf')) {
      _selectedFormat = 0;
    } else if (widget.defaultFormat.contains('txt')) {
      _selectedFormat = 1;
    } else {
      _selectedFormat = 2;
    }
  }

  final List<Map<String, dynamic>> _formats = [
    {'label': 'PDF Document', 'icon': Icons.picture_as_pdf_outlined},
    {'label': 'Plain Text (TXT)', 'icon': Icons.text_snippet_outlined},
    {'label': 'Word Document (DOCX)', 'icon': Icons.description_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF0EEE8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 22, color: Colors.black87),
            ),
            const Expanded(
              child: Center(
                child: Text('Export Minutes',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 22),
          ]),
          const SizedBox(height: 24),

          // SELECT FORMAT
          const Text('SELECT FORMAT',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: Colors.grey, letterSpacing: 1.1)),
          const SizedBox(height: 12),

          ..._formats.asMap().entries.map((e) => GestureDetector(
            onTap: () => setState(() => _selectedFormat = e.key),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(e.value['icon'] as IconData,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(e.value['label'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedFormat == e.key
                          ? Colors.black
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: _selectedFormat == e.key
                      ? Center(
                          child: Container(
                            width: 10, height: 10,
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                        )
                      : null,
                ),
              ]),
            ),
          )),
          const SizedBox(height: 16),

          // EXPORT OPTIONS
          const Text('EXPORT OPTIONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: Colors.grey, letterSpacing: 1.1)),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              _optionRow('Include timestamps', _includeTimestamps,
                  (v) => setState(() => _includeTimestamps = v)),
              Divider(height: 1, color: Colors.grey.shade100),
              _optionRow('Include short summary', _includeSummary,
                  (v) => setState(() => _includeSummary = v)),
            ]),
          ),
          const SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Confirm Export',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _optionRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: value ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: value ? Colors.black : Colors.grey.shade400,
                  width: 2),
            ),
            child: value
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : null,
          ),
        ),
      ]),
    );
  }
}
