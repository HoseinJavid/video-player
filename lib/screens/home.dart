import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VideoPlayerController _controller;
  double _opacityValue = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/SkateVideo.mp4')
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..setLooping(true);

    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  void _seekForward(Duration offset) {
    final duration = _controller.value.duration;
    final current = _controller.value.position;
    final target = current + offset;

    _controller.seekTo(target < duration ? target : duration);
  }

  void _seekBackward(Duration offset) {
    final current = _controller.value.position;
    final target = current - offset;

    _controller.seekTo(target > Duration.zero ? target : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => setState(() {
          _opacityValue = _opacityValue == 0.0 ? 1.0 : 0.0;
        }),
        child: Stack(
          children: [
            Positioned.fill(
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const SizedBox(),
            ),
            AnimatedOpacity(
              opacity: _opacityValue,
              duration: Durations.long2,
              child: Stack(
                children: [
                  _backgroundGradient(),
                  _topProfile(),
                  _bottomControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundGradient() => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
        ],
      );

  Widget _topProfile() => Padding(
        padding: const EdgeInsets.only(left: 45, top: 65),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/openSkating_Profile_img.jpg',
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // SizedBox(height: 10,),
                Text('Hosein Javid', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('@hoseinDJ', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ],
        ),
      );

  Widget _bottomControls() => Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, bottom: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('skate riding with dus', style: TextStyle(color: Colors.white, fontSize: 18)),
              const Text('saturday', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  backgroundColor: Colors.white10,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_controller.value.position.toMinutesSeconds(),
                      style: const TextStyle(color: Colors.white)),
                  Text(_controller.value.duration.toMinutesSeconds(),
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _seekBackward(Durations.short4),
                    icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? CupertinoIcons.pause_circle_fill
                          : CupertinoIcons.play_circle_fill,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _seekForward(Durations.short4),
                    icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension DurationExtention on Duration {
  String _toTwoDigits(int n) => n.toString().padLeft(2, '0');

  String toMinutesSeconds() =>
      "${_toTwoDigits(inMinutes.remainder(60))}:${_toTwoDigits(inSeconds.remainder(60))}";
}
