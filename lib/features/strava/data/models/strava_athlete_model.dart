class StravaAthlete {
  final int id;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? profile;
  final String? city;
  final String? state;
  final String? country;

  StravaAthlete({
    required this.id,
    required this.username,
    this.firstname,
    this.lastname,
    this.profile,
    this.city,
    this.state,
    this.country,
  });

  factory StravaAthlete.fromJson(Map<String, dynamic> json) {
    return StravaAthlete(
      id: int.parse(json['id'].toString()),
      username: json['username'] as String,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      profile: json['profile'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  String get fullName {
    if (firstname != null && lastname != null) {
      return '$firstname $lastname';
    }
    return username;
  }
}
