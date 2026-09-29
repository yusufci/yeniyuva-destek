class ApiConstants {
  ApiConstants._();

  // Supabase Table Names
  static const String servicesTable = 'services';
  static const String articlesTable = 'articles';
  static const String profilesTable = 'profiles';
  static const String forumThreadsTable = 'forum_threads';
  static const String forumPostsTable = 'forum_posts';
  static const String favoritesTable = 'favorites';
  static const String reportsTable = 'reports';

  // Supabase RPC Functions
  static const String nearbyServicesRpc = 'nearby_services';

  // Service Categories
  static const String categoryHealth = 'health';
  static const String categoryEducation = 'education';
  static const String categoryLegal = 'legal';
  static const String categoryHousing = 'housing';
  static const String categorySocialAid = 'social_aid';
  static const String categoryEmployment = 'employment';
  static const String categoryCommunity = 'community';

  // Article Categories
  static const String articleLifeInTurkey = 'life_in_turkey';
  static const String articleEducationSystem = 'education_system';
  static const String articleHealthSystem = 'health_system';
  static const String articleWorkLife = 'work_life';
  static const String articleLegalRights = 'legal_rights';

  // Default Values
  static const int defaultSearchRadiusKm = 10;
  static const int maxSearchRadiusKm = 50;
  static const int defaultPageSize = 20;

  // Supported Languages
  static const List<String> supportedLanguages = [
    'tr', // Türkçe
    'ar', // Arapça
    'en', // İngilizce
    'fa', // Farsça
    'uk', // Ukraynaca
    'ru', // Rusça
  ];
}