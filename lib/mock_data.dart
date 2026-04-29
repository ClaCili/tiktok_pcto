import 'package:tiktok_pcto/video.dart';
import 'package:tiktok_pcto/chat.dart';

class MockUser {
  final String id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String bio;
  final String avatarEmoji;
  final int following;
  final int followers;
  final int likes;

  const MockUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.bio,
    required this.avatarEmoji,
    required this.following,
    required this.followers,
    required this.likes,
  });
}

class MockData {
  static const users = <MockUser>[
    MockUser(
      id: 'u1',
      name: 'Giulia Riva',
      username: '@giuliacooks',
      email: 'giulia@mocktok.it',
      password: '123456',
      bio: 'Ricette veloci e cucina everyday.',
      avatarEmoji: '🍝',
      following: 184,
      followers: 12800,
      likes: 245000,
    ),
    MockUser(
      id: 'u2',
      name: 'Marco Lens',
      username: '@marcolens',
      email: 'marco@mocktok.it',
      password: '123456',
      bio: 'Street clips e notti in citta.',
      avatarEmoji: '📸',
      following: 301,
      followers: 23400,
      likes: 531000,
    ),
    MockUser(
      id: 'u3',
      name: 'Sara Moves',
      username: '@saramoves',
      email: 'sara@mocktok.it',
      password: '123456',
      bio: 'Dance practice, bloopers e backstage.',
      avatarEmoji: '💃',
      following: 152,
      followers: 45100,
      likes: 918000,
    ),
    MockUser(
      id: 'u4',
      name: 'Luca Drift',
      username: '@lucadrift',
      email: 'luca@mocktok.it',
      password: '123456',
      bio: 'Auto, dettagli, motori e POV.',
      avatarEmoji: '🏎️',
      following: 96,
      followers: 17600,
      likes: 302000,
    ),
    MockUser(
      id: 'u5',
      name: 'Noemi Fit',
      username: '@noemifit',
      email: 'noemi@mocktok.it',
      password: '123456',
      bio: 'Workout brevi che puoi fare ovunque.',
      avatarEmoji: '🧘',
      following: 221,
      followers: 39800,
      likes: 642000,
    ),
  ];

  static List<Video> videos() {
    return const [
      Video(
        id: 'v1',
        authorId: 'u1',
        author: '@giuliacooks',
        description: 'Meal prep della domenica ma in versione super veloce',
        videoUrl: 'assets/videos/Download.mp4',
        music: 'Kitchen Bounce',
        avatarEmoji: '🍝',
        gradientKey: 'sunset',
        shares: 184,
        saves: 2140,
        likedByUserIds: ['u2', 'u3', 'u4', 'u5', 'u9', 'u10', 'u11'],
        comments: [
          VideoComment(
            id: 'c1',
            userId: 'u3',
            username: '@saramoves',
            text: 'Ok il taglio finale della pasta e` illegale',
            timeAgo: '11 min',
          ),
          VideoComment(
            id: 'c2',
            userId: 'u5',
            username: '@noemifit',
            text: 'Salvato per quando non so cosa cucinare',
            timeAgo: '7 min',
          ),
        ],
      ),
      Video(
        id: 'v2',
        authorId: 'u2',
        author: '@marcolens',
        description: 'Camera test in strada: luce bassa ma il mood regge tutto',
        videoUrl: 'assets/videos/Download.mp4',
        music: 'Analog Dreams',
        avatarEmoji: '📸',
        gradientKey: 'city',
        shares: 92,
        saves: 860,
        likedByUserIds: ['u1', 'u3', 'u4', 'u5', 'u12'],
        comments: [
          VideoComment(
            id: 'c3',
            userId: 'u4',
            username: '@lucadrift',
            text: 'La luce sul pavimento qui e` assurda',
            timeAgo: '19 min',
          ),
          VideoComment(
            id: 'c5',
            userId: 'u1',
            username: '@giuliacooks',
            text: 'Sembra davvero uno still da videoclip',
            timeAgo: '13 min',
          ),
        ],
      ),
      Video(
        id: 'v3',
        authorId: 'u3',
        author: '@saramoves',
        description: 'Provo il trend del momento, ma l ultimo step mi distrugge',
        videoUrl: 'assets/videos/Download.mp4',
        music: 'Beat Loop x Night Shift',
        avatarEmoji: '💃',
        gradientKey: 'mint',
        shares: 438,
        saves: 3012,
        likedByUserIds: ['u1', 'u2', 'u4', 'u5', 'u7', 'u8', 'u13', 'u14'],
        comments: [
          VideoComment(
            id: 'c6',
            userId: 'u2',
            username: '@marcolens',
            text: 'Il sync al secondo 4 e` super pulito',
            timeAgo: '33 min',
          ),
        ],
      ),
      Video(
        id: 'v4',
        authorId: 'u4',
        author: '@lucadrift',
        description: 'POV: lavi la macchina e la riprendi da ogni angolo possibile',
        videoUrl: 'assets/videos/Download.mp4',
        music: 'Engine Mood',
        avatarEmoji: '🏎️',
        gradientKey: 'neon',
        shares: 126,
        saves: 990,
        likedByUserIds: ['u1', 'u2', 'u3', 'u5', 'u15', 'u16'],
        comments: [
          VideoComment(
            id: 'c7',
            userId: 'u5',
            username: '@noemifit',
            text: 'Quel riflesso finale e` terapia visiva',
            timeAgo: '52 min',
          ),
          VideoComment(
            id: 'c8',
            userId: 'u1',
            username: '@giuliacooks',
            text: 'Mi hai quasi convinta a pulire la mia davvero',
            timeAgo: '40 min',
          ),
        ],
      ),
      Video(
        id: 'v5',
        authorId: 'u5',
        author: '@noemifit',
        description: 'Routine soft da mattina presto prima di iniziare la giornata',
        videoUrl: 'assets/videos/Download.mp4',
        music: 'Morning Push',
        avatarEmoji: '🧘',
        gradientKey: 'rose',
        shares: 302,
        saves: 2874,
        likedByUserIds: ['u1', 'u2', 'u3', 'u4', 'u17', 'u18', 'u19', 'u20'],
        comments: [
          VideoComment(
            id: 'c9',
            userId: 'u2',
            username: '@marcolens',
            text: 'Questo opening frame sembra super calming',
            timeAgo: '1 h',
          ),
          VideoComment(
            id: 'c10',
            userId: 'u3',
            username: '@saramoves',
            text: 'Perfetta da fare prima delle prove',
            timeAgo: '58 min',
          ),
        ],
      ),
    ];
  }

