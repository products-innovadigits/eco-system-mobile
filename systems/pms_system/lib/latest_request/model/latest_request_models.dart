import 'package:pms_system/shared/pms_exports.dart';

class LatestRequestModel extends SingleMapper {
  bool? succeeded;
  LatestRequestDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  LatestRequestModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  LatestRequestModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? LatestRequestDataModel.fromJson(json['data'])
        : null;
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      data['validationErrors'] = validationErrors;
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return LatestRequestModel.fromJson(json);
  }
}

class LatestRequestDataModel {
  int? id;
  String? title;
  String? status;

  LatestRequestDataModel({
    this.id,
    this.title,
    this.status,
  });

  LatestRequestDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    return data;
  }
}

