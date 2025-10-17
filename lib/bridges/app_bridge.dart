import 'package:flutter/material.dart';

class FourteenNavigator extends ChangeNotifier {
  int? year;
  int? month;
  int? highlightDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  void openMonth(int y, int m, {int? highlightDay, DateTime? rangeStart, DateTime? rangeEnd}) {
    year = y;
    month = m;
    this.highlightDay = highlightDay;
    this.rangeStart = rangeStart;
    this.rangeEnd = rangeEnd;
    notifyListeners();
  }

  void clear() {
    year = null;
    month = null;
    highlightDay = null;
    rangeStart = null;
    rangeEnd = null;
  }
}

class AppBridge {
  static TabController? tabController;
  static final FourteenNavigator fourteen = FourteenNavigator();
}
