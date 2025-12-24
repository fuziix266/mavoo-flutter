class SearchHistory {
  final int id;
  final int userId;
  final String searchQuery;
  final SearchType searchType;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.userId,
    required this.searchQuery,
    required this.searchType,
    required this.createdAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      searchQuery: json['search_query'] as String,
      searchType: _parseSearchType(json['search_type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static SearchType _parseSearchType(String type) {
    switch (type) {
      case 'people':
        return SearchType.people;
      case 'events':
        return SearchType.events;
      case 'hashtags':
        return SearchType.hashtags;
      case 'posts':
        return SearchType.posts;
      case 'groups':
        return SearchType.groups;
      default:
        return SearchType.all;
    }
  }

  String get searchTypeString {
    switch (searchType) {
      case SearchType.people:
        return 'people';
      case SearchType.events:
        return 'events';
      case SearchType.hashtags:
        return 'hashtags';
      case SearchType.posts:
        return 'posts';
      case SearchType.groups:
        return 'groups';
      case SearchType.all:
        return 'all';
    }
  }
}

enum SearchType {
  all,
  people,
  events,
  hashtags,
  posts,
  groups,
}

enum ResultType {
  user,
  event,
  hashtag,
  post,
  group,
}
