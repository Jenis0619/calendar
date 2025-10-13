import 'package:flutter/material.dart';

class SpecialDayTab extends StatelessWidget {
  const SpecialDayTab({super.key});

  @override
  Widget build(BuildContext context) {
    const quote = '''
Day 666 — The Great Sign

"When he opened the sixth seal, I looked, and behold, there was a great earthquake..."

(Revelation 6:12-17, selected)

Note: This is a textual page with quoted scripture as requested.
''';

    return Scaffold(
      appBar: AppBar(title: const Text('Day 666')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(quote, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}
