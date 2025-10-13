import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final int year;
  final int month;
  const MonthView({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    // Mockup month view inspired by the user's attachment. We'll render a simple
    // month grid with day numbers and the two small lines for "Day X of 1260" and "Day Y of 105".

    final first = DateTime(year, month, 1);
    // Find the Sunday that begins the 6x7 grid
    final startGrid = first.subtract(Duration(days: (first.weekday % 7)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('${_monthName(month)} $year')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Column(
          children: [
            // big year label (green, large) - constrained so it never pushes layout off-screen
            Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(builder: (c, constraints) {
                final mq = MediaQuery.of(context).size;
                // limit the year header height to a fraction of screen height
                final maxYearHeight = (mq.height * 0.18).clamp(48.0, 140.0);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxYearHeight),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text('$year', style: TextStyle(fontSize: 140, color: Colors.green[800], fontWeight: FontWeight.bold)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: LayoutBuilder(builder: (c, constraints) {
                final mq = MediaQuery.of(context).size;
                final monthFont = (mq.width * 0.06).clamp(14.0, 36.0);
                return Text(_monthNameFull(month), style: TextStyle(fontSize: monthFont, color: Colors.green[800], fontWeight: FontWeight.w600));
              }),
            ),
            const SizedBox(height: 12),
            // weekday header
            Container(
              color: Colors.green[900],
              child: Row(
                children: List.generate(7, (i) {
                  final labels = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(child: Text(labels[i], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.6, // taller cells
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                padding: EdgeInsets.zero,
                itemCount: 42,
                itemBuilder: (context, idx) {
                  final cellDate = startGrid.add(Duration(days: idx));
                  final inMonth = cellDate.month == month && cellDate.year == year;
                  if (!inMonth) {
                    // empty bordered cell for days outside the month
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                      ),
                    );
                  }
                  final dt = cellDate;
                  final epoch = DateTime(2017, 9, 23);
                  final dayOffset = dt.difference(epoch).inDays;
                  final dayOfCycle = (dayOffset % 1260) + 1;
                  final dayOfSegment = (dayOffset % 105) + 1;

                  // highlight Sunday and Saturday columns with pale green background
                  final col = (idx % 7);
                  final cellBg = (col == 0 || col == 6) ? Colors.green[50] : Colors.white;

                  // non-editable month view: show static calendar cells only
                  return Container(
                    decoration: BoxDecoration(
                      color: cellBg,
                      border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                    ),
                    child: LayoutBuilder(
                      builder: (context, cellConstraints) {
                        // responsive font sizes based on available cell height
                        final h = cellConstraints.maxHeight;
                          final dayFont = (h * 0.28).clamp(10.0, 44.0); // slightly smaller to avoid overflow
                          // reduce small label sizing and allow it to scale down to fit width
                          final smallFont = (h * 0.04).clamp(6.0, 9.0);
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // date number centered and near top
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('${dt.day}', style: TextStyle(fontSize: dayFont, fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                                // spacer pushes the small labels to the bottom of the cell
                                const Expanded(child: SizedBox()),
                                // bottom-aligned small cycle labels: wrap with FittedBox so they scale to available width
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('Day $dayOfCycle of 1260', style: TextStyle(fontSize: smallFont, color: Colors.black)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('Day $dayOfSegment of 105', style: TextStyle(fontSize: smallFont, color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                                // no editing or note icons in 14-year month view
                              ],
                            ),
                          );
                      },
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

  String _monthName(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m-1];
  }

  String _monthNameFull(int m) {
    const names = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return names[m-1];
  }
}
