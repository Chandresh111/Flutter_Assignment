class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // ============================================================
  // CREATE MODEL FROM API JSON
  // ============================================================

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? 'Untitled post',
      body: json['body']?.toString() ?? 'No description available.',
    );
  }

  // ============================================================
  // CONVERT MODEL TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  // ============================================================
  // DISPLAY HELPERS
  // ============================================================

  String get displayTitle {
    if (title.isEmpty) {
      return 'Untitled post';
    }

    return title
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String get displayBody {
    if (body.isEmpty) {
      return 'No description available.';
    }

    return body
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  // ============================================================
  // AUTHOR
  // ============================================================

  String get authorName => 'User $userId';

  String get authorInitials => 'U$userId';

  // ============================================================
  // CATEGORY
  // ============================================================

  String get category {
    const categories = [
      'Technology',
      'Productivity',
      'Development',
      'Design',
      'Innovation',
      'Research',
    ];

    return categories[(id - 1) % categories.length];
  }

  // ============================================================
  // READING TIME
  // ============================================================

  int get wordCount {
    if (body.trim().isEmpty) {
      return 0;
    }

    return body.trim().split(RegExp(r'\s+')).length;
  }

  int get readingMinutes {
    final minutes = (wordCount / 180).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  String get readingTime => '$readingMinutes min read';

  // ============================================================
  // ENGAGEMENT SCORE
  // ============================================================

  int get engagementScore {
    return 60 + ((id * 17) % 41);
  }

  // ============================================================
  // API STATUS LABEL
  // ============================================================

  String get status => 'Synced';

  // ============================================================
  // COPY WITH
  // ============================================================

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}