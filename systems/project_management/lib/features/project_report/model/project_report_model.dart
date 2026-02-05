import 'package:project_management/core/utility/pms_exports.dart';

/// Response wrapper for project report API
class ProjectReportModel extends SingleMapper {
  bool? succeeded;
  ProjectReportDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectReportModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectReportModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? ProjectReportDataModel.fromJson(json['data'])
        : null;
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = List<dynamic>.from(json['validationErrors']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (succeeded != null) map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    if (warningErrors != null) map['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      map['validationErrors'] = validationErrors;
    }
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectReportModel.fromJson(json);
  }
}

/// Main data model for project report
class ProjectReportDataModel {
  ProjectReportDetailsModel? details;
  List<BudgetItemModel>? budget;
  List<BudgetTotalsModel>? budgetTotals;
  ProgressModel? progress;
  String? status;
  dynamic workflow;
  List<MobileOutputsSummaryModel>? outputsSummary;
  MobileChallengesModel? challenges;
  List<MobileRiskModel>? risks;
  int? daysLeft;
  String? statusAr;
  String? statusEn;
  String? statusEnum;
  int? risksCount;
  int? activitiesCount;
  int? outputsCount;
  List<RelatedItemModel>? relatedItems;
  ActivitiesPercentModel? activitiesPercent;
  String? pdfFileUrl;

  ProjectReportDataModel({
    this.details,
    this.budget,
    this.budgetTotals,
    this.progress,
    this.status,
    this.workflow,
    this.outputsSummary,
    this.challenges,
    this.risks,
    this.daysLeft,
    this.statusAr,
    this.statusEn,
    this.statusEnum,
    this.risksCount,
    this.activitiesCount,
    this.outputsCount,
    this.relatedItems,
    this.activitiesPercent,
    this.pdfFileUrl,
  });

