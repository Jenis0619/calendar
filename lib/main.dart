import 'package:flutter/material.dart';
import 'dial/dial_widget.dart';
import 'video/video_tab.dart';
import 'calendar/fourteen_year_tab.dart';
import 'calendar/calendar_tab.dart';
import 'tabs/houses_tab.dart';
import 'tabs/special_day_tab.dart';
import 'dial/top_tab_buttons.dart';

void main() => runApp(const FourWatchesApp());

class FourWatchesApp extends StatelessWidget {
  const FourWatchesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4 Watches of the Night',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
        ),
        colorScheme: ThemeData.dark()
            .colorScheme
            .copyWith(surface: const Color(0xFF000000)),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _ctrl;

  @override
  void initState() {
    super.initState();
  // length 6: 0=Home,1=About,2=DailyCalendar,3=14Year,4=Houses,5=SpecialDay
  _ctrl = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4 Watches of the Night'),
      ),
      body: Column(
        children: [
          // pinned circular top buttons that navigate the TabController
          TopTabButtons(onSelectTab: (i) => _ctrl.animateTo(i), size: 84),
          Expanded(
            child: TabBarView(
              controller: _ctrl,
              children: [
                // Tab 0: Home / Dial
                DialWidget(onSelectTab: (i) => _ctrl.animateTo(i)),
                // Tab 1: About / Video
                VideoTab(onSelectTab: (i) => _ctrl.animateTo(i)),
                // Tab 2: Daily Calendar (CalendarTab)
                CalendarTab(onSelectTab: (i) => _ctrl.animateTo(i)),
                // Tab 3: 14-year calendar
                const FourteenYearTab(),
                // Tab 4: Houses list
                const HousesTab(),
                // Tab 5: Special Day 666 page
                const SpecialDayTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}