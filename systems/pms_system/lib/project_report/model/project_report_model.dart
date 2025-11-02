import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/project_details/model/project_details_model.dart';

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

/// Data wrapper containing totalCount and items array
class ProjectReportDataModel {
  int? totalCount;
  List<ProjectReportItemModel>? items;

  ProjectReportDataModel({this.totalCount, this.items});

  ProjectReportDataModel.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <ProjectReportItemModel>[];
      json['items'].forEach((v) {
        items!.add(ProjectReportItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (totalCount != null) map['totalCount'] = totalCount;
    if (items != null) {
      map['items'] = items!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Individual project item in the report
class ProjectReportItemModel {
  int? id;
  String? name;
  String? statusAr;
  String? statusEn;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? lifeCycleId;
  dynamic projectLifeCycle;
  int? projectCategoryId;
  String? projectCategoryName;
  num? budget;
  String? archivedBy;
  DateTime? dateArchiving;
  List<String>? teamIds;
  dynamic mobileDetails;
  int? sectionDepartmentId;
  SectionDepartmentModel? sectionDepartment;
  int? implementorDepartmentId;
  String? implementorDepartmentName;
  String? managerId;
  String? status;
  double? progressRation;
  int? deliveredOutputs;
  String? priorityLevelName;
  String? managerName;
  int? periortyLevelId;
  int? riskLevelId;
  List<dynamic>? initiativeIds;
  List<dynamic>? kpiIds;
  int? outputCount;
  List<dynamic>? projectComments;
  List<dynamic>? savedDocuments;
  List<ProjectReportRiskModel>? risks;
  List<ProjectReportChallengeModel>? challenges;
  List<ProjectReportOutputModel>? outputs;
  String? periortyLevelName;
  String? riskLevelName;
  dynamic teamName;
  dynamic sortOption;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  ProjectReportItemModel({
    this.id,
    this.name,
    this.statusAr,
    this.statusEn,
    this.description,
    this.startDate,
    this.endDate,
    this.lifeCycleId,
    this.projectLifeCycle,
    this.projectCategoryId,
    this.projectCategoryName,
    this.budget,
    this.archivedBy,
    this.dateArchiving,
    this.teamIds,
    this.mobileDetails,
    this.sectionDepartmentId,
    this.sectionDepartment,
    this.implementorDepartmentId,
    this.implementorDepartmentName,
    this.managerId,
    this.status,
    this.progressRation,
    this.deliveredOutputs,
    this.priorityLevelName,
    this.managerName,
    this.periortyLevelId,
    this.riskLevelId,
    this.initiativeIds,
    this.kpiIds,
    this.outputCount,
    this.projectComments,
    this.savedDocuments,
    this.risks,
    this.challenges,
    this.outputs,
    this.periortyLevelName,
    this.riskLevelName,
    this.teamName,
    this.sortOption,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  ProjectReportItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    statusAr = json['statusAr'];
    statusEn = json['statusEn'];
    description = json['description'];
    startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    lifeCycleId = json['lifeCycleId'];
    projectLifeCycle = json['projectLifeCycle'];
    projectCategoryId = json['projectCategoryId'];
    projectCategoryName = json['projectCategoryName'];
    budget = json['budget'];
    archivedBy = json['archivedBy'];
    dateArchiving = json['dateArchiving'] != null
        ? DateTime.parse(json['dateArchiving'])
        : null;
    teamIds = json['teamIds'] != null
        ? List<String>.from(json['teamIds'])
        : null;
    mobileDetails = json['mobileDetails'];
    sectionDepartmentId = json['sectionDepartmentId'];
    sectionDepartment = json['sectionDepartment'] != null
        ? SectionDepartmentModel.fromJson(json['sectionDepartment'])
        : null;
    implementorDepartmentId = json['implementorDepartmentId'];
    implementorDepartmentName = json['implementorDepartmentName'];
    managerId = json['managerId'];
    status = json['status'];
    progressRation = (json['progressRation'] as num?)?.toDouble();
    deliveredOutputs = json['deliveredOutputs'];
    priorityLevelName = json['priorityLevelName'];
    managerName = json['managerName'];
    periortyLevelId = json['periortyLevelId'];
    riskLevelId = json['riskLevelId'];
    initiativeIds = json['initiativeIds'] != null
        ? List<dynamic>.from(json['initiativeIds'])
        : null;
    kpiIds = json['kpiIds'] != null ? List<dynamic>.from(json['kpiIds']) : null;
    outputCount = json['outputCount'];
    projectComments = json['projectComments'] != null
        ? List<dynamic>.from(json['projectComments'])
        : null;
    savedDocuments = json['savedDocuments'] != null
        ? List<dynamic>.from(json['savedDocuments'])
        : null;

    if (json['risks'] != null) {
      risks = <ProjectReportRiskModel>[];
      json['risks'].forEach((v) {
        risks!.add(ProjectReportRiskModel.fromJson(v));
      });
    }

    if (json['challenges'] != null) {
      challenges = <ProjectReportChallengeModel>[];
      json['challenges'].forEach((v) {
        challenges!.add(ProjectReportChallengeModel.fromJson(v));
      });
    }

    if (json['outputs'] != null) {
      outputs = <ProjectReportOutputModel>[];
      json['outputs'].forEach((v) {
        outputs!.add(ProjectReportOutputModel.fromJson(v));
      });
    }

    periortyLevelName = json['periortyLevelName'];
    riskLevelName = json['riskLevelName'];
    teamName = json['teamName'];
    sortOption = json['sortOption'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (statusAr != null) map['statusAr'] = statusAr;
    if (statusEn != null) map['statusEn'] = statusEn;
    if (description != null) map['description'] = description;
    if (startDate != null) map['startDate'] = startDate!.toIso8601String();
    if (endDate != null) map['endDate'] = endDate!.toIso8601String();
    if (lifeCycleId != null) map['lifeCycleId'] = lifeCycleId;
    if (projectLifeCycle != null) map['projectLifeCycle'] = projectLifeCycle;
    if (projectCategoryId != null) map['projectCategoryId'] = projectCategoryId;
    if (projectCategoryName != null)
      map['projectCategoryName'] = projectCategoryName;
    if (budget != null) map['budget'] = budget;
    if (archivedBy != null) map['archivedBy'] = archivedBy;
    if (dateArchiving != null)
      map['dateArchiving'] = dateArchiving!.toIso8601String();
    if (teamIds != null) map['teamIds'] = teamIds;
    if (mobileDetails != null) map['mobileDetails'] = mobileDetails;
    if (sectionDepartmentId != null)
      map['sectionDepartmentId'] = sectionDepartmentId;
    if (sectionDepartment != null)
      map['sectionDepartment'] = sectionDepartment!.toJson();
    if (implementorDepartmentId != null) {
      map['implementorDepartmentId'] = implementorDepartmentId;
    }
    if (implementorDepartmentName != null) {
      map['implementorDepartmentName'] = implementorDepartmentName;
    }
    if (managerId != null) map['managerId'] = managerId;
    if (status != null) map['status'] = status;
    if (progressRation != null) map['progressRation'] = progressRation;
    if (deliveredOutputs != null) map['deliveredOutputs'] = deliveredOutputs;
    if (priorityLevelName != null) map['priorityLevelName'] = priorityLevelName;
    if (managerName != null) map['managerName'] = managerName;
    if (periortyLevelId != null) map['periortyLevelId'] = periortyLevelId;
    if (riskLevelId != null) map['riskLevelId'] = riskLevelId;
    if (initiativeIds != null) map['initiativeIds'] = initiativeIds;
    if (kpiIds != null) map['kpiIds'] = kpiIds;
    if (outputCount != null) map['outputCount'] = outputCount;
    if (projectComments != null) map['projectComments'] = projectComments;
    if (savedDocuments != null) map['savedDocuments'] = savedDocuments;
    if (risks != null) map['risks'] = risks!.map((v) => v.toJson()).toList();
    if (challenges != null) {
      map['challenges'] = challenges!.map((v) => v.toJson()).toList();
    }
    if (outputs != null)
      map['outputs'] = outputs!.map((v) => v.toJson()).toList();
    if (periortyLevelName != null) map['periortyLevelName'] = periortyLevelName;
    if (riskLevelName != null) map['riskLevelName'] = riskLevelName;
    if (teamName != null) map['teamName'] = teamName;
    if (sortOption != null) map['sortOption'] = sortOption;
    if (createdBy != null) map['createdBy'] = createdBy;
    if (createdAt != null) map['createdAt'] = createdAt!.toIso8601String();
    if (updatedBy != null) map['updatedBy'] = updatedBy;
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toIso8601String();
    return map;
  }
}

/// Risk model for project report
class ProjectReportRiskModel {
  int? id;
  int? projectId;
  String? riskName;
  String? actionTaken;
  String? description;
  String? note;
  RiskClassificationModel? riskClassification;
  int? riskClassificationId;
  int? statusRiskId;
  RiskStatusModel? riskStatus;
  dynamic riskLevel; // Can be String or int
  String? likelihood;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  ProjectReportRiskModel({
    this.id,
    this.projectId,
    this.riskName,
    this.actionTaken,
    this.description,
    this.note,
    this.riskClassification,
    this.riskClassificationId,
    this.statusRiskId,
    this.riskStatus,
    this.riskLevel,
    this.likelihood,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  ProjectReportRiskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['projectId'];
    riskName = json['riskName'];
    actionTaken = json['actionTaken'];
    description = json['description'];
    note = json['note'];
    riskClassification = json['riskClassification'] != null
        ? RiskClassificationModel.fromJson(json['riskClassification'])
        : null;
    riskClassificationId = json['riskClassificationId'];
    statusRiskId = json['statusRiskId'];
    riskStatus = json['riskStatus'] != null
        ? RiskStatusModel.fromJson(json['riskStatus'])
        : null;
    riskLevel = json['riskLevel'];
    likelihood = json['likelihood'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (projectId != null) map['projectId'] = projectId;
    if (riskName != null) map['riskName'] = riskName;
    if (actionTaken != null) map['actionTaken'] = actionTaken;
    if (description != null) map['description'] = description;
    if (note != null) map['note'] = note;
    if (riskClassification != null) {
      map['riskClassification'] = riskClassification!.toJson();
    }
    if (riskClassificationId != null) {
      map['riskClassificationId'] = riskClassificationId;
    }
    if (statusRiskId != null) map['statusRiskId'] = statusRiskId;
    if (riskStatus != null) map['riskStatus'] = riskStatus!.toJson();
    if (riskLevel != null) map['riskLevel'] = riskLevel;
    if (likelihood != null) map['likelihood'] = likelihood;
    if (createdBy != null) map['createdBy'] = createdBy;
    if (createdAt != null) map['createdAt'] = createdAt!.toIso8601String();
    if (updatedBy != null) map['updatedBy'] = updatedBy;
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toIso8601String();
    return map;
  }
}

class RiskClassificationModel {
  int? id;
  String? name;

  RiskClassificationModel({this.id, this.name});

  RiskClassificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

class RiskStatusModel {
  int? id;
  String? name;

  RiskStatusModel({this.id, this.name});

  RiskStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

/// Challenge model for project report
class ProjectReportChallengeModel {
  int? id;
  String? challengeName;
  int? projectId;
  int? categoryId;
  ChallengeCategoryModel? category;
  int? impactId;
  ChallengeImpactModel? impact;
  int? statusId;
  ChallengeStatusModel? status;
  String? description;
  String? note;
  String? actionTaken;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  ProjectReportChallengeModel({
    this.id,
    this.challengeName,
    this.projectId,
    this.categoryId,
    this.category,
    this.impactId,
    this.impact,
    this.statusId,
    this.status,
    this.description,
    this.note,
    this.actionTaken,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  ProjectReportChallengeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    challengeName = json['challengeName'];
    projectId = json['projectId'];
    categoryId = json['categoryId'];
    category = json['category'] != null
        ? ChallengeCategoryModel.fromJson(json['category'])
        : null;
    impactId = json['impactId'];
    impact = json['impact'] != null
        ? ChallengeImpactModel.fromJson(json['impact'])
        : null;
    statusId = json['statusId'];
    status = json['status'] != null
        ? ChallengeStatusModel.fromJson(json['status'])
        : null;
    description = json['description'];
    note = json['note'];
    actionTaken = json['actionTaken'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (challengeName != null) map['challengeName'] = challengeName;
    if (projectId != null) map['projectId'] = projectId;
    if (categoryId != null) map['categoryId'] = categoryId;
    if (category != null) map['category'] = category!.toJson();
    if (impactId != null) map['impactId'] = impactId;
    if (impact != null) map['impact'] = impact!.toJson();
    if (statusId != null) map['statusId'] = statusId;
    if (status != null) map['status'] = status!.toJson();
    if (description != null) map['description'] = description;
    if (note != null) map['note'] = note;
    if (actionTaken != null) map['actionTaken'] = actionTaken;
    if (createdBy != null) map['createdBy'] = createdBy;
    if (createdAt != null) map['createdAt'] = createdAt!.toIso8601String();
    if (updatedBy != null) map['updatedBy'] = updatedBy;
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toIso8601String();
    return map;
  }
}

class ChallengeCategoryModel {
  int? id;
  String? name;

  ChallengeCategoryModel({this.id, this.name});

  ChallengeCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

class ChallengeImpactModel {
  int? id;
  String? name;

  ChallengeImpactModel({this.id, this.name});

  ChallengeImpactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

class ChallengeStatusModel {
  int? id;
  String? name;

  ChallengeStatusModel({this.id, this.name});

  ChallengeStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

/// Output model for project report
class ProjectReportOutputModel {
  int? id;
  String? title;
  String? description;
  String? filePath;
  int? projectId;
  bool? isDelivered;
  int? workflowId;
  bool? isRuningWorkflow;
  bool? isCompletedWorkflow;
  DateTime? updatedAt;
  DateTime? createdAt;
  bool? isHavepenalty;
  num? penaltyValue;

  ProjectReportOutputModel({
    this.id,
    this.title,
    this.description,
    this.filePath,
    this.projectId,
    this.isDelivered,
    this.workflowId,
    this.isRuningWorkflow,
    this.isCompletedWorkflow,
    this.updatedAt,
    this.createdAt,
    this.isHavepenalty,
    this.penaltyValue,
  });

  ProjectReportOutputModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    filePath = json['filePath'];
    projectId = json['projectId'];
    isDelivered = json['isDelivered'];
    workflowId = json['workflowId'];
    isRuningWorkflow = json['isRuningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null;
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
    isHavepenalty = json['isHavepenalty'];
    penaltyValue = json['penaltyValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (filePath != null) map['filePath'] = filePath;
    if (projectId != null) map['projectId'] = projectId;
    if (isDelivered != null) map['isDelivered'] = isDelivered;
    if (workflowId != null) map['workflowId'] = workflowId;
    if (isRuningWorkflow != null) map['isRuningWorkflow'] = isRuningWorkflow;
    if (isCompletedWorkflow != null) {
      map['isCompletedWorkflow'] = isCompletedWorkflow;
    }
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toIso8601String();
    if (createdAt != null) map['createdAt'] = createdAt!.toIso8601String();
    if (isHavepenalty != null) map['isHavepenalty'] = isHavepenalty;
    if (penaltyValue != null) map['penaltyValue'] = penaltyValue;
    return map;
  }
}