  ProjectReportDataModel.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? ProjectReportDetailsModel.fromJson(
            (json['details'] as Map).cast<String, dynamic>(),
          )
        : null;
    if (json['budget'] != null && json['budget'] is List) {
      budget = <BudgetItemModel>[];
      for (var v in (json['budget'] as List)) {
        budget!.add(
          BudgetItemModel.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    if (json['budgetTotals'] != null && json['budgetTotals'] is List) {
      budgetTotals = <BudgetTotalsModel>[];
      for (var v in (json['budgetTotals'] as List)) {
        budgetTotals!.add(
          BudgetTotalsModel.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    progress = json['progress'] != null
        ? ProgressModel.fromJson(
            (json['progress'] as Map).cast<String, dynamic>(),
          )
        : null;
    status = json['status'];
    workflow = json['workflow'];
    if (json['outputsSummary'] != null && json['outputsSummary'] is List) {
      outputsSummary = <MobileOutputsSummaryModel>[];
      for (var v in (json['outputsSummary'] as List)) {
        outputsSummary!.add(
          MobileOutputsSummaryModel.fromJson(
            (v as Map).cast<String, dynamic>(),
          ),
        );
      }
    }
    challenges = json['challenges'] != null
        ? MobileChallengesModel.fromJson(
            (json['challenges'] as Map).cast<String, dynamic>(),
          )
        : null;
    if (json['risks'] != null && json['risks'] is List) {
      risks = <MobileRiskModel>[];
      for (var v in (json['risks'] as List)) {
        risks!.add(
          MobileRiskModel.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    daysLeft = (json['daysLeft'] as num?)?.toInt();
    statusAr = json['statusAr'];
    statusEn = json['statusEn'];
    statusEnum = json['statusEnum']?.toString();
    risksCount = (json['risksCount'] as num?)?.toInt();
    activitiesCount = (json['activitiesCount'] as num?)?.toInt();
    outputsCount = (json['outputsCount'] as num?)?.toInt();
    if (json['relatedItems'] != null && json['relatedItems'] is List) {
      relatedItems = <RelatedItemModel>[];
      for (var v in (json['relatedItems'] as List)) {
        relatedItems!.add(
          RelatedItemModel.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    activitiesPercent = json['activitiesPercent'] != null
        ? ActivitiesPercentModel.fromJson(
            (json['activitiesPercent'] as Map).cast<String, dynamic>(),
          )
        : null;
    pdfFileUrl = json['pdfFileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (details != null) map['details'] = details!.toJson();
    if (budget != null) {
      map['budget'] = budget!.map((v) => v.toJson()).toList();
    }
    if (budgetTotals != null) {
      map['budgetTotals'] = budgetTotals!.map((v) => v.toJson()).toList();
    }
    if (progress != null) map['progress'] = progress!.toJson();
    if (status != null) map['status'] = status;
    if (workflow != null) map['workflow'] = workflow;
    if (outputsSummary != null) {
      map['outputsSummary'] = outputsSummary!.map((v) => v.toJson()).toList();
    }
    if (challenges != null) map['challenges'] = challenges!.toJson();
    if (risks != null) {
      map['risks'] = risks!.map((v) => v.toJson()).toList();
    }
    if (daysLeft != null) map['daysLeft'] = daysLeft;
    if (statusAr != null) map['statusAr'] = statusAr;
    if (statusEn != null) map['statusEn'] = statusEn;
    if (statusEnum != null) map['statusEnum'] = statusEnum;
    if (risksCount != null) map['risksCount'] = risksCount;
    if (activitiesCount != null) map['activitiesCount'] = activitiesCount;
    if (outputsCount != null) map['outputsCount'] = outputsCount;
    if (relatedItems != null) {
      map['relatedItems'] = relatedItems!.map((v) => v.toJson()).toList();
    }
    if (activitiesPercent != null) {
      map['activitiesPercent'] = activitiesPercent!.toJson();
    }
    if (pdfFileUrl != null) map['pdfFileUrl'] = pdfFileUrl;
    return map;
  }
}

/// Project details model
class ProjectReportDetailsModel {
  String? projectName;
  String? managerName;
  DateTime? startDate;
  DateTime? endDate;
  num? approvedBudget;
  String? initiativeCode;
  String? departmentName;
  String? categoryName;
  String? description;
  String? statusAr;

  ProjectReportDetailsModel({
    this.projectName,
    this.managerName,
    this.startDate,
    this.endDate,
    this.approvedBudget,
    this.initiativeCode,
    this.departmentName,
    this.categoryName,
    this.description,
    this.statusAr,
  });

  ProjectReportDetailsModel.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    managerName = json['managerName'];
    startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    approvedBudget = json['approvedBudget'];
    initiativeCode = json['initiativeCode'];
    departmentName = json['departmentName'];
    categoryName = json['categoryName'];
    description = json['description'];
    statusAr = json['statusAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (projectName != null) map['projectName'] = projectName;
    if (managerName != null) map['managerName'] = managerName;
    if (startDate != null) map['startDate'] = startDate!.toIso8601String();
    if (endDate != null) map['endDate'] = endDate!.toIso8601String();
    if (approvedBudget != null) map['approvedBudget'] = approvedBudget;
    if (initiativeCode != null) map['initiativeCode'] = initiativeCode;
    if (departmentName != null) map['departmentName'] = departmentName;
    if (categoryName != null) map['categoryName'] = categoryName;
    if (description != null) map['description'] = description;
    if (statusAr != null) map['statusAr'] = statusAr;
    return map;
  }
}

/// Budget item model
class BudgetItemModel {
  String? key;
  String? label;
  num? amount;
  num? percent;
  String? background;

  BudgetItemModel({
    this.key,
    this.label,
    this.amount,
    this.percent,
    this.background,
  });

  BudgetItemModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    amount = json['amount'];
    percent = json['percent'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (key != null) map['key'] = key;
    if (label != null) map['label'] = label;
    if (amount != null) map['amount'] = amount;
    if (percent != null) map['percent'] = percent;
    if (background != null) map['background'] = background;
    return map;
  }
}

/// Budget totals model
class BudgetTotalsModel {
  num? approved;
  num? spent;
  num? penalties;
  num? spentWithPenalties;
  num? remaining;

  BudgetTotalsModel({
    this.approved,
    this.spent,
    this.penalties,
    this.spentWithPenalties,
    this.remaining,
  });

  BudgetTotalsModel.fromJson(Map<String, dynamic> json) {
    approved = json['approved'];
    spent = json['spent'];
    penalties = json['penalties'];
    spentWithPenalties = json['spentWithPenalties'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (approved != null) map['approved'] = approved;
    if (spent != null) map['spent'] = spent;
    if (penalties != null) map['penalties'] = penalties;
    if (spentWithPenalties != null) {
      map['spentWithPenalties'] = spentWithPenalties;
    }
    if (remaining != null) map['remaining'] = remaining;
    return map;
  }
}

/// Outputs model
class OutputsModel {
  int? total;
  List<OutputItemModel>? completed;
  List<OutputItemModel>? current;
  List<OutputItemModel>? upcoming;
  List<OutputItemModel>? delayed;

  OutputsModel({
    this.total,
    this.completed,
    this.current,
    this.upcoming,
    this.delayed,
  });

  OutputsModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['completed'] != null) {
      completed = <OutputItemModel>[];
      json['completed'].forEach((v) {
        completed!.add(OutputItemModel.fromJson(v));
      });
    }
    if (json['current'] != null) {
      current = <OutputItemModel>[];
      json['current'].forEach((v) {
        current!.add(OutputItemModel.fromJson(v));
      });
    }
    if (json['upcoming'] != null) {
      upcoming = <OutputItemModel>[];
      json['upcoming'].forEach((v) {
        upcoming!.add(OutputItemModel.fromJson(v));
      });
    }
    if (json['delayed'] != null) {
      delayed = <OutputItemModel>[];
      json['delayed'].forEach((v) {
        delayed!.add(OutputItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (total != null) map['total'] = total;
    if (completed != null) {
      map['completed'] = completed!.map((v) => v.toJson()).toList();
    }
    if (current != null) {
      map['current'] = current!.map((v) => v.toJson()).toList();
    }
    if (upcoming != null) {
      map['upcoming'] = upcoming!.map((v) => v.toJson()).toList();
    }
    if (delayed != null) {
      map['delayed'] = delayed!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Output item model
class OutputItemModel {
  int? id;
  String? title;
  String? description;
  DateTime? periodStart;
  DateTime? periodEnd;
  int? days;

  OutputItemModel({
    this.id,
    this.title,
    this.description,
    this.periodStart,
    this.periodEnd,
    this.days,
  });

  OutputItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    periodStart = json['periodStart'] != null
        ? DateTime.parse(json['periodStart'])
        : null;
    periodEnd = json['periodEnd'] != null
        ? DateTime.parse(json['periodEnd'])
        : null;
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (periodStart != null) {
      map['periodStart'] = periodStart!.toIso8601String();
    }
    if (periodEnd != null) map['periodEnd'] = periodEnd!.toIso8601String();
    if (days != null) map['days'] = days;
    return map;
  }
}

/// Activities model
class ActivitiesModel {
  int? total;
  ActivitiesBreakdownModel? breakdown;

  ActivitiesModel({this.total, this.breakdown});

  ActivitiesModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    breakdown = json['breakdown'] != null
        ? ActivitiesBreakdownModel.fromJson(json['breakdown'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (total != null) map['total'] = total;
    if (breakdown != null) map['breakdown'] = breakdown!.toJson();
    return map;
  }
}

/// Activities breakdown model
class ActivitiesBreakdownModel {
  int? done;
  int? advanced;
  int? inProgress;
  int? delayed;

  ActivitiesBreakdownModel({
    this.done,
    this.advanced,
    this.inProgress,
    this.delayed,
  });

  ActivitiesBreakdownModel.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    advanced = json['advanced'];
    inProgress = json['inProgress'];
    delayed = json['delayed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (done != null) map['done'] = done;
    if (advanced != null) map['advanced'] = advanced;
    if (inProgress != null) map['inProgress'] = inProgress;
    if (delayed != null) map['delayed'] = delayed;
    return map;
  }
}

/// Activities percent model
class ActivitiesPercentModel {
  List<ActivityBarModel>? bars;

  ActivitiesPercentModel({this.bars});

  ActivitiesPercentModel.fromJson(Map<String, dynamic> json) {
    if (json['bars'] != null) {
      bars = <ActivityBarModel>[];
      json['bars'].forEach((v) {
        bars!.add(ActivityBarModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (bars != null) {
      map['bars'] = bars!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Activity bar model
class ActivityBarModel {
  String? key;
  String? label;
  String? background;
  num? value;

  ActivityBarModel({this.key, this.label, this.background, this.value});

  ActivityBarModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    background = json['background'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (key != null) map['key'] = key;
    if (label != null) map['label'] = label;
    if (background != null) map['background'] = background;
    if (value != null) map['value'] = value;
    return map;
  }
}

/// Progress model
class ProgressModel {
  num? averageProgress;
  List<ProgressBarModel>? bars;

  ProgressModel({this.averageProgress, this.bars});

  ProgressModel.fromJson(Map<String, dynamic> json) {
    averageProgress = json['averageProgress'];
    if (json['bars'] != null) {
      bars = <ProgressBarModel>[];
      json['bars'].forEach((v) {
        bars!.add(ProgressBarModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (averageProgress != null) map['averageProgress'] = averageProgress;
    if (bars != null) {
      map['bars'] = bars!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Progress bar model
class ProgressBarModel {
  String? key;
  String? label;
  String? background;
  num? value;

  ProgressBarModel({this.key, this.label, this.background, this.value});

  ProgressBarModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    background = json['background'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (key != null) map['key'] = key;
    if (label != null) map['label'] = label;
    if (background != null) map['background'] = background;
    if (value != null) map['value'] = value;
    return map;
  }
}

/// Challenge card model
class ChallengeCardModel {
  String? key;
  String? label;
  int? value;
  String? background;

  ChallengeCardModel({this.key, this.label, this.value, this.background});

  ChallengeCardModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (key != null) map['key'] = key;
    if (label != null) map['label'] = label;
    if (value != null) map['value'] = value;
    if (background != null) map['background'] = background;
    return map;
  }
}

/// Risk card model
class RiskCardModel {
  String? key;
  String? label;
  int? value;
  String? background;

  RiskCardModel({this.key, this.label, this.value, this.background});

  RiskCardModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (key != null) map['key'] = key;
    if (label != null) map['label'] = label;
    if (value != null) map['value'] = value;
    if (background != null) map['background'] = background;
    return map;
  }
}

/// Related item model
class RelatedItemModel {
  String? type;
  int? id;
  String? title;

  RelatedItemModel({this.type, this.id, this.title});

  RelatedItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (type != null) map['type'] = type;
    if (id != null) map['id'] = id;
    if (title != null) map['title'] = title;
    return map;
  }
}
