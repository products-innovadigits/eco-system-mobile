
import 'package:core_package/core/utility/export.dart';

class NotificationModel extends SingleMapper {
  String? message;
  int? code;
  List<NotificationData>? data;

  NotificationModel({this.message, this.code, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = <NotificationData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    return NotificationModel(message: message, code: code, data: data);
  }
}

class NotificationData {
  String? id;
  String? title;
  String? body;
  String? type;
  bool? status;
  String? image;
  dynamic dataId;
  String? date;
  String? navigateType;
  String? readAt;

  NotificationData({
    this.id,
    this.title,
    this.body,
    this.type,
    this.status,
    this.image,
    this.date,
    this.dataId,
    this.navigateType,
    this.readAt,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    body = json['body'] ?? '';
    type = json['type'] ?? '';
    status = json['status'] ?? false;
    image = json['image'] ?? '';
    date = json['date'] ?? '';
    dataId = json['data_id'] ?? '';
    navigateType = json['navigateType'] ?? '';
    readAt = json['read_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['type'] = type;
    data['status'] = status;
    data['image'] = image;
    data['date'] = date;
    data['data_id'] = dataId;
    data['navigateType'] = navigateType;
    data['read_at'] = readAt;
    return data;
  }
}
