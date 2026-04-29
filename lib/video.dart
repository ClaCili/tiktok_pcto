class VideoComment {
  final String id;
  final String userId;
  final String username;
  final String text;
  final String timeAgo;

  const VideoComment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.timeAgo,
  });
}

class Video {
  final String id;
  final String authorId;
  final String author;
  final String description;
  final String videoUrl;
  final String music;
  final String avatarEmoji;
  final String gradientKey;
  final int shares;
  final int saves;
  final List<String> likedByUserIds;
  final List<VideoComment> comments;

  const Video({
    required this.id,
    required this.authorId,
    required this.author,
    required this.description,
    required this.videoUrl,
    required this.music,
    required this.avatarEmoji,
    required this.gradientKey,
    required this.shares,
    required this.saves,
    required this.likedByUserIds,
    required this.comments,
  });

  int get likes => likedByUserIds.length;
  int get commentsCount => comments.length;

  Video copyWith({
    List<String>? likedByUserIds,
    List<VideoComment>? comments,
  }) {
    return Video(
      id: id,
      authorId: authorId,
      author: author,
      description: description,
      videoUrl: videoUrl,
      music: music,
      avatarEmoji: avatarEmoji,
      gradientKey: gradientKey,
      shares: shares,
      saves: saves,
      likedByUserIds: likedByUserIds ?? this.likedByUserIds,
      comments: comments ?? this.comments,
    );
  }
}
