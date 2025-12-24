import '../../../events/data/models/event_model.dart';
import '../../../auth/data/models/user_model.dart';

class SearchResults {
  final List<UserModel> people;
  final List<Event> events;

  SearchResults({
    required this.people,
    required this.events,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      people: (json['people'] as List<dynamic>?)
              ?.map((item) => UserModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.map((item) => Event.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isEmpty => people.isEmpty && events.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
