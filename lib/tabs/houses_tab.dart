import 'package:flutter/material.dart';

class HousesTab extends StatelessWidget {
  const HousesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Build a simple list of 48 houses with date spans starting from epoch
    final epoch = DateTime(2017, 9, 23);
    const daysPerHouse = 105;
    final items = List.generate(48, (i) {
      final start = epoch.add(Duration(days: i * daysPerHouse));
      final end = start.add(Duration(days: daysPerHouse - 1));
      return MapEntry(i + 1, Tuple(start, end));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('48 Houses')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 12, color: Colors.white12),
        itemBuilder: (context, idx) {
          final house = items[idx];
          final number = house.key;
          final range = house.value;
          return ListTile(
            tileColor: Colors.white,
            title: Text('House $number', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${_fmt(range.start)} — ${_fmt(range.end)}'),
          );
        },
      ),
    );
  }
}

class Tuple {
  final DateTime start;
  final DateTime end;
  Tuple(this.start, this.end);
}

String _fmt(DateTime d) {
  return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
