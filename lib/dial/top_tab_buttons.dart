import 'package:flutter/material.dart';

class TopTabButtons extends StatelessWidget {
  final ValueChanged<int>? onSelectTab;
  final double size;
  const TopTabButtons({super.key, this.onSelectTab, this.size = 110});

  @override
  Widget build(BuildContext context) {
    Widget circle(String text, int tabIndex) {
      return GestureDetector(
        onTap: () => onSelectTab?.call(tabIndex),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF5F8CFF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2)],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // left: Daily Calendar -> Calendar tab (index 2)
          circle('Daily\nCalendar', 2),
          // middle: 14 Year Calendar -> FourteenYear tab (index 3)
          circle('14 Year\nCalendar', 3),
          // right: About Four Watches -> About tab (index 1)
          circle('About\nFour\nWatches', 1),
        ],
      ),
    );
  }
}