  static MockUser? userById(String id) {
    for (final user in users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  static List<ChatThread> chatThreads(List<Video> videos) {
    final byId = {for (final video in videos) video.id: video};

    return [
      ChatThread(
        id: 't1',
        participantId: 'u2',
        participantName: 'Marco Lens',
        participantUsername: '@marcolens',
        participantAvatarEmoji: '📸',
        isOnline: true,
        messages: [
          ChatMessage(
            id: 'm3',
            senderId: 'u2',
            senderUsername: '@marcolens',
            text: 'Mandami quello del meal prep quando vuoi',
            timeLabel: '09:41',
            type: ChatMessageType.text,
          ),
          ChatMessage(
            id: 'm2',
            senderId: 'u1',
            senderUsername: '@giuliacooks',
            text: '',
            timeLabel: '09:38',
            type: ChatMessageType.video,
            video: byId['v1'],
          ),
          ChatMessage(
            id: 'm1',
            senderId: 'u2',
            senderUsername: '@marcolens',
            text: 'Questo taglio sta benissimo nel feed',
            timeLabel: '09:34',
            type: ChatMessageType.text,
          ),
        ],
      ),
      ChatThread(
        id: 't2',
        participantId: 'u3',
        participantName: 'Sara Moves',
        participantUsername: '@saramoves',
        participantAvatarEmoji: '💃',
        isOnline: true,
        messages: [
          ChatMessage(
            id: 'm5',
            senderId: 'u3',
            senderUsername: '@saramoves',
            text: 'Hai visto il trend che ho postato?',
            timeLabel: 'Ieri',
            type: ChatMessageType.text,
          ),
          ChatMessage(
            id: 'm4',
            senderId: 'u1',
            senderUsername: '@giuliacooks',
            text: 'Si, il sync finale e` fortissimo',
            timeLabel: 'Ieri',
            type: ChatMessageType.text,
          ),
        ],
      ),
      ChatThread(
        id: 't3',
        participantId: 'u4',
        participantName: 'Luca Drift',
        participantUsername: '@lucadrift',
        participantAvatarEmoji: '🏎️',
        isOnline: false,
        messages: [
          ChatMessage(
            id: 'm7',
            senderId: 'u1',
            senderUsername: '@giuliacooks',
            text: '',
            timeLabel: 'Lun',
            type: ChatMessageType.video,
            video: byId['v4'],
          ),
          ChatMessage(
            id: 'm6',
            senderId: 'u4',
            senderUsername: '@lucadrift',
            text: 'Il riflesso sul cofano qui mi piace un sacco',
            timeLabel: 'Lun',
            type: ChatMessageType.text,
          ),
        ],
      ),
      ChatThread(
        id: 't4',
        participantId: 'u5',
        participantName: 'Noemi Fit',
        participantUsername: '@noemifit',
        participantAvatarEmoji: '🧘',
        isOnline: true,
        messages: [
          ChatMessage(
            id: 'm8',
            senderId: 'u5',
            senderUsername: '@noemifit',
            text: 'Se vuoi ti mando la mia routine preferita',
            timeLabel: 'Dom',
            type: ChatMessageType.text,
          ),
        ],
      ),
    ];
  }
}
