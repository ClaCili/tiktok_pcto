import 'package:flutter/material.dart';
import 'package:tiktok_pcto/video.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Video> videos = [
    Video(
      id: "1",
      likes: 23,
      comments: 234,
      author: "Messi",
      description: "ronaldo L",
      videoURL: "assets/videos/Download.mp4",
    ),
    Video(
      id: "2",
      likes: 55,
      comments: 120,
      author: "Ronaldo",
      description: "siuum",
      videoURL: "assets/videos/Download.mp4",
    ),
    Video(
      id: "3",
      likes: 99,
      comments: 10,
      author: "Neymar",
      description: "ciao",
      videoURL: "assets/videos/Download.mp4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return _VideoPage(video: videos[index]);
        },
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  final Video video;
  const _VideoPage({required this.video});

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video.videoURL);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller
        ..setLooping(true)
        ..play();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(
            color: Colors.black,
            child: FutureBuilder<void>(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Seguiti',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(width: 20),
              Text(
                'Per te',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.video.author,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.video.description,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    widget.video.description,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          right: 12,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.favorite, color: Colors.white, size: 36),
              const SizedBox(height: 4),
              Text(
                '${widget.video.likes}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.comment_rounded, color: Colors.white, size: 36),
              const SizedBox(height: 4),
              Text(
                '${widget.video.comments}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.reply, color: Colors.white, size: 36),
              const SizedBox(height: 16),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
