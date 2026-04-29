import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tiktok_pcto/chat.dart';
import 'package:tiktok_pcto/mock_data.dart';
import 'package:tiktok_pcto/video.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  final MockUser currentUser;
  final List<Video> videos;
  final List<ChatThread> threads;
  final VoidCallback onLogout;
  final ValueChanged<String> onToggleLike;
  final void Function(String videoId, String text) onAddComment;
  final void Function(String threadId, Video video) onSendVideoMessage;
  final ValueChanged<int> onSelectTab;

  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.videos,
    required this.threads,
    required this.onLogout,
    required this.onToggleLike,
    required this.onAddComment,
    required this.onSendVideoMessage,
    required this.onSelectTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.videos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final video = widget.videos[index];
              return _VideoPage(
                key: ValueKey('${video.id}-${video.commentsCount}-${video.likes}'),
                video: video,
                currentUser: widget.currentUser,
                isLiked: video.likedByUserIds.contains(widget.currentUser.id),
                onLike: () => widget.onToggleLike(video.id),
                onCommentsTap: () => _openCommentsSheet(context, video),
                onShareTap: () => _openShareSheet(context, video),
                onProfileTap: _openProfileSheet,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.32),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'For You',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.search, color: Colors.white, size: 30),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _currentIndex == 0 ? 'Contacts synced' : 'Watching locally',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavigation(
              currentUser: widget.currentUser,
              onProfileTap: _openProfileSheet,
              onSelectTab: widget.onSelectTab,
            ),
          ),
        ],
      ),
    );
  }

  void _openProfileSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF161616),
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFFFE2C55),
                  child: Text(
                    widget.currentUser.avatarEmoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.currentUser.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.currentUser.username,
                  style: const TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.currentUser.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProfileStat(label: 'Following', value: '${widget.currentUser.following}'),
                    _ProfileStat(label: 'Followers', value: '${widget.currentUser.followers}'),
                    _ProfileStat(label: 'Likes', value: '${widget.currentUser.likes}'),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onLogout();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Esci dalla sessione mock'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCommentsSheet(BuildContext context, Video video) async {
    final controller = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      showDragHandle: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        '${video.commentsCount} comments',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        video.author,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: video.comments.isEmpty
                      ? const Center(
                          child: Text(
                            'Nessun commento per ora.',
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: video.comments.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final comment = video.comments[index];
                            final user = MockData.userById(comment.userId);

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF232323),
                                  child: Text(
                                    user?.avatarEmoji ?? '🙂',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${comment.username}  •  ${comment.timeAgo}',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFFE2C55),
                        child: Text(
                          widget.currentUser.avatarEmoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Aggiungi un commento...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF1E1E1E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          if (controller.text.trim().isEmpty) {
                            return;
                          }
                          widget.onAddComment(video.id, controller.text);
                          Navigator.of(sheetContext).pop();
                        },
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF25F4EE)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openShareSheet(BuildContext context, Video video) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111111),
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Invia video a...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Seleziona una chat mockata per condividere il video.',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 18),
                ...widget.threads.map(
                  (thread) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () {
                        widget.onSendVideoMessage(thread.id, video);
                        Navigator.of(sheetContext).pop();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.white10),
                      ),
                      tileColor: const Color(0xFF1A1A1A),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF262626),
                        child: Text(
                          thread.participantAvatarEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(
                        thread.participantName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        thread.participantUsername,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      trailing: const Icon(Icons.send_rounded, color: Color(0xFF25F4EE)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VideoPage extends StatefulWidget {
  final Video video;
  final MockUser currentUser;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onCommentsTap;
  final VoidCallback onShareTap;
  final VoidCallback onProfileTap;

  const _VideoPage({
    super.key,
    required this.video,
    required this.currentUser,
    required this.isLiked,
    required this.onLike,
    required this.onCommentsTap,
    required this.onShareTap,
    required this.onProfileTap,
  });

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideoPlayerFuture;
  Offset? _heartPosition;
  bool _showHeart = false;
  DateTime? _lastTapTime;
  Offset? _lastTapPosition;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller
        ..setLooping(true)
        ..setVolume(0)
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
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
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
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x55000000),
                  Colors.transparent,
                  Color(0xB0000000),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          if (_heartPosition != null)
            Positioned(
              left: _heartPosition!.dx - 48,
              top: _heartPosition!.dy - 48,
              child: IgnorePointer(
                child: AnimatedScale(
                  scale: _showHeart ? 1 : 0.6,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: _showHeart ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 96,
                      shadows: [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 10,
            bottom: 112,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTap: widget.onProfileTap,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black87,
                          child: Text(
                            widget.video.avatarEmoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -8,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFE2C55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _SideAction(
                  icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: _formatCount(widget.video.likes),
                  iconColor: widget.isLiked ? const Color(0xFFFE2C55) : Colors.white,
                  onTap: widget.onLike,
                ),
                const SizedBox(height: 18),
                _SideAction(
                  icon: Icons.chat_bubble_rounded,
                  label: _formatCount(widget.video.commentsCount),
                  onTap: widget.onCommentsTap,
                ),
                const SizedBox(height: 18),
                _SideAction(
                  icon: Icons.bookmark_border_rounded,
                  label: _formatCount(widget.video.saves),
                ),
                const SizedBox(height: 18),
                _SideAction(
                  icon: Icons.reply_rounded,
                  label: _formatCount(widget.video.shares),
                  onTap: widget.onShareTap,
                ),
                const SizedBox(height: 18),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black54,
                  child: Text(
                    widget.currentUser.avatarEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 14,
            right: 88,
            bottom: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.video.author} ✓',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.video.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  '♪ ${widget.video.music}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.mouse && event.buttons != kPrimaryButton) {
      return;
    }

    final now = DateTime.now();
    final lastTapTime = _lastTapTime;
    final lastTapPosition = _lastTapPosition;
    final isQuickEnough =
        lastTapTime != null && now.difference(lastTapTime).inMilliseconds <= 280;
    final isCloseEnough =
        lastTapPosition != null &&
        (event.localPosition - lastTapPosition).distance <= 48;

    if (isQuickEnough && isCloseEnough) {
      _showHeartAt(event.localPosition);
      _lastTapTime = null;
      _lastTapPosition = null;
      return;
    }

    _lastTapTime = now;
    _lastTapPosition = event.localPosition;
  }

  void _showHeartAt(Offset position) {
    if (!widget.isLiked) {
      widget.onLike();
    }

    setState(() {
      _heartPosition = position;
      _showHeart = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showHeart = false;
      });
    });

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _heartPosition = null;
      });
    });
  }

}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SideAction({
    required this.icon,
    required this.label,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final MockUser currentUser;
  final VoidCallback onProfileTap;
  final ValueChanged<int> onSelectTab;

  const _BottomNavigation({
    required this.currentUser,
    required this.onProfileTap,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 64,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home_filled,
              label: 'Home',
              active: true,
              onTap: () => onSelectTab(0),
            ),
            const _NavItem(icon: Icons.people_outline_rounded, label: 'Friends'),
            Container(
              width: 42,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 20,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25F4EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE2C55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 22),
                  ),
                ],
              ),
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Inbox',
              onTap: () => onSelectTab(3),
            ),
            GestureDetector(
              onTap: onProfileTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: const Color(0xFFFE2C55),
                      child: Text(currentUser.avatarEmoji, style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white70;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

String _formatCount(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$value';
}
