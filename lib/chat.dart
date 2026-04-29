import 'package:tiktok_pcto/video.dart';

enum ChatMessageType { text, video }

class ChatMessage {
  final String id;
  final String senderId;
  final String senderUsername;
  final String text;
  final String timeLabel;
  final ChatMessageType type;
  final Video? video;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.text,
    required this.timeLabel,
    required this.type,
    this.video,
  });
}

class ChatThread {
  final String id;
  final String participantId;
  final String participantName;
  final String participantUsername;
  final String participantAvatarEmoji;
  final bool isOnline;
  final List<ChatMessage> messages;

  const ChatThread({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantUsername,
    required this.participantAvatarEmoji,
    required this.isOnline,
    required this.messages,
  });

  ChatMessage? get latestMessage => messages.isEmpty ? null : messages.first;

  ChatThread copyWith({
    List<ChatMessage>? messages,
  }) {
    return ChatThread(
      id: id,
      participantId: participantId,
      participantName: participantName,
      participantUsername: participantUsername,
      participantAvatarEmoji: participantAvatarEmoji,
      isOnline: isOnline,
      messages: messages ?? this.messages,
    );
  }
}
