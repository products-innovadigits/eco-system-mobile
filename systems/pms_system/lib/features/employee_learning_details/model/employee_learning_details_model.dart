import 'package:pms_system/core/utility/pms_exports.dart';

// ---------------------------------------------------------------------------
// API response model – GET users/{userId}/review-cycles?id={appraisalId}
// ---------------------------------------------------------------------------

class ReviewCyclesModel extends SingleMapper {
  List<ReviewCycleItemModel>? data;

  ReviewCyclesModel({this.data});

  ReviewCyclesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      data = <ReviewCycleItemModel>[];
      (json['data'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          data!.add(ReviewCycleItemModel.fromJson(v));
        }
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      ReviewCyclesModel.fromJson(json);
}

class ReviewCycleItemModel {
  int? id;
  String? name;
  String? startDate;
  String? closedDate;
  dynamic isLearningAssignmentSent;
  ReviewCycleReportModel? report;

  ReviewCycleItemModel({
    this.id,
    this.name,
    this.startDate,
    this.closedDate,
    this.isLearningAssignmentSent,
    this.report,
  });

  ReviewCycleItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['start_date'];
    closedDate = json['closed_date'];
    isLearningAssignmentSent = json['is_learning_assignment_sent'];
    report = json['report'] != null
        ? ReviewCycleReportModel.fromJson(
            json['report'] as Map<String, dynamic>,
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['start_date'] = startDate;
    data['closed_date'] = closedDate;
    data['is_learning_assignment_sent'] = isLearningAssignmentSent;
    if (report != null) data['report'] = report!.toJson();
    return data;
  }
}

class ReviewCycleReportModel {
  double? finalScore;
  ReportAreaModel? weakestArea;
  ReportAreaModel? strongestArea;
  ReportAreaModel? weakestFactor;
  ReportAreaModel? strongestFactor;

  ReviewCycleReportModel({
    this.finalScore,
    this.weakestArea,
    this.strongestArea,
    this.weakestFactor,
    this.strongestFactor,
  });

  ReviewCycleReportModel.fromJson(Map<String, dynamic> json) {
    finalScore = (json['final_score'] as num?)?.toDouble();
    weakestArea = json['weakest_area'] != null
        ? ReportAreaModel.fromJson(json['weakest_area'] as Map<String, dynamic>)
        : null;
    strongestArea = json['strongest_area'] != null
        ? ReportAreaModel.fromJson(
            json['strongest_area'] as Map<String, dynamic>,
          )
        : null;
    weakestFactor = json['weakest_factor'] != null
        ? ReportAreaModel.fromJson(
            json['weakest_factor'] as Map<String, dynamic>,
          )
        : null;
    strongestFactor = json['strongest_factor'] != null
        ? ReportAreaModel.fromJson(
            json['strongest_factor'] as Map<String, dynamic>,
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['final_score'] = finalScore;
    if (weakestArea != null) data['weakest_area'] = weakestArea!.toJson();
    if (strongestArea != null) {
      data['strongest_area'] = strongestArea!.toJson();
    }
    if (weakestFactor != null) {
      data['weakest_factor'] = weakestFactor!.toJson();
    }
    if (strongestFactor != null) {
      data['strongest_factor'] = strongestFactor!.toJson();
    }
    return data;
  }
}

class ReportAreaModel {
  double? avg;
  String? name;

  ReportAreaModel({this.avg, this.name});

  ReportAreaModel.fromJson(Map<String, dynamic> json) {
    avg = (json['avg'] as num?)?.toDouble();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avg'] = avg;
    data['name'] = name;
    return data;
  }
}

// ---------------------------------------------------------------------------
// API response model – GET users/{userId}/last-review-cycle-report?id={appraisalId}
// ---------------------------------------------------------------------------

class LastReviewCycleReportModel extends SingleMapper {
  int? id;
  String? createdAt;
  String? name;
  ReviewCycleReportModel? reportData;

  LastReviewCycleReportModel({
    this.id,
    this.createdAt,
    this.name,
    this.reportData,
  });

  LastReviewCycleReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    reportData = json['report_data'] != null
        ? ReviewCycleReportModel.fromJson(
            json['report_data'] as Map<String, dynamic>,
          )
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    if (reportData != null) data['report_data'] = reportData!.toJson();
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      LastReviewCycleReportModel.fromJson(json);
}

// ---------------------------------------------------------------------------
// UI aggregate model (composed in the bloc from both API responses)
// ---------------------------------------------------------------------------

class EmployeeLearningDetailsModel {
  EmployeeLearningDetailsModel({
    this.employeeName,
    this.highestCompetency,
    this.lowestCompetency,
    this.reviewCycles = const [],
  });

  final String? employeeName;
  final CompetencyItem? highestCompetency;
  final CompetencyItem? lowestCompetency;
  final List<ReviewCycleItem> reviewCycles;
}

class CompetencyItem {
  CompetencyItem({required this.name, required this.score, this.maxScore = 5});

  final String name;
  final double score;
  final double maxScore;

  String get scoreLabel => '(${score.toStringAsFixed(2)}/$maxScore)';
}

class ReviewCycleItem {
  ReviewCycleItem({
    required this.id,
    required this.name,
    this.startDate,
    this.closedDate,
    this.isLearningAssignmentSent = false,
    this.report,
  });

  final int id;
  final String name;
  final DateTime? startDate;
  final String? closedDate;
  final bool isLearningAssignmentSent;
  final ReviewCycleReportModel? report;

  factory ReviewCycleItem.fromApiModel(ReviewCycleItemModel model) {
    return ReviewCycleItem(
      id: model.id ?? 0,
      name: model.name ?? '',
      startDate: model.startDate != null
          ? DateTime.tryParse(model.startDate!)
          : null,
      closedDate: model.closedDate,
      isLearningAssignmentSent:
          model.isLearningAssignmentSent == true ||
          model.isLearningAssignmentSent == 1,
      report: model.report,
    );
  }
}
