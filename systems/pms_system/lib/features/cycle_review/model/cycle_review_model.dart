import 'package:pms_system/core/utility/pms_exports.dart';

class CycleDetailModel extends SingleMapper {
  bool? succeeded;
  CycleDetailDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  CycleDetailModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  CycleDetailModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? CycleDetailDataModel.fromJson(json['data'])
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
    return CycleDetailModel.fromJson(json);
  }
}

class CycleDetailDataModel {
  int? id;
  String? title;
  String? subtitle;
  String? status;
  double? overallProgress;
  int? completedCount;
  int? totalCount;
  double? totalScore;
  int? revieweesCount;
  List<CycleRevieweeModel>? reviewees;
  List<CycleRoleGroupModel>? roleGroups;

  CycleDetailDataModel({
    this.id,
    this.title,
    this.subtitle,
    this.status,
    this.overallProgress,
    this.completedCount,
    this.totalCount,
    this.totalScore,
    this.revieweesCount,
    this.reviewees,
    this.roleGroups,
  });

  CycleDetailDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    status = json['status'];
    overallProgress = (json['overallProgress'] as num?)?.toDouble();
    completedCount = json['completedCount'];
    totalCount = json['totalCount'];
    totalScore = (json['totalScore'] as num?)?.toDouble();
    revieweesCount = json['revieweesCount'];
    if (json['reviewees'] != null) {
      reviewees = <CycleRevieweeModel>[];
      json['reviewees'].forEach((v) {
        reviewees!.add(CycleRevieweeModel.fromJson(v));
      });
    }
    if (json['roleGroups'] != null) {
      roleGroups = <CycleRoleGroupModel>[];
      json['roleGroups'].forEach((v) {
        roleGroups!.add(CycleRoleGroupModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['status'] = status;
    data['overallProgress'] = overallProgress;
    data['completedCount'] = completedCount;
    data['totalCount'] = totalCount;
    data['totalScore'] = totalScore;
    data['revieweesCount'] = revieweesCount;
    if (reviewees != null) {
      data['reviewees'] = reviewees!.map((v) => v.toJson()).toList();
    }
    if (roleGroups != null) {
      data['roleGroups'] = roleGroups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CycleRevieweeModel {
  int? id;
  String? name;
  String? jobTitle;
  String? imageUrl;
  int? completedReviews;
  int? totalReviews;
  double? overallPercentage;
  List<CycleReviewTypeModel>? reviews;

  CycleRevieweeModel({
    this.id,
    this.name,
    this.jobTitle,
    this.imageUrl,
    this.completedReviews,
    this.totalReviews,
    this.overallPercentage,
    this.reviews,
  });

  CycleRevieweeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobTitle = json['jobTitle'];
    imageUrl = json['imageUrl'];
    completedReviews = json['completedReviews'];
    totalReviews = json['totalReviews'];
    overallPercentage = (json['overallPercentage'] as num?)?.toDouble();
    if (json['reviews'] != null) {
      reviews = <CycleReviewTypeModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(CycleReviewTypeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['jobTitle'] = jobTitle;
    data['imageUrl'] = imageUrl;
    data['completedReviews'] = completedReviews;
    data['totalReviews'] = totalReviews;
    data['overallPercentage'] = overallPercentage;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CycleReviewTypeModel {
  String? type;
  double? percentage;
  int? completedCount;
  int? totalCount;
  List<CycleReviewerInfoModel>? reviewers;

  CycleReviewTypeModel({
    this.type,
    this.percentage,
    this.completedCount,
    this.totalCount,
    this.reviewers,
  });

  CycleReviewTypeModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    percentage = (json['percentage'] as num?)?.toDouble();
    completedCount = json['completedCount'];
    totalCount = json['totalCount'];
    if (json['reviewers'] != null) {
      reviewers = <CycleReviewerInfoModel>[];
      json['reviewers'].forEach((v) {
        reviewers!.add(CycleReviewerInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['percentage'] = percentage;
    data['completedCount'] = completedCount;
    data['totalCount'] = totalCount;
    if (reviewers != null) {
      data['reviewers'] = reviewers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CycleReviewerInfoModel {
  int? id;
  String? name;
  String? imageUrl;
  String? status;

  CycleReviewerInfoModel({this.id, this.name, this.imageUrl, this.status});

  CycleReviewerInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['status'] = status;
    return data;
  }
}

class CycleRoleGroupModel {
  String? role;
  int? count;
  String? dueDate;
  bool? isCompleted;

  CycleRoleGroupModel({this.role, this.count, this.dueDate, this.isCompleted});

  CycleRoleGroupModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    count = json['count'];
    dueDate = json['dueDate'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['count'] = count;
    data['dueDate'] = dueDate;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
