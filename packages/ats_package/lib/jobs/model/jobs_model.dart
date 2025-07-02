import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class JobsModel extends SingleMapper {
  List<JobDataModel>? data;
  int? statusCode;
  String? message;
  Meta? meta;

  JobsModel({
    this.data,
    this.statusCode,
    this.message,
    this.meta,
  });

  JobsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(JobDataModel.fromJson(v));
      });
    }
    statusCode = json['status_code'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return JobsModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((e) => e.toJson()).toList();
    }
    data['status_code'] = statusCode;
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class JobDataModel extends SingleMapper {
  int? id;
  String? title;
  String? description;
  String? address;
  String? chanceType;
  String? department;
  String? workPlace;
  String? status;
  String? level;
  String? createdAt;
  List<StageModel>? stages;

  JobDataModel({
    this.id,
    this.title,
    this.description,
    this.address,
    this.chanceType,
    this.department,
    this.workPlace,
    this.status,
    this.level,
    this.createdAt,
    this.stages,
  });

  JobDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    chanceType = json['chance_type'];
    department = json['department'];
    workPlace = json['work_place'];
    status = json['status'];
    level = json['level'];
    createdAt = json['created_at'];

    if (json['stages'] != null) {
      stages = [];
      json['stages'].forEach((v) {
        stages!.add(StageModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return JobDataModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['address'] = address;
    data['chance_type'] = chanceType;
    data['department'] = department;
    data['work_place'] = workPlace;
    data['status'] = status;
    data['level'] = level;
    data['created_at'] = createdAt;
    if (stages != null) {
      data['stages'] = stages!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class StageModel extends SingleMapper {
  String? type;
  int? count;
  String? color;
  String? width;

  StageModel({
    this.type,
    this.count,
    this.color,
    this.width,
  });

  StageModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    count = json['count'];
    color = json['color'];
    width = json['width'];
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return StageModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['count'] = count;
    data['color'] = color;
    data['width'] = width;
    return data;
  }
}


