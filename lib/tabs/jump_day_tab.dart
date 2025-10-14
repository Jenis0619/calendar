import 'package:flutter/material.dart';

class JumpDayTab extends StatefulWidget {
  const JumpDayTab({super.key});

  @override
  State<JumpDayTab> createState() => _JumpDayTabState();
}

class _JumpDayTabState extends State<JumpDayTab> {
  final _controller = TextEditingController();
  String? _error;
  int? _resultDay;

  void _go() {
    final text = _controller.text.trim();
    final n = int.tryParse(text);
    if (n == null || n < 1 || n > 5040) {
      setState(() => _error = 'Enter a number between 1 and 5040');
      return;
    }
    setState(() {
      _error = null;
      _resultDay = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jump To Day')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter day number (1..5040) to jump to that day in the 14-year calendar', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '1',
                hintStyle: const TextStyle(color: Colors.white38),
                errorText: _error,
                filled: true,
                fillColor: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _go, child: const Text('Go')),
            const SizedBox(height: 18),
            if (_resultDay != null) _buildResult(_resultDay!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(int n) {
    final epoch = DateTime(2017, 9, 23);
    final dt = epoch.add(Duration(days: n - 1));
    final houseIndex = (n - 1) ~/ 105 + 1; // house number 1..48
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Day $n', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Date: ${_fmt(dt)}', style: const TextStyle(color: Colors.white70)),
        Text('House: $houseIndex', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
