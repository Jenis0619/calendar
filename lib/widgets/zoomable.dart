import 'package:flutter/material.dart';

/// A lightweight pinch-to-zoom wrapper that scales its [child].
///
/// Uses gesture-based scaling (via GestureDetector) instead of
/// InteractiveViewer to avoid interfering with single-finger scrolls
/// inside child widgets. Works on mobile (Android/iOS) and desktop.
class Zoomable extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;

  const Zoomable({
    super.key,
    required this.child,
    this.minScale = 0.7,
    this.maxScale = 3.0,
  });

  @override
  State<Zoomable> createState() => _ZoomableState();
}

class _ZoomableState extends State<Zoomable> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    // On web, desktop or when a mouse is present, pinch gestures are less common.
    // We still enable the feature everywhere, but it only reacts to multi-touch scale gestures.
    return GestureDetector(
      onScaleStart: (details) {
        _baseScale = _scale;
      },
      onScaleUpdate: (details) {
        // Only update when a real scale gesture occurs.
        if (details.scale != 1.0) {
          double next = (_baseScale * details.scale).clamp(widget.minScale, widget.maxScale);
          setState(() => _scale = next);
        }
      },
      onScaleEnd: (details) {
        // When scale ends, keep the current scale (user may continue scrolling the content).
        _baseScale = _scale;
      },
      child: Transform.scale(
        scale: _scale,
        alignment: Alignment.topCenter,
        child: widget.child,
      ),
    );
  }
}
