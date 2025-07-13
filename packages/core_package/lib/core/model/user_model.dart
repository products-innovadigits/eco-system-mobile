import 'package:core_package/core/utility/export.dart';

class UserModel extends SingleMapper {
  String? accessToken;
  String? tokenType;
  UserData? user;

  UserModel({
    this.accessToken,
    this.tokenType,
    this.user,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}

class UserData extends SingleMapper {
  int? id;
  // String? accessToken;
  // String? welcomeMessage;
  String? name;
  String? email;
  // String? avatar;

  UserData({
    this.id,
    // this.accessToken,
    // this.welcomeMessage,
    this.name,
    this.email,
    // this.avatar,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    // accessToken = json['tokken'];
    // welcomeMessage = json['wellcomeMessage'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    // avatar = json['avatar'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 0;
    // data['tokken'] = accessToken;
    // data['wellcomeMessage'] = welcomeMessage;
    data['name'] = name ?? '';
    data['email'] = email ?? '';
    // data['avatar'] = avatar ?? '';
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserData.fromJson(json);
  }
}
