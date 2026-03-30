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

// ---------------------------------------------------------------------------
// API response model – GET appraisal/review-cycles/{cycleId}/summary
// ---------------------------------------------------------------------------

class CycleSummaryResponseModel extends SingleMapper {
  int? status;
  String? message;
  CycleSummaryDataModel? data;

  CycleSummaryResponseModel({this.status, this.message, this.data});

  CycleSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null && json['data'] is Map<String, dynamic>
        ? CycleSummaryDataModel.fromJson(json['data'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      CycleSummaryResponseModel.fromJson(json);
}

class CycleSummaryDataModel {
  int? id;
  String? name;
  String? state;
  int? overallProgress;
  int? completedCount;
  int? totalCount;
  int? reviewersCount;
  RoleGroupInfoModel? managers;
  RoleGroupInfoModel? directReports;
  RoleGroupInfoModel? peers;

  CycleSummaryDataModel({
    this.id,
    this.name,
    this.state,
    this.overallProgress,
    this.completedCount,
    this.totalCount,
    this.reviewersCount,
    this.managers,
    this.directReports,
    this.peers,
  });

  CycleSummaryDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    overallProgress = json['overall_progress'];
    completedCount = json['completed_count'];
    totalCount = json['total_count'];
    reviewersCount = json['reviewers_count'];
    managers =
        json['managers'] != null && json['managers'] is Map<String, dynamic>
        ? RoleGroupInfoModel.fromJson(json['managers'])
        : null;
    directReports =
        json['direct_reports'] != null &&
            json['direct_reports'] is Map<String, dynamic>
        ? RoleGroupInfoModel.fromJson(json['direct_reports'])
        : null;
    peers = json['peers'] != null && json['peers'] is Map<String, dynamic>
        ? RoleGroupInfoModel.fromJson(json['peers'])
        : null;
  }

  CycleDetailDataModel toCycleDetailDataModel({
    List<CycleRevieweeModel>? reviewees,
  }) {
    final roleGroups = <CycleRoleGroupModel>[];
    if (managers != null && (managers!.count ?? 0) > 0) {
      roleGroups.add(
        CycleRoleGroupModel(
          role: 'Managers',
          count: managers!.count,
          dueDate: managers!.deadlineDate,
        ),
      );
    }
    if (directReports != null && (directReports!.count ?? 0) > 0) {
      roleGroups.add(
        CycleRoleGroupModel(
          role: 'Direct Reports',
          count: directReports!.count,
          dueDate: directReports!.deadlineDate,
        ),
      );
    }
    if (peers != null && (peers!.count ?? 0) > 0) {
      roleGroups.add(
        CycleRoleGroupModel(
          role: 'Peers',
          count: peers!.count,
          dueDate: peers!.deadlineDate,
        ),
      );
    }

    return CycleDetailDataModel(
      id: id,
      title: name,
      status: state,
      overallProgress: overallProgress?.toDouble(),
      completedCount: completedCount,
      totalCount: totalCount,
      revieweesCount: reviewersCount,
      reviewees: reviewees,
      roleGroups: roleGroups,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    data['overall_progress'] = overallProgress;
    data['completed_count'] = completedCount;
    data['total_count'] = totalCount;
    data['reviewers_count'] = reviewersCount;
    if (managers != null) data['managers'] = managers!.toJson();
    if (directReports != null) data['direct_reports'] = directReports!.toJson();
    if (peers != null) data['peers'] = peers!.toJson();
    return data;
  }
}

class RoleGroupInfoModel {
  int? count;
  int? deadline;
  String? deadlineDate;

  RoleGroupInfoModel({this.count, this.deadline, this.deadlineDate});

  RoleGroupInfoModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    deadline = json['deadline'];
    deadlineDate = json['deadline_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['deadline'] = deadline;
    data['deadline_date'] = deadlineDate;
    return data;
  }
}

// ---------------------------------------------------------------------------
// API response model – GET appraisal/review-cycles/{cycleId}/reviewee-status
// ---------------------------------------------------------------------------

class RevieweeStatusResponseModel extends SingleMapper {
  List<RevieweeStatusItemModel>? data;
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  RevieweeStatusResponseModel({
    this.data,
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
  });

  RevieweeStatusResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      data = <RevieweeStatusItemModel>[];
      (json['data'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          data!.add(RevieweeStatusItemModel.fromJson(v));
        }
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    perPage = json['per_page'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['total'] = total;
    map['per_page'] = perPage;
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      RevieweeStatusResponseModel.fromJson(json);
}

class RevieweeStatusItemModel {
  int? id;
  String? name;
  String? jobTitle;
  String? avatar;
  int? overallProgress;
  int? completedCount;
  int? totalCount;
  List<RevieweeTypeModel>? types;

  RevieweeStatusItemModel({
    this.id,
    this.name,
    this.jobTitle,
    this.avatar,
    this.overallProgress,
    this.completedCount,
    this.totalCount,
    this.types,
  });

  RevieweeStatusItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobTitle = json['job_title'];
    avatar = json['avatar'];
    overallProgress = json['overall_progress'];
    completedCount = json['completed_count'];
    totalCount = json['total_count'];
    if (json['types'] != null && json['types'] is List) {
      types = <RevieweeTypeModel>[];
      (json['types'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          types!.add(RevieweeTypeModel.fromJson(v));
        }
      });
    }
  }

  CycleRevieweeModel toCycleRevieweeModel() {
    return CycleRevieweeModel(
      id: id,
      name: name,
      jobTitle: jobTitle,
      imageUrl: avatar,
      completedReviews: completedCount,
      totalReviews: totalCount,
      overallPercentage: overallProgress?.toDouble(),
      reviews: types?.map((t) => t.toCycleReviewTypeModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['job_title'] = jobTitle;
    data['avatar'] = avatar;
    data['overall_progress'] = overallProgress;
    data['completed_count'] = completedCount;
    data['total_count'] = totalCount;
    if (types != null) data['types'] = types!.map((v) => v.toJson()).toList();
    return data;
  }
}

class RevieweeTypeModel {
  String? name;
  int? progress;
  int? completedCount;
  int? totalCount;
  List<RevieweeReviewerModel>? reviewers;

  RevieweeTypeModel({
    this.name,
    this.progress,
    this.completedCount,
    this.totalCount,
    this.reviewers,
  });

  RevieweeTypeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    progress = json['progress'];
    completedCount = json['completed_count'];
    totalCount = json['total_count'];
    if (json['reviewers'] != null && json['reviewers'] is List) {
      reviewers = <RevieweeReviewerModel>[];
      (json['reviewers'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          reviewers!.add(RevieweeReviewerModel.fromJson(v));
        }
      });
    }
  }

  CycleReviewTypeModel toCycleReviewTypeModel() {
    return CycleReviewTypeModel(
      type: name,
      percentage: progress?.toDouble(),
      completedCount: completedCount,
      totalCount: totalCount,
      reviewers: reviewers?.map((r) => r.toCycleReviewerInfoModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['progress'] = progress;
    data['completed_count'] = completedCount;
    data['total_count'] = totalCount;
    if (reviewers != null) {
      data['reviewers'] = reviewers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RevieweeReviewerModel {
  int? id;
  String? name;
  String? avatar;
  String? status;
  bool? overdue;
  String? teams;

  RevieweeReviewerModel({
    this.id,
    this.name,
    this.avatar,
    this.status,
    this.overdue,
    this.teams,
  });

  RevieweeReviewerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    status = json['status'];
    overdue = json['overdue'];
    teams = json['teams'];
  }

  CycleReviewerInfoModel toCycleReviewerInfoModel() {
    String? mappedStatus = status;
    if (overdue == true) {
      mappedStatus = 'Overdue';
    } else if (status != null) {
      switch (status!.toLowerCase()) {
        case 'completed':
          mappedStatus = 'Completed';
        case 'not started':
          mappedStatus = 'Not Started';
        default:
          mappedStatus = status;
      }
    }
    return CycleReviewerInfoModel(
      id: id,
      name: name,
      imageUrl: avatar,
      status: mappedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['status'] = status;
    data['overdue'] = overdue;
    data['teams'] = teams;
    return data;
  }
}
