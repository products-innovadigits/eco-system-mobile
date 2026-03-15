import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeesPerformanceModel extends SingleMapper {
  bool? succeeded;
  EmployeesPerformanceDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  EmployeesPerformanceModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  EmployeesPerformanceModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? EmployeesPerformanceDataModel.fromJson(json['data'])
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
    if (this.data != null) data['data'] = this.data!.toJson();
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) data['validationErrors'] = validationErrors;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return EmployeesPerformanceModel.fromJson(json);
  }
}

class EmployeesPerformanceDataModel {
  List<PerformanceEmployeeModel>? topMonthly;
  List<PerformanceEmployeeModel>? topYearly;
  List<PerformanceEmployeeModel>? top10;

  EmployeesPerformanceDataModel({
    this.topMonthly,
    this.topYearly,
    this.top10,
  });

  EmployeesPerformanceDataModel.fromJson(Map<String, dynamic> json) {
    if (json['topMonthly'] != null) {
      topMonthly = <PerformanceEmployeeModel>[];
      json['topMonthly'].forEach((v) {
        topMonthly!.add(PerformanceEmployeeModel.fromJson(v));
      });
    }
    if (json['topYearly'] != null) {
      topYearly = <PerformanceEmployeeModel>[];
      json['topYearly'].forEach((v) {
        topYearly!.add(PerformanceEmployeeModel.fromJson(v));
      });
    }
    if (json['top10'] != null) {
      top10 = <PerformanceEmployeeModel>[];
      json['top10'].forEach((v) {
        top10!.add(PerformanceEmployeeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topMonthly != null) {
      data['topMonthly'] = topMonthly!.map((v) => v.toJson()).toList();
    }
    if (topYearly != null) {
      data['topYearly'] = topYearly!.map((v) => v.toJson()).toList();
    }
    if (top10 != null) {
      data['top10'] = top10!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PerformanceEmployeeModel {
  int? id;
  String? name;
  String? jobTitle;
  String? imageUrl;
  double? score;
  int? rank;
  String? reportUrl;

  PerformanceEmployeeModel({
    this.id,
    this.name,
    this.jobTitle,
    this.imageUrl,
    this.score,
    this.rank,
    this.reportUrl,
  });

  PerformanceEmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobTitle = json['jobTitle'];
    imageUrl = json['imageUrl'];
    score = (json['score'] as num?)?.toDouble();
    rank = json['rank'];
    reportUrl = json['reportUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['jobTitle'] = jobTitle;
    data['imageUrl'] = imageUrl;
    data['score'] = score;
    data['rank'] = rank;
    data['reportUrl'] = reportUrl;
    return data;
  }
}
