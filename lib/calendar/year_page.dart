import 'package:flutter/material.dart';
import 'month_view.dart';

class YearPage extends StatelessWidget {
  final int year;
  const YearPage({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
  int startMonth = 1;
  int endMonth = 12;
  if (year == 2017) startMonth = 9; // start Sep 2017
  if (year == 2031) endMonth = 7; // end Jul 2031
  final months = [for (var m = startMonth; m <= endMonth; m++) m];
    return Scaffold(
      appBar: AppBar(title: Text('$year')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: months.map((m) => GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MonthView(year: year, month: m))),
            child: Card(
              child: Center(child: Text(_monthName(m), style: const TextStyle(fontWeight: FontWeight.bold))),
            ),
          )).toList(),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m-1];
  }
}
