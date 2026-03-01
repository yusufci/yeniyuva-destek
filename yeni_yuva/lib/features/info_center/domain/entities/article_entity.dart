class ArticleEntity {
  final String id;
  final Map<String, String> title;
  final Map<String, String> content;
  final Map<String, String>? summary;
  final String category;
  final String slug;
  final String? coverImageUrl;
  final bool isPublished;
  final int viewCount;
  final DateTime createdAt;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    required this.category,
    required this.slug,
    this.coverImageUrl,
    this.isPublished = false,
    this.viewCount = 0,
    required this.createdAt,
  });

  String getLocalizedTitle(String lang) => title[lang] ?? title['tr'] ?? '';
  String getLocalizedContent(String lang) => content[lang] ?? content['tr'] ?? '';
  String getLocalizedSummary(String lang) => summary?[lang] ?? summary?['tr'] ?? '';
}