import 'package:pms_system/core/utility/pms_exports.dart';

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
  String? description;
  String? descriptionStageAr;
  List<BudgetItemModel>? budget;
  OutputsModel? outputs;
  ActivitiesModel? activities;
  ActivitiesPercentModel? activitiesPercent;
  ProgressModel? progress;
  String? statusAr;
  String? statusEn;
  String? status;
  int? statusEnum;
  int? challengesCount;

  MobileChallengesModel? challenges;
  List<MobileRiskModel>? risks;
  List<MobileOutputsSummaryModel>? outputsSummary;
  int? risksCount;
  int? activitiesCount;
  int? outputsCount;
  int? daysLeft;
  List<RelatedItemModel>? relatedItems;
  String? pdfFileUrl;

  ProjectReportDataModel({
    this.details,
    this.description,
    this.descriptionStageAr,
    this.budget,
    this.outputs,
    this.activities,
    this.activitiesPercent,
    this.progress,
    this.statusAr,
    this.statusEn,
    this.statusEnum,
    this.status,
    this.challenges,
    this.challengesCount,
    this.risks,
    this.outputsSummary,
    this.risksCount,
    this.activitiesCount,
    this.outputsCount,
    this.daysLeft,
    this.relatedItems,
    this.pdfFileUrl,
  });

  ProjectReportDataModel.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? ProjectReportDetailsModel.fromJson(json['details'])
        : null;
    description = json['description'];
    pdfFileUrl = json['pdfFileUrl'];
    status = json['status'];
    descriptionStageAr = json['descriptionStageAr'];
    if (json['budget'] != null) {
      budget = <BudgetItemModel>[];
      json['budget'].forEach((v) {
        budget!.add(BudgetItemModel.fromJson(v));
      });
    }

    outputs = json['outputs'] != null
        ? OutputsModel.fromJson(json['outputs'])
        : null;
    activities = json['activities'] != null
        ? ActivitiesModel.fromJson(json['activities'])
        : null;
    activitiesPercent = json['activitiesPercent'] != null
        ? ActivitiesPercentModel.fromJson(json['activitiesPercent'])
        : null;
    progress = json['progress'] != null
        ? ProgressModel.fromJson(json['progress'])
        : null;
    statusAr = json['statusAr'];
    statusEn = json['statusEn'];
    statusEnum = json['statusEnum'];
    challenges = json['challenges'] != null
        ? MobileChallengesModel.fromJson(json['challenges'])
        : null;
    if (json['risks'] != null) {
      risks = <MobileRiskModel>[];
      json['risks'].forEach((v) {
        risks!.add(MobileRiskModel.fromJson(v));
      });
    }
    if (json['outputsSummary'] != null) {
      outputsSummary = <MobileOutputsSummaryModel>[];
      json['outputsSummary'].forEach((v) {
        outputsSummary!.add(MobileOutputsSummaryModel.fromJson(v));
      });
    }
    challengesCount = json['challengesCount'];
    risksCount = json['risksCount'];
    activitiesCount = json['activitiesCount'];
    outputsCount = json['outputsCount'];
    daysLeft = json['daysLeft'];
    if (json['relatedItems'] != null) {
      relatedItems = <RelatedItemModel>[];
      json['relatedItems'].forEach((v) {
        relatedItems!.add(RelatedItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (details != null) map['details'] = details!.toJson();
    if (description != null) map['description'] = description;
    if (status != null) map['status'] = status;
    if (pdfFileUrl != null) map['pdfFileUrl'] = pdfFileUrl;
    if (descriptionStageAr != null) {
      map['descriptionStageAr'] = descriptionStageAr;
    }
    if (budget != null) {
      map['budget'] = budget!.map((v) => v.toJson()).toList();
    }
    if (outputs != null) map['outputs'] = outputs!.toJson();
    if (activities != null) map['activities'] = activities!.toJson();
    if (activitiesPercent != null) {
      map['activitiesPercent'] = activitiesPercent!.toJson();
    }
    if (progress != null) map['progress'] = progress!.toJson();
    if (statusAr != null) map['statusAr'] = statusAr;
    if (statusEn != null) map['statusEn'] = statusEn;
    if (statusEnum != null) map['statusEnum'] = statusEnum;
    challenges = map['challenges'] != null
        ? MobileChallengesModel.fromJson(map['challenges'])
        : null;
    if (map['risks'] != null) {
      risks = <MobileRiskModel>[];
      map['risks'].forEach((v) {
        risks!.add(MobileRiskModel.fromJson(v));
      });
    }
    if (outputsSummary != null) {
      map['outputsSummary'] = outputsSummary!.map((v) => v.toJson()).toList();
    }
    if (challengesCount != null) map['challengesCount'] = challengesCount;
    if (risksCount != null) map['risksCount'] = risksCount;
    if (activitiesCount != null) map['activitiesCount'] = activitiesCount;
    if (outputsCount != null) map['outputsCount'] = outputsCount;
    if (daysLeft != null) map['daysLeft'] = daysLeft;
    if (relatedItems != null) {
      map['relatedItems'] = relatedItems!.map((v) => v.toJson()).toList();
    }
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
