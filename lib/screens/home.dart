import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer _timer;
  final VideoPlayerController _controller =
      VideoPlayerController.asset('assets/SkateVideo.mp4')
        ..initialize()
        ..setLooping(true)
        ..play();

  double _opacityValue = 0.0;

  @override
  void initState() {
    _timer = Timer.periodic(Durations.medium2, (timer) => setState(() {}));
    super.initState();
  }

  void _seekForward(Duration offset) {
    var current = _controller.value.position;
    var target = current + offset;
    _controller.seekTo(target);
  }

  void _seekBackward(Duration offset) {
    var current = _controller.value.position;
    var target = current - offset;
    _controller.seekTo(target >= Duration.zero ? target : Duration.zero);
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
            Positioned.fill(child: VideoPlayer(_controller)),
            AnimatedOpacity(
              opacity: _opacityValue,
              duration: Durations.long2,
              child: Stack(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 45,top: 65),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/openSkating_Profile_img.jpg',
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 135, top: 75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hosein Javid ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '@hoseinDJ ',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                        bottom: 32,
                        right: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'stake riding with dus',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            'saturday',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 12),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.white,
                              backgroundColor: Colors.white10,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _controller.value.position.toMinutesSeconds(),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                _controller.value.duration.toMinutesSeconds(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _seekBackward(Durations.short4),
                                icon: Icon(
                                  CupertinoIcons.backward_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
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
                                icon: Icon(
                                  CupertinoIcons.forward_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}

extension DurationExtention on Duration {
  String _toTwoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  String toMinutesSeconds() {
    String toDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String toDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "$toDigitMinutes:$toDigitSeconds";
  }
}
