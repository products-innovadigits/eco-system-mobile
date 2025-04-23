abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}

class ProfileEnum extends Enum<String> {
  const ProfileEnum(String value) : super(value);

  static const ProfileEnum profile = ProfileEnum('profile');
  static const ProfileEnum events = ProfileEnum('events');
  static const ProfileEnum answers = ProfileEnum('answers');

  static const List<ProfileEnum> values = [profile, events, answers];
}

