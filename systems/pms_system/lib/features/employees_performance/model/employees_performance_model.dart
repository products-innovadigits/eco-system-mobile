import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeesPerformanceModel extends SingleMapper {
  List<PerformanceEmployeeModel>? data;

  EmployeesPerformanceModel({this.data});

  EmployeesPerformanceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PerformanceEmployeeModel>[];
      json['data'].forEach((v) {
        data!.add(PerformanceEmployeeModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return EmployeesPerformanceModel.fromJson(json);
  }
}

class PerformanceEmployeeModel {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  double? score;
  double? percentage;
  int? reviewCycleId;
  String? reviewCycleName;
  String? closedDate;
  int? rank;

  PerformanceEmployeeModel({
    this.id,
    this.name,
    this.email,
    this.jobTitle,
    this.score,
    this.percentage,
    this.reviewCycleId,
    this.reviewCycleName,
    this.closedDate,
    this.rank,
  });

  PerformanceEmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    jobTitle = json['job_title'];
    score = (json['score'] as num?)?.toDouble();
    percentage = (json['percentage'] as num?)?.toDouble();
    reviewCycleId = json['review_cycle_id'];
    reviewCycleName = json['review_cycle_name'];
    closedDate = json['closed_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['job_title'] = jobTitle;
    data['score'] = score;
    data['percentage'] = percentage;
    data['review_cycle_id'] = reviewCycleId;
    data['review_cycle_name'] = reviewCycleName;
    data['closed_date'] = closedDate;
    return data;
  }
}
