import 'package:eco_system/network/mapper.dart';

class UserModel extends SingleMapper {
  int? id;
  String? accessToken;
  String? name;
  String? email;
  String? avatar;

  UserModel({
    this.id,
    this.accessToken,
    this.name,
    this.email,
    this.avatar,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
