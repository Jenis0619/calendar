import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoTab extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;
  const VideoTab({super.key, this.onSelectTab});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  late VideoPlayerController _c;

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.asset('assets/document_5104995821628164098.mp4')
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: _c.value.aspectRatio,
              child: VideoPlayer(_c),
            ),
          ),
        ),
      ],
    );
  }
}