import '../../../events/data/models/event_model.dart';
import '../../../../core/data/models/user_model.dart';

class SearchResults {
  final List<User> people;
  final List<Event> events;

  SearchResults({
    required this.people,
    required this.events,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      people: (json['people'] as List<dynamic>?)
              ?.map((item) => User.fromJson(item as Map<String, dynamic>))
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
