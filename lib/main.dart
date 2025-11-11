import 'package:flutter/material.dart';
import 'dial/dial_widget.dart';
import 'video/video_tab.dart';
import 'calendar/fourteen_year_tab.dart';
import 'calendar/calendar_tab.dart';
import 'tabs/houses_tab.dart';
import 'tabs/special_day_tab.dart';
import 'tabs/jump_tab.dart';
import 'tabs/shop_tab.dart';
import 'dial/top_tab_buttons.dart';
import 'bridges/app_bridge.dart';
import 'widgets/zoomable.dart';

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
  // length 8: 0=Home,1=About,2=DailyCalendar,3=14Year,4=Houses,5=SpecialDay,6=Jump,7=Shop
  _ctrl = TabController(length: 8, vsync: this);
  AppBridge.tabController = _ctrl;
  }

  @override
  void dispose() {
    AppBridge.tabController = null;
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
                Zoomable(child: DialWidget(onSelectTab: (i) => _ctrl.animateTo(i))),
                // Tab 1: About / Video
                Zoomable(child: VideoTab(onSelectTab: (i) => _ctrl.animateTo(i))),
                // Tab 2: Daily Calendar (CalendarTab)
                Zoomable(child: CalendarTab(onSelectTab: (i) => _ctrl.animateTo(i))),
                // Tab 3: 14-year calendar
                Zoomable(child: const FourteenYearTab()),
                // Tab 4: Houses list
                Zoomable(child: const HousesTab()),
                // Tab 5: Special Day 666 page
                Zoomable(child: const SpecialDayTab()),
                // Tab 6: Jump (House or Day)
                Zoomable(child: const JumpTab()),
                // Tab 7: Shop
                Zoomable(child: const ShopTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}