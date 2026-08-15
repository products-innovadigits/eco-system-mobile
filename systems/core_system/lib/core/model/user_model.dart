import 'package:core_system/core/utility/export.dart';

class UserModel extends SingleMapper {
  int? id;
  String? accessToken;
  String? token;
  String? welcomeMessage;
  String? name;
  String? email;
  String? avatar;

  UserModel({
    this.id,
    this.accessToken,
    this.token,
    this.welcomeMessage,
    this.name,
    this.email,
    this.avatar,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    /// The PMS API nests the user under `user` and returns the token beside it,
    /// while the Project Management API returns both flat.
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    id = user['id'];
    accessToken = json['tokken'];
    token = json['token'] ?? json['access_token'];
    welcomeMessage = json['wellcomeMessage'];
    name = user['name'] ?? '';
    email = user['email'] ?? '';
    avatar = user['avatar'] ?? '';
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tokken'] = accessToken;
    data['token'] = token;
    data['wellcomeMessage'] = welcomeMessage;
    data['name'] = name ?? '';
    data['email'] = email ?? '';
    data['avatar'] = avatar ?? '';
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
