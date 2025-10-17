import 'package:flutter/material.dart';
import 'year_page.dart';
import '../bridges/app_bridge.dart';
import 'month_view.dart';

class FourteenYearTab extends StatefulWidget {
  const FourteenYearTab({super.key});

  @override
  State<FourteenYearTab> createState() => _FourteenYearTabState();
}

class _FourteenYearTabState extends State<FourteenYearTab> {
  int? activeYear;
  int? activeMonth;
  int? activeHighlight;
  DateTime? activeRangeStart;
  DateTime? activeRangeEnd;

  late final VoidCallback listener = () {
    final nav = AppBridge.fourteen;
    if (nav.year != null && nav.month != null) {
      setState(() {
        activeYear = nav.year;
        activeMonth = nav.month;
        activeHighlight = nav.highlightDay;
        activeRangeStart = nav.rangeStart;
        activeRangeEnd = nav.rangeEnd;
      });
      nav.clear();
    }
  };

  @override
  void initState() {
    super.initState();
    AppBridge.fourteen.addListener(listener);
  }

  @override
  void dispose() {
    AppBridge.fourteen.removeListener(listener);
    super.dispose();
  }

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
              child: activeYear != null && activeMonth != null
                  ? Column(
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: () { setState(() { activeYear = null; activeMonth = null; activeHighlight = null; activeRangeStart = null; activeRangeEnd = null; }); }, icon: const Icon(Icons.arrow_back)),
                            Text('$activeYear', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Expanded(child: MonthView(year: activeYear!, month: activeMonth!, highlightDay: activeHighlight, rangeStart: activeRangeStart, rangeEnd: activeRangeEnd)),
                      ],
                    )
                  : ListView.builder(
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
