import 'package:flutter/material.dart';

class JumpHouseTab extends StatefulWidget {
  const JumpHouseTab({super.key});

  @override
  State<JumpHouseTab> createState() => _JumpHouseTabState();
}

class _JumpHouseTabState extends State<JumpHouseTab> {
  final _controller = TextEditingController();
  String? _error;
  int? _resultHouse;

  void _go() {
    final text = _controller.text.trim();
    final n = int.tryParse(text);
    if (n == null || n < 1 || n > 48) {
      setState(() => _error = 'Enter a number between 1 and 48');
      return;
    }
    setState(() {
      _error = null;
      _resultHouse = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jump To House')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter house number (1..48) to view its 105-day span', style: TextStyle(color: Colors.white)),
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
            if (_resultHouse != null) _buildResult(_resultHouse!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(int n) {
    final epoch = DateTime(2017, 9, 23);
    final daysPerHouse = 105;
    final start = epoch.add(Duration(days: (n - 1) * daysPerHouse));
  final end = start.add(Duration(days: daysPerHouse - 1));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('House $n', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Start: ${_fmt(start)}', style: const TextStyle(color: Colors.white70)),
        Text('End:   ${_fmt(end)}', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
