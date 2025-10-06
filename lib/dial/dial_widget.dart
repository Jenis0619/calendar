import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Single clean implementation of the dial widget.
class DialWidget extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;
  const DialWidget({Key? key, this.onSelectTab}) : super(key: key);

  @override
  State<DialWidget> createState() => _DialWidgetState();
}

class _DialWidgetState extends State<DialWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
        ..repeat();

  late final Animation<double> _pulse =
      Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(
          parent: _ctrl, curve: Curves.easeInOut));

  late Timer _timer;

  static const totalSegments = 48;
  static const daysPerSegment = 105;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _timer.cancel();
    super.dispose();
  }

  List<int> _calc() {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final epoch = DateTime(2017, 9, 23);
    final days = today.difference(epoch).inDays;
    final seg = (days ~/ daysPerSegment) % totalSegments; // 0-47
    final watch = seg ~/ 12 + 1; // 1-4
    final house = seg + 1; // 1-48
    return [seg, watch, house, days];
  }

  @override
  Widget build(BuildContext context) {
    final vals = _calc();
    final seg = vals[0];
    final watch = vals[1];
    final house = vals[2];
    final days = vals[3];

    final mq = MediaQuery.of(context).size;
    // convert requested cm adjustments to logical pixels.
    // Assumption: 1 cm ≈ 37.8 logical pixels (based on 96 DPI). This is a reasonable
    // approximation for layout tweaks; on different devices the visual size may vary.
    final pxPerCm = 37.8;

    // increase the dial size by ~1 cm and lower it by ~1.5 cm
    final dialSize = math.min(mq.width, mq.height) * 0.68 + pxPerCm * 1.0;

    final topSpacing = 28.0 + pxPerCm * 1.5; // previous top was 28, add 1.5 cm (~57 px)

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: topSpacing),
            Center(
              child: SizedBox(
                width: dialSize,
                height: dialSize,
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => CustomPaint(
                    painter: _DialPainter(seg, watch, house, _pulse.value),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 28,
          child: _infoPanel(days, watch, house),
        ),
      ],
    );
  }

  Widget _infoPanel(int days, int watch, int house) {
    final now = DateTime.now().toLocal();
    final month = _monthName(now.month).toUpperCase();
    final dateLine = '$month ${now.day}, ${now.year}';

    String ordinalLabel(int n) {
      final s = n.toString();
      final mod100 = n % 100;
      if (mod100 >= 11 && mod100 <= 13) return '${s}TH';
      switch (n % 10) {
        case 1:
          return '${s}ST';
        case 2:
          return '${s}ND';
        case 3:
          return '${s}RD';
        default:
          return '${s}TH';
      }
    }

    final watchLine = '${ordinalLabel(watch)} WATCH';
    final houseLine = '${ordinalLabel(house)} HOUSE';

    final cycleLength = daysPerSegment * 12; // 1260
    final cycleDay = (days % cycleLength) + 1;
    final segDay = (days % daysPerSegment) + 1;

    final dayCycleLine = 'Day $cycleDay of $cycleLength';
    final daySegLine = 'Day $segDay of $daysPerSegment';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dateLine.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(watchLine,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          Text(houseLine,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(dayCycleLine, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Text(daySegLine, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[(m - 1).clamp(0, 11).toInt()];
  }
}

class _DialPainter extends CustomPainter {
  final int currentSeg;
  final int currentWatch;
  final int currentHouse;
  final double pulse;

  const _DialPainter(this.currentSeg, this.currentWatch, this.currentHouse, this.pulse);

  static const total = 48;
  static const degPer = 360 / total;
  static const startOffset = 90.0; // 6 o'clock baseline

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    const inR = 340.0;
    const outR = 400.0;
    final scale = radius / 450;

  // no background rectangle: leave transparent so the clock blends with UI

    final ringPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3 * scale
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, outR * scale, ringPaint);
    canvas.drawCircle(center, inR * scale, ringPaint);

    // draw crossbars (to split into 4 quadrants like the reference)
    final bar = Paint()
      ..color = Colors.white
      ..strokeWidth = 8 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(center - Offset(0, inR * scale), center + Offset(0, inR * scale), bar);
    canvas.drawLine(center - Offset(inR * scale, 0), center + Offset(inR * scale, 0), bar);

    for (int i = 0; i < total; i++) {
      final a1 = (i * degPer + startOffset) * math.pi / 180;
      final a2 = ((i + 1) * degPer + startOffset) * math.pi / 180;

      final p1 = center + Offset(inR * scale * math.cos(a1), inR * scale * math.sin(a1));
      final p2 = center + Offset(outR * scale * math.cos(a1), outR * scale * math.sin(a1));
      final p4 = center + Offset(inR * scale * math.cos(a2), inR * scale * math.sin(a2));

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: outR * scale), a1, degPer * math.pi / 180, false)
        ..lineTo(p4.dx, p4.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: inR * scale), a2, -degPer * math.pi / 180, false)
        ..close();

      final isActive = i == currentSeg;
      final fill = Paint()
        ..color = isActive ? Colors.red.withOpacity(0.5 + 0.5 * math.sin(pulse * math.pi)) : Colors.white
        ..style = PaintingStyle.fill;
      final border = Paint()
        ..color = isActive ? Colors.red : Colors.black
        ..strokeWidth = 4 * scale
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, fill);
      canvas.drawPath(path, border);

      // inner small numbers
      final labelAngle = (a1 + a2) / 2;
      final labelRadius = (inR + 25) * scale;
      final labelOffset = center + Offset(labelRadius * math.cos(labelAngle), labelRadius * math.sin(labelAngle));
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            color: isActive ? Colors.red : const Color(0xff555555),
            fontSize: 13 * scale,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, labelOffset - Offset(tp.width / 2, tp.height / 2));
    }

    // Big quadrant numbers: map to requested positions
    // Big quadrant numbers: placed centered within each quadrant and closer to center
    final bigStyleBase = TextStyle(
      color: const Color(0xffbbbbbb),
      fontSize: 120 * scale,
      fontWeight: FontWeight.w900,
    );
  // screen coordinates: 0deg = right, 90deg = down. We want:
  // 2 = top-left (225), 3 = top-right (315), 1 = bottom-left (135), 4 = bottom-right (45)
  final quadAngles = {1: 135.0, 2: 225.0, 3: 315.0, 4: 45.0};
    for (final quad in quadAngles.keys) {
      final angle = quadAngles[quad]!;
      // compute angle in radians relative to center (no extra startOffset here)
      final a = angle * math.pi / 180;
      // position them closer to center: 40% of outer radius
      final rpos = outR * 0.4 * scale;
      final p = center + Offset(rpos * math.cos(a), rpos * math.sin(a));

      final style = bigStyleBase.copyWith(
        color: quad == currentWatch ? Colors.red : const Color(0xffbbbbbb),
        fontSize: 140 * scale,
      );

      final tp = TextPainter(
        text: TextSpan(text: '$quad', style: style),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.currentSeg != currentSeg || old.pulse != pulse || old.currentWatch != currentWatch;
}