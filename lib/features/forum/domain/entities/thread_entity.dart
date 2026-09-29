class ThreadEntity {
  final String id;
  final String title;
  final String body;
  final String? category;
  final String authorId;
  final String? authorName;
  final int voteCount;
  final int replyCount;
  final bool isLocked;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ThreadEntity({
    required this.id,
    required this.title,
    required this.body,
    this.category,
    required this.authorId,
    this.authorName,
    this.voteCount = 0,
    this.replyCount = 0,
    this.isLocked = false,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });
}

class PostEntity {
  final String id;
  final String body;
  final String threadId;
  final String authorId;
  final String? authorName;
  final int voteCount;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.body,
    required this.threadId,
    required this.authorId,
    this.authorName,
    this.voteCount = 0,
    required this.createdAt,
  });
}