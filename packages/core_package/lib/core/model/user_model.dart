import 'package:core_package/core/utility/export.dart';

class UserModel extends SingleMapper {
  int? id;
  String? accessToken;
  String? welcomeMessage;
  String? name;
  String? email;
  String? avatar;

  UserModel({
    this.id,
    this.accessToken,
    this.welcomeMessage,
    this.name,
    this.email,
    this.avatar,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['tokken'];
    welcomeMessage = json['wellcomeMessage'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    avatar = json['avatar'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokken'] = accessToken;
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
