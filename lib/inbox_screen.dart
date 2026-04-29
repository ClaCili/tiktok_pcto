import 'package:flutter/material.dart';
import 'package:tiktok_pcto/chat.dart';
import 'package:tiktok_pcto/mock_data.dart';

class InboxScreen extends StatefulWidget {
  final MockUser currentUser;
  final List<ChatThread> threads;
  final String? selectedThreadId;
  final void Function(String threadId, String text) onSendTextMessage;
  final void Function(int index) onSelectTab;
  final VoidCallback onProfileTap;

  const InboxScreen({
    super.key,
    required this.currentUser,
    required this.threads,
    required this.selectedThreadId,
    required this.onSendTextMessage,
    required this.onSelectTab,
    required this.onProfileTap,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String? _openThreadId;

  @override
  void initState() {
    super.initState();
    _openThreadId = widget.selectedThreadId ?? (widget.threads.isNotEmpty ? widget.threads.first.id : null);
  }

  @override
  void didUpdateWidget(covariant InboxScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedThreadId != null && widget.selectedThreadId != _openThreadId) {
      _openThreadId = widget.selectedThreadId;
    } else if (_openThreadId == null && widget.threads.isNotEmpty) {
      _openThreadId = widget.threads.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final currentThread = widget.threads.where((thread) => thread.id == _openThreadId).firstOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: isWide
            ? Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: _ThreadListPane(
                      currentUser: widget.currentUser,
                      threads: widget.threads,
                      selectedThreadId: _openThreadId,
                      onOpenThread: _openThread,
                      onSelectTab: widget.onSelectTab,
                      onProfileTap: widget.onProfileTap,
                    ),
                  ),
                  Expanded(
                    child: currentThread == null
                        ? const _EmptyInboxState()
                        : _ChatPane(
                            currentUser: widget.currentUser,
                            thread: currentThread,
                            onSendTextMessage: widget.onSendTextMessage,
                          ),
                  ),
                ],
              )
            : currentThread == null
                ? _ThreadListPane(
                    currentUser: widget.currentUser,
                    threads: widget.threads,
                    selectedThreadId: _openThreadId,
                    onOpenThread: _openThread,
                    onSelectTab: widget.onSelectTab,
                    onProfileTap: widget.onProfileTap,
                  )
                : _ChatPane(
                    currentUser: widget.currentUser,
                    thread: currentThread,
                    onSendTextMessage: widget.onSendTextMessage,
                    onBack: () {
                      setState(() {
                        _openThreadId = null;
                      });
                    },
                  ),
      ),
      bottomNavigationBar: isWide
          ? null
          : _InboxBottomBar(
              currentUser: widget.currentUser,
              onSelectTab: widget.onSelectTab,
              onProfileTap: widget.onProfileTap,
            ),
    );
  }

  void _openThread(String threadId) {
    setState(() {
      _openThreadId = threadId;
    });
  }
}

class _ThreadListPane extends StatelessWidget {
  final MockUser currentUser;
  final List<ChatThread> threads;
  final String? selectedThreadId;
  final ValueChanged<String> onOpenThread;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onProfileTap;

  const _ThreadListPane({
    required this.currentUser,
    required this.threads,
    required this.selectedThreadId,
    required this.onOpenThread,
    required this.onSelectTab,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                const Text(
                  'Inbox',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => onSelectTab(0),
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white70),
                ),
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFFE2C55),
                    child: Text(currentUser.avatarEmoji, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF171717),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: Colors.white54),
                  SizedBox(width: 10),
                  Text(
                    'Search chats',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: threads.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final thread = threads[index];
                final isSelected = thread.id == selectedThreadId;
                final latest = thread.latestMessage;
                final preview = latest == null
                    ? 'Nessun messaggio'
                    : latest.type == ChatMessageType.video
                        ? '${latest.senderUsername} ha inviato un video'
                        : latest.text;

                return Material(
                  color: isSelected ? const Color(0xFF1C1C1C) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () => onOpenThread(thread.id),
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF262626),
                                child: Text(
                                  thread.participantAvatarEmoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              if (thread.isOnline)
                                const Positioned(
                                  right: -1,
                                  bottom: -1,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Color(0xFF22C55E),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  thread.participantName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  preview,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            latest?.timeLabel ?? '',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatPane extends StatefulWidget {
  final MockUser currentUser;
  final ChatThread thread;
  final void Function(String threadId, String text) onSendTextMessage;
  final VoidCallback? onBack;

  const _ChatPane({
    required this.currentUser,
    required this.thread,
    required this.onSendTextMessage,
    this.onBack,
  });

  @override
  State<_ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<_ChatPane> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 18, 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              if (widget.onBack != null)
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                ),
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF262626),
                child: Text(widget.thread.participantAvatarEmoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.thread.participantName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.thread.participantUsername,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: Colors.white70),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            itemCount: widget.thread.messages.length,
            itemBuilder: (context, index) {
              final message = widget.thread.messages[index];
              final isMine = message.senderId == widget.currentUser.id;
              return Align(
                alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: message.type == ChatMessageType.video && message.video != null
                      ? _VideoMessageBubble(message: message, isMine: isMine)
                      : _TextMessageBubble(message: message, isMine: isMine),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Scrivi un messaggio...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) {
                    return;
                  }
                  widget.onSendTextMessage(widget.thread.id, text);
                  _controller.clear();
                },
                icon: const Icon(Icons.send_rounded, color: Color(0xFF25F4EE)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const _TextMessageBubble({
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFFFE2C55) : const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            message.timeLabel,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _VideoMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const _VideoMessageBubble({
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final video = message.video!;
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF2A121A) : const Color(0xFF171717),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 9 / 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _VideoGradientBackground(gradientKey: video.gradientKey),
                  Container(color: Colors.black.withValues(alpha: 0.26)),
                  const Center(
                    child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 58),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.author,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Video inviato',
            style: TextStyle(
              color: isMine ? const Color(0xFFFFB3C3) : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.timeLabel,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _VideoGradientBackground extends StatelessWidget {
  final String gradientKey;

  const _VideoGradientBackground({required this.gradientKey});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: switch (gradientKey) {
          'sunset' => const LinearGradient(
              colors: [Color(0xFF43193D), Color(0xFFFE2C55), Color(0xFFFFA34D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          'city' => const LinearGradient(
              colors: [Color(0xFF07111F), Color(0xFF174B7A), Color(0xFF0A2239)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          'mint' => const LinearGradient(
              colors: [Color(0xFF0B3B2E), Color(0xFF25F4EE), Color(0xFF112F3B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          'neon' => const LinearGradient(
              colors: [Color(0xFF12091E), Color(0xFF6843EC), Color(0xFFF24BE9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          _ => const LinearGradient(
              colors: [Color(0xFF3D1220), Color(0xFFD94177), Color(0xFFFFC95E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        },
      ),
    );
  }
}

class _InboxBottomBar extends StatelessWidget {
  final MockUser currentUser;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onProfileTap;

  const _InboxBottomBar({
    required this.currentUser,
    required this.onSelectTab,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InboxNavItem(icon: Icons.home_filled, label: 'Home', onTap: () => onSelectTab(0)),
          const _InboxNavItem(icon: Icons.people_outline_rounded, label: 'Friends'),
          const _InboxNavItem(icon: Icons.add_box_outlined, label: 'Create'),
          const _InboxNavItem(icon: Icons.chat_bubble_rounded, label: 'Inbox', active: true),
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
                const Text('Profile', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InboxNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _InboxNavItem({
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
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _EmptyInboxState extends StatelessWidget {
  const _EmptyInboxState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Seleziona una chat per iniziare.',
        style: TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
