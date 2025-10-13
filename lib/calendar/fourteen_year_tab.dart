import 'package:flutter/material.dart';
import 'year_page.dart';

class FourteenYearTab extends StatelessWidget {
  const FourteenYearTab({super.key});

  @override
  Widget build(BuildContext context) {
  // inclusive range 2017..2031 to cover Sep 2017 through Jul 2031
  final years = List<int>.generate(2031 - 2017 + 1, (i) => 2017 + i);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('14 Year Calendar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final y = years[index];
                  return Card(
                    child: ListTile(
                      title: Text('$y'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => YearPage(year: y)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
