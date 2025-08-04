abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}

class ProfileEnum extends Enum<String> {
  const ProfileEnum(super.value);

  static const ProfileEnum profile = ProfileEnum('profile');
  static const ProfileEnum events = ProfileEnum('events');
  static const ProfileEnum answers = ProfileEnum('answers');

  static const List<ProfileEnum> values = [profile, events, answers];
}

class SearchEnum extends Enum<String> {
  const SearchEnum(super.value);

  static const SearchEnum talentPool = SearchEnum('talentPool');
  static const SearchEnum candidates = SearchEnum('candidates');
  static const SearchEnum jobs = SearchEnum('jobs');

  static const List<SearchEnum> values = [talentPool, candidates, jobs];
}

class ActiveSystemEnum extends Enum<String> {
  const ActiveSystemEnum(super.value);

  static const ActiveSystemEnum pms = ActiveSystemEnum('pms');
  static const ActiveSystemEnum strategy = ActiveSystemEnum('strategy');
  static const ActiveSystemEnum ats = ActiveSystemEnum('ats');

  static const List<ActiveSystemEnum> values = [pms, strategy, ats];

  factory ActiveSystemEnum.fromString(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => values.first,
    );
  }
}


