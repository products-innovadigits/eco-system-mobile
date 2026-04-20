import 'package:core_system/core/utility/export.dart';

class UserModel extends SingleMapper {
  int? id;
  String? accessToken;
  String? token;
  String? welcomeMessage;
  String? name;
  String? email;
  String? avatar;

  /// ATS / extended profile (optional for other systems).
  String? timezone;
  String? phone;
  String? countryCode;
  bool? isActive;
  String? position;
  String? createdAt;
  String? emailSignature;
  String? profilePhoto;
  bool? googleProfile;
  String? roleName;

  UserModel({
    this.id,
    this.accessToken,
    this.token,
    this.welcomeMessage,
    this.name,
    this.email,
    this.avatar,
    this.timezone,
    this.phone,
    this.countryCode,
    this.isActive,
    this.position,
    this.createdAt,
    this.emailSignature,
    this.profilePhoto,
    this.googleProfile,
    this.roleName,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id'] as int?
        : int.tryParse('${json['id']}');

    accessToken = json['tokken']?.toString() ?? json['accessToken']?.toString();
    token = json['token']?.toString();

    welcomeMessage = json['wellcomeMessage']?.toString();
    name = json['name']?.toString() ?? '';
    email = json['email']?.toString() ?? '';

    final avatarVal = json['avatar']?.toString();
    final profilePhotoVal = json['profile_photo']?.toString();
    profilePhoto = profilePhotoVal;
    avatar = (avatarVal != null && avatarVal.isNotEmpty)
        ? avatarVal
        : (profilePhotoVal ?? '');

    timezone = json['timezone']?.toString();
    phone = json['phone']?.toString();
    countryCode = json['country_code']?.toString();
    isActive = _parseOptionalBool(json['is_active']);
    position = json['position']?.toString();
    createdAt = json['created_at']?.toString();
    emailSignature = json['email_signature']?.toString();
    googleProfile = _parseOptionalBool(json['google_profile']);
    roleName = json['role_name']?.toString();
  }

  static bool? _parseOptionalBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final lower = v.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return null;
  }

  /// Bearer token to cache for [Authorization] after login, per active system.
  String? authTokenForSystem(ActiveSystemEnum system) {
    switch (system.value) {
      case 'ats':
      case 'pms':
        return token ?? accessToken;
      case 'project_management':
      case 'strategy':
        return accessToken ?? token;
      default:
        return accessToken ?? token;
    }
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
    data['timezone'] = timezone;
    data['phone'] = phone;
    data['country_code'] = countryCode;
    data['is_active'] = isActive;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['email_signature'] = emailSignature;
    data['profile_photo'] = profilePhoto;
    data['google_profile'] = googleProfile;
    data['role_name'] = roleName;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
