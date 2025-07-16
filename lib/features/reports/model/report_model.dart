
import 'package:core_package/core/utility/export.dart';

class ReportsModel extends SingleMapper {
  String? message;
  int? code;
  List<ReportData>? data;

  ReportsModel({this.message, this.code, this.data});

  ReportsModel.fromJson(Map<String, dynamic> json);

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
    data = <ReportData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(ReportData.fromJson(v));
      });
    }
    return ReportsModel(message: message, code: code, data: data);
  }
}

class ReportData {
  String? id;
  String? title;
  String? date;
  String? color;
  String? status;

  ReportData({
    this.id,
    this.title,
    this.date,
    this.color,
    this.status,
  });

  ReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    date = json['date'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['status'] = status;
    return data;
  }
}
