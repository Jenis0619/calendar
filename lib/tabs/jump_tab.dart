import 'package:flutter/material.dart';

class JumpTab extends StatefulWidget {
  const JumpTab({super.key});

  @override
  State<JumpTab> createState() => _JumpTabState();
}

class _JumpTabState extends State<JumpTab> {
  final _houseController = TextEditingController();
  final _dayController = TextEditingController();
  String? _errorHouse;
  String? _errorDay;
  int? _houseResult;
  int? _dayResult;

  void _goHouse() {
    final n = int.tryParse(_houseController.text.trim());
    if (n == null || n < 1 || n > 48) {
      setState(() => _errorHouse = 'Enter 1..48');
      return;
    }
    setState(() {
      _errorHouse = null;
      _houseResult = n;
      _dayResult = null;
    });
  }

  void _goDay() {
    final n = int.tryParse(_dayController.text.trim());
    if (n == null || n < 1 || n > 5040) {
      setState(() => _errorDay = 'Enter 1..5040');
      return;
    }
    setState(() {
      _errorDay = null;
      _dayResult = n;
      _houseResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jump')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jump to a House (1..48) or a Day (1..5040)', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('House', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _houseController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '1',
                          hintStyle: const TextStyle(color: Colors.white30),
                          errorText: _errorHouse,
                          filled: true,
                          fillColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _goHouse, child: const Text('Go House')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Day', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _dayController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '1',
                          hintStyle: const TextStyle(color: Colors.white30),
                          errorText: _errorDay,
                          filled: true,
                          fillColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _goDay, child: const Text('Go Day')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_houseResult != null) _buildHouseResult(_houseResult!),
            if (_dayResult != null) _buildDayResult(_dayResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseResult(int n) {
    final epoch = DateTime(2017, 9, 23);
    final daysPerHouse = 105;
    final start = epoch.add(Duration(days: (n - 1) * daysPerHouse));
    final end = start.add(Duration(days: daysPerHouse - 1));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('House $n', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Start: ${_fmt(start)}', style: const TextStyle(color: Colors.white70)),
        Text('End:   ${_fmt(end)}', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildDayResult(int n) {
    final epoch = DateTime(2017, 9, 23);
    final dt = epoch.add(Duration(days: n - 1));
    final houseIndex = (n - 1) ~/ 105 + 1; // house number 1..48
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Day $n', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Date: ${_fmt(dt)}', style: const TextStyle(color: Colors.white70)),
        Text('House: $houseIndex', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
