import 'package:flutter/material.dart';
import 'package:tiktok_pcto/chat.dart';
import 'package:tiktok_pcto/inbox_screen.dart';
import 'package:tiktok_pcto/mock_data.dart';
import 'package:tiktok_pcto/screens/home_screen.dart';
import 'package:tiktok_pcto/screens/login_screen.dart';
import 'package:tiktok_pcto/video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Video> _videos;
  late List<ChatThread> _threads;
  MockUser? _currentUser;
  int _selectedTab = 0;
  String? _activeThreadId;

  @override
  void initState() {
    super.initState();
    _videos = MockData.videos();
    _threads = MockData.chatThreads(_videos);
    if (_threads.isNotEmpty) {
      _activeThreadId = _threads.first.id;
    }
  }

  void _login(MockUser user) {
    setState(() {
      _currentUser = user;
      _selectedTab = 0;
    });
  }

  bool loginWithCredentials(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();

    for (final user in MockData.users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password.trim()) {
        _login(user);
        return true;
      }
    }

    return false;
  }

  void logout() {
    setState(() {
      _currentUser = null;
      _selectedTab = 0;
      _activeThreadId = _threads.isNotEmpty ? _threads.first.id : null;
    });
  }

  void selectTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void toggleLike(String videoId) {
    if (_currentUser == null) {
      return;
    }

    setState(() {
      _videos = _videos.map((video) {
        if (video.id != videoId) {
          return video;
        }

        final likes = List<String>.from(video.likedByUserIds);
        if (likes.contains(_currentUser!.id)) {
          likes.remove(_currentUser!.id);
        } else {
          likes.add(_currentUser!.id);
        }
        return video.copyWith(likedByUserIds: likes);
      }).toList();
    });
  }

  void addComment(String videoId, String text) {
    if (_currentUser == null || text.trim().isEmpty) {
      return;
    }

    final comment = VideoComment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: _currentUser!.id,
      username: _currentUser!.username,
      text: text.trim(),
      timeAgo: 'ora',
    );

    setState(() {
      _videos = _videos.map((video) {
        if (video.id != videoId) {
          return video;
        }

        final comments = List<VideoComment>.from(video.comments)..insert(0, comment);
        return video.copyWith(comments: comments);
      }).toList();
    });
  }

  void sendTextMessage(String threadId, String text) {
    if (_currentUser == null || text.trim().isEmpty) {
      return;
    }

    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: _currentUser!.id,
      senderUsername: _currentUser!.username,
      text: text.trim(),
      timeLabel: _timeLabelNow(),
      type: ChatMessageType.text,
    );

    setState(() {
      _threads = _updatedThreadsWithMessage(threadId, message);
      _selectedTab = 3;
      _activeThreadId = threadId;
    });
  }

  void sendVideoMessage(String threadId, Video video) {
    if (_currentUser == null) {
      return;
    }

    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: _currentUser!.id,
      senderUsername: _currentUser!.username,
      text: '',
      timeLabel: _timeLabelNow(),
      type: ChatMessageType.video,
      video: video,
    );

    setState(() {
      _threads = _updatedThreadsWithMessage(threadId, message);
      _selectedTab = 3;
      _activeThreadId = threadId;
    });
  }

  List<ChatThread> _updatedThreadsWithMessage(String threadId, ChatMessage message) {
    final updated = _threads.map((thread) {
      if (thread.id != threadId) {
        return thread;
      }
      final messages = List<ChatMessage>.from(thread.messages)..insert(0, message);
      return thread.copyWith(messages: messages);
    }).toList();

    updated.sort((a, b) {
      if (a.id == threadId) {
        return -1;
      }
      if (b.id == threadId) {
        return 1;
      }
      return 0;
    });

    return updated;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFE2C55),
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone Mock',
      theme: theme,
      home: _currentUser == null
          ? LoginScreen(
              users: MockData.users,
              onLoginWithCredentials: loginWithCredentials,
              onQuickLogin: _login,
            )
          : _selectedTab == 3
              ? InboxScreen(
                  currentUser: _currentUser!,
                  threads: _threads,
                  selectedThreadId: _activeThreadId,
                  onSendTextMessage: sendTextMessage,
                  onSelectTab: selectTab,
                  onProfileTap: () {},
                )
              : HomeScreen(
                  currentUser: _currentUser!,
                  videos: _videos,
                  threads: _threads,
                  onLogout: logout,
                  onToggleLike: toggleLike,
                  onAddComment: addComment,
                  onSendVideoMessage: sendVideoMessage,
                  onSelectTab: selectTab,
                ),
    );
  }
}

String _timeLabelNow() {
  final now = DateTime.now();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
