import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectDetailsModel extends SingleMapper {
  bool? succeeded;
  ProjectDetailsDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectDetailsModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? ProjectDetailsDataModel.fromJson(json['data'])
        : null;
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['succeeded'] = succeeded;
    if (data != null) result['data'] = data!.toJson();
    result['warningErrors'] = warningErrors;
    if (validationErrors != null) result['validationErrors'] = validationErrors;
    return result;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectDetailsModel.fromJson(json);
  }
}

class ProjectDetailsDataModel {
  int? id;
  String? title;
  String? riskLevelName;
  num? deliveredOutputs;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? lifeCycleId;
  ProjectLifeCycleModel? projectLifeCycle;
  int? projectCategoryId;
  num? budget;
  double? weight;
  double? progressRatio;
  List<String>? teamIds;
  SectionDepartmentModel? sectionDepartment;
  List<TeamModel>? teamName;
  int? implementorDepartmentId;
  String? implementorDepartmentName;
  String? managerId;
  String? status;
  String? statusAr;
  String? statusEn;
  String? managerName;
  String? periortyLevelName;
  String? priorityLevelName;
  String? projectCategoryName;
  int? priorityLevelId;
  int? riskLevelId;
  List<dynamic>? initiativeIds;
  List<dynamic>? kpiIds;
  int? outputCount;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  MobileDetailsModel? mobileDetails;
  int? sectionDepartmentId;
  dynamic archivedBy;
  dynamic dateArchiving;
  List<dynamic>? projectComments;
  List<SavedDocumentModel>? savedDocuments;
  List<dynamic>? risks;
  List<dynamic>? challenges;
  List<ProjectOutputModel>? outputs;
  dynamic sortOption;
  int? daysLeft;

  ProjectDetailsDataModel({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.riskLevelName,
    this.deliveredOutputs,
    this.endDate,
    this.weight,
    this.lifeCycleId,
    this.projectLifeCycle,
    this.projectCategoryId,
    this.budget,
    this.teamIds,
    this.sectionDepartment,
    this.teamName,
    this.periortyLevelName,
    this.priorityLevelName,
    this.implementorDepartmentId,
    this.implementorDepartmentName,
    this.managerId,
    this.status,
    this.statusAr,
    this.statusEn,
    this.progressRatio,
    this.managerName,
    this.projectCategoryName,
    this.priorityLevelId,
    this.riskLevelId,
    this.initiativeIds,
    this.kpiIds,
    this.outputCount,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.mobileDetails,
    this.sectionDepartmentId,
    this.archivedBy,
    this.dateArchiving,
    this.projectComments,
    this.savedDocuments,
    this.risks,
    this.challenges,
    this.outputs,
    this.sortOption,
    this.daysLeft,
  });

  ProjectDetailsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    riskLevelName = json['riskLevelName'];
    deliveredOutputs = json['deliveredOutputs'];
    startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    lifeCycleId = json['lifeCycleId'];
    projectLifeCycle = json['projectLifeCycle'] != null
        ? ProjectLifeCycleModel.fromJson(json['projectLifeCycle'])
        : null;
    projectCategoryId = json['projectCategoryId'];
    weight = (json['weight'] as num?)?.toDouble();
    budget = json['budget'];
    progressRatio = (json['progressRation'] as num?)?.toDouble();
    teamIds = json['teamIds'] != null
        ? List<String>.from(json['teamIds'])
        : null;
    sectionDepartmentId = json['sectionDepartmentId'];
    sectionDepartment = json['sectionDepartment'] != null
        ? SectionDepartmentModel.fromJson(json['sectionDepartment'])
        : null;

    if (json['teamName'] != null) {
      teamName = <TeamModel>[];
      json['teamName'].forEach((v) {
        teamName!.add(TeamModel.fromJson(v));
      });
    }

    implementorDepartmentId = json['implementorDepartmentId'];
    implementorDepartmentName = json['implementorDepartmentName'];
    managerId = json['managerId'];
    status = json['status'];
    statusAr = json['statusAr'];
    statusEn = json['statusEn'];
    managerName = json['managerName'];
    periortyLevelName = json['periortyLevelName'];
    priorityLevelName = json['priorityLevelName'];
    projectCategoryName = json['projectCategoryName'];
    priorityLevelId = json['periortyLevelId'];
    riskLevelId = json['riskLevelId'];
    outputCount = json['outputCount'];
    archivedBy = json['archivedBy'];
    dateArchiving = json['dateArchiving'];
    sortOption = json['sortOption'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    mobileDetails = json['mobileDetails'] != null
        ? MobileDetailsModel.fromJson(json['mobileDetails'])
        : null;

    projectComments = json['projectComments'] != null
        ? List<dynamic>.from(json['projectComments'])
        : null;

    if (json['savedDocuments'] != null) {
      savedDocuments = <SavedDocumentModel>[];
      json['savedDocuments'].forEach((v) {
        savedDocuments!.add(SavedDocumentModel.fromJson(v));
      });
    }

    risks = json['risks'] != null
        ? List<dynamic>.from(json['risks'])
        : null;

    challenges = json['challenges'] != null
        ? List<dynamic>.from(json['challenges'])
        : null;

    if (json['outputs'] != null) {
      outputs = <ProjectOutputModel>[];
      json['outputs'].forEach((v) {
        outputs!.add(ProjectOutputModel.fromJson(v));
      });
    }

    daysLeft = json['mobileDetails'] != null
        ? json['mobileDetails']['daysLeft']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['riskLevelName'] = riskLevelName;
    data['deliveredOutputs'] = deliveredOutputs;
    data['description'] = description;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['lifeCycleId'] = lifeCycleId;
    if (projectLifeCycle != null) {
      data['projectLifeCycle'] = projectLifeCycle!.toJson();
    }
    data['projectCategoryId'] = projectCategoryId;
    data['weight'] = weight;
    data['budget'] = budget;
    data['teamIds'] = teamIds;
    data['sectionDepartmentId'] = sectionDepartmentId;
    data['sectionDepartment'] = sectionDepartment?.toJson();
    if (teamName != null) {
      data['teamName'] = teamName!.map((v) => v.toJson()).toList();
    }
    data['implementorDepartmentId'] = implementorDepartmentId;
    data['implementorDepartmentName'] = implementorDepartmentName;
    data['managerId'] = managerId;
    data['status'] = status;
    data['statusAr'] = statusAr;
    data['statusEn'] = statusEn;
    data['progressRation'] = progressRatio;
    data['managerName'] = managerName;
    data['periortyLevelName'] = periortyLevelName;
    data['priorityLevelName'] = priorityLevelName;
    data['projectCategoryName'] = projectCategoryName;
    data['periortyLevelId'] = priorityLevelId;
    data['riskLevelId'] = riskLevelId;
    data['outputCount'] = outputCount;
    data['archivedBy'] = archivedBy;
    data['dateArchiving'] = dateArchiving;
    data['sortOption'] = sortOption;
    data['projectComments'] = projectComments;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['mobileDetails'] = mobileDetails?.toJson();
    if (savedDocuments != null) {
      data['savedDocuments'] = savedDocuments!.map((v) => v.toJson()).toList();
    }
    data['risks'] = risks;
    data['challenges'] = challenges;
    if (outputs != null) {
      data['outputs'] = outputs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectLifeCycleModel {
  int? id;
  String? title;
  String? description;
  List<ProjectStagesModel>? projectStages;

  ProjectLifeCycleModel({
    this.id,
    this.title,
    this.description,
    this.projectStages,
  });

  ProjectLifeCycleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    if (json['projectStages'] != null) {
      projectStages = <ProjectStagesModel>[];
      json['projectStages'].forEach((v) {
        projectStages!.add(ProjectStagesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    if (projectStages != null) {
      data['projectStages'] = projectStages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectStagesModel {
  int? id;
  String? title;
  String? description;
  int? lifeCycleId;
  double? progress;
  List<ProjectProcessModel>? projectProcesses;

  ProjectStagesModel({
    this.id,
    this.title,
    this.description,
    this.lifeCycleId,
    this.progress,
    this.projectProcesses,
  });

  ProjectStagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    lifeCycleId = json['lifeCycleId'];
    progress = double.tryParse((json['progress']?.toString() ?? "0"));
    if (json['projectProcesses'] != null) {
      projectProcesses = <ProjectProcessModel>[];
      json['projectProcesses'].forEach((v) {
        projectProcesses!.add(ProjectProcessModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['lifeCycleId'] = lifeCycleId;
    data['progress'] = progress;
    if (projectProcesses != null) {
      data['projectProcesses'] = projectProcesses!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ProjectProcessModel {
  int? id;
  String? title;
  String? description;
  int? stageId;
  int? departmentId;
  int? workflowId;
  dynamic workflow;
  int? viewOrder;
  double? progress;
  bool? isRunningWorkflow;
  bool? isCompletedWorkflow;
  String? runningWorkflowTime;
  String? completedWorkflowTime;
  String? workFlowStatus;
  List<ProcessStepsModel>? processSteps;

  ProjectProcessModel({
    this.id,
    this.title,
    this.description,
    this.stageId,
    this.departmentId,
    this.workflowId,
    this.workflow,
    this.viewOrder,
    this.progress,
    this.isRunningWorkflow,
    this.isCompletedWorkflow,
    this.runningWorkflowTime,
    this.completedWorkflowTime,
    this.workFlowStatus,
    this.processSteps,
  });

  ProjectProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    stageId = json['stageId'];
    departmentId = json['departmentId'];
    workflowId = json['workflowId'];
    workflow = json['workflow'];
    viewOrder = json['viewOrder'];
    progress = double.tryParse((json['progress']?.toString() ?? "0"));
    isRunningWorkflow = json['isRunningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    runningWorkflowTime = json['runningWorkflowTime'];
    completedWorkflowTime = json['completedWorkflowTime'];
    workFlowStatus = json['workFlowStatus'];
    if (json['processSteps'] != null) {
      processSteps = <ProcessStepsModel>[];
      json['processSteps'].forEach((v) {
        processSteps?.add(ProcessStepsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['stageId'] = stageId;
    data['departmentId'] = departmentId;
    data['workflowId'] = workflowId;
    data['workflow'] = workflow;
    data['viewOrder'] = viewOrder;
    data['progress'] = progress;
    data['isRunningWorkflow'] = isRunningWorkflow;
    data['isCompletedWorkflow'] = isCompletedWorkflow;
    data['runningWorkflowTime'] = runningWorkflowTime;
    data['completedWorkflowTime'] = completedWorkflowTime;
    data['workFlowStatus'] = workFlowStatus;
    if (processSteps != null) {
      data['processSteps'] = processSteps?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SectionDepartmentModel {
  int? id;
  String? name;
  String? description;
  String? manager;
  int? projectCount;

  SectionDepartmentModel({
    this.id,
    this.name,
    this.description,
    this.manager,
    this.projectCount,
  });

  SectionDepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    manager = json['manager'];
    projectCount = json['projectCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['manager'] = manager;
    data['projectCount'] = projectCount;
    return data;
  }
}

class TeamModel {
  String? id;
  String? name;

  TeamModel({this.id, this.name});

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ProcessStepsModel {
  int? id;
  String? title;
  bool? isCompleted;

  ProcessStepsModel({this.id, this.title, this.isCompleted});

  ProcessStepsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    return data;
  }
}

// Mobile Details Models
class MobileDetailsModel {
  List<MobileBudgetModel>? budget;
  List<MobileBudgetTotalsModel>? budgetTotals;
  List<MobileOutputsSummaryModel>? outputsSummary;
  MobileProgressModel? progress;
  String? status;
  MobileChallengesModel? challenges;
  List<MobileRiskModel>? risks;

  // newly wired: workflow block from JSON
  MobileWorkflowModel? workflow;

  MobileDetailsModel({
    this.budget,
    this.budgetTotals,
    this.outputsSummary,
    this.progress,
    this.status,
    this.challenges,
    this.risks,
    this.workflow,
  });

  MobileDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['budget'] != null) {
      budget = <MobileBudgetModel>[];
      json['budget'].forEach((v) {
        budget!.add(MobileBudgetModel.fromJson(v));
      });
    }
    if (json['budgetTotals'] != null) {
      budgetTotals = <MobileBudgetTotalsModel>[];
      json['budgetTotals'].forEach((v) {
        budgetTotals!.add(MobileBudgetTotalsModel.fromJson(v));
      });
    }
    if (json['outputsSummary'] != null) {
      outputsSummary = <MobileOutputsSummaryModel>[];
      json['outputsSummary'].forEach((v) {
        outputsSummary!.add(MobileOutputsSummaryModel.fromJson(v));
      });
    }
    progress = json['progress'] != null
        ? MobileProgressModel.fromJson(json['progress'])
        : null;
    status = json['status'];
    challenges = json['challenges'] != null
        ? MobileChallengesModel.fromJson(json['challenges'])
        : null;
    if (json['risks'] != null) {
      risks = <MobileRiskModel>[];
      json['risks'].forEach((v) {
        risks!.add(MobileRiskModel.fromJson(v));
      });
    }
    workflow = json['workflow'] != null
        ? MobileWorkflowModel.fromJson(json['workflow'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (budget != null) {
      data['budget'] = budget!.map((v) => v.toJson()).toList();
    }
    if (budgetTotals != null) {
      data['budgetTotals'] = budgetTotals!.map((v) => v.toJson()).toList();
    }
    if (outputsSummary != null) {
      data['outputsSummary'] = outputsSummary!.map((v) => v.toJson()).toList();
    }
    data['progress'] = progress?.toJson();
    data['status'] = status;
    data['challenges'] = challenges?.toJson();
    if (risks != null) {
      data['risks'] = risks!.map((v) => v.toJson()).toList();
    }
    data['workflow'] = workflow?.toJson();
    return data;
  }
}

class MobileBudgetModel {
  String? key;
  String? label;
  double? amount; // double
  double? percent; // double
  String? background;

  MobileBudgetModel({
    this.key,
    this.label,
    this.amount,
    this.percent,
    this.background,
  });

  MobileBudgetModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    amount = (json['amount'] as num?)?.toDouble(); // safe cast
    percent = (json['percent'] as num?)?.toDouble(); // safe cast
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['amount'] = amount;
    data['percent'] = percent;
    data['background'] = background;
    return data;
  }
}

class MobileBudgetTotalsModel {
  double? approved;
  double? spent;
  double? penalties;
  double? spentWithPenalties;
  double? remaining;

  MobileBudgetTotalsModel({
    this.approved,
    this.spent,
    this.penalties,
    this.spentWithPenalties,
    this.remaining,
  });

  MobileBudgetTotalsModel.fromJson(Map<String, dynamic> json) {
    approved = (json['approved'] as num?)?.toDouble();
    spent = (json['spent'] as num?)?.toDouble();
    penalties = (json['penalties'] as num?)?.toDouble();
    spentWithPenalties = (json['spentWithPenalties'] as num?)?.toDouble();
    remaining = (json['remaining'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approved'] = approved;
    data['spent'] = spent;
    data['penalties'] = penalties;
    data['spentWithPenalties'] = spentWithPenalties;
    data['remaining'] = remaining;
    return data;
  }
}

class MobileOutputsSummaryModel {
  String? key;
  String? label;
  num? value;
  String? background;
  List<String>? titles;

  MobileOutputsSummaryModel({
    this.key,
    this.label,
    this.value,
    this.background,
    this.titles,
  });

  MobileOutputsSummaryModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
    background = json['background'];
    if (json['titles'] != null) {
      titles = <String>[];
      json['titles'].forEach((v) {
        titles!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['value'] = value;
    data['background'] = background;
    if (titles != null) {
      data['titles'] = titles!.map((v) => v).toList();
    }
    return data;
  }
}

class MobileProgressModel {
  double? averageProgress;
  List<MobileProgressBarModel>? bars;

  MobileProgressModel({this.averageProgress, this.bars});

  MobileProgressModel.fromJson(Map<String, dynamic> json) {
    averageProgress = (json['averageProgress'] as num?)?.toDouble(); // safer
    if (json['bars'] != null) {
      bars = <MobileProgressBarModel>[];
      json['bars'].forEach((v) {
        bars!.add(MobileProgressBarModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['averageProgress'] = averageProgress;
    if (bars != null) {
      data['bars'] = bars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileProgressBarModel {
  String? key;
  String? label;
  String? background;
  double? value;

  MobileProgressBarModel({this.key, this.label, this.background, this.value});

  MobileProgressBarModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    background = json['background'];
    value = (json['value'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['background'] = background;
    data['value'] = value;
    return data;
  }
}

class MobileWorkflowModel {
  num? workflowId;
  num? processId;
  num? groupsCount;
  List<MobileWorkflowGroupModel>? groups;

  MobileWorkflowModel({
    this.workflowId,
    this.processId,
    this.groupsCount,
    this.groups,
  });

  MobileWorkflowModel.fromJson(Map<String, dynamic> json) {
    workflowId = json['workflowId'];
    processId = json['processId'];
    groupsCount = json['groupsCount'];
    if (json['groups'] != null) {
      groups = <MobileWorkflowGroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(MobileWorkflowGroupModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workflowId'] = workflowId;
    data['processId'] = processId;
    data['groupsCount'] = groupsCount;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileWorkflowGroupModel {
  num? groupId;
  String? groupName;
  double? progress; // changed to double?
  List<MobileWorkflowStepModel>? steps;

  MobileWorkflowGroupModel({
    this.groupId,
    this.groupName,
    this.progress,
    this.steps,
  });

  MobileWorkflowGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    progress = (json['progress'] as num?)?.toDouble(); // safe cast
    if (json['steps'] != null) {
      steps = <MobileWorkflowStepModel>[];
      json['steps'].forEach((v) {
        steps!.add(MobileWorkflowStepModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['groupName'] = groupName;
    data['progress'] = progress;
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileWorkflowStepModel {
  num? id;
  String? stepName;
  num? status;

  MobileWorkflowStepModel({this.id, this.stepName, this.status});

  MobileWorkflowStepModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepName = json['stepName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepName'] = stepName;
    data['status'] = status;
    return data;
  }
}

class MobileChallengesModel {
  num? total;
  List<MobileChallengeItemModel>? items;

  MobileChallengesModel({this.total, this.items});

  MobileChallengesModel.fromJson(Map<String, dynamic> json) {
    total = json['challengesTotal'];
    if (json['items'] != null) {
      items = <MobileChallengeItemModel>[];
      json['items'].forEach((v) {
        items!.add(MobileChallengeItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['challengesTotal'] = total;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileChallengeItemModel {
  String? key;
  String? label;
  num? total;
  num? processed;
  String? background;

  MobileChallengeItemModel({
    this.key,
    this.label,
    this.total,
    this.processed,
    this.background,
  });

  MobileChallengeItemModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    total = json['total'];
    processed = json['processed'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['total'] = total;
    data['processed'] = processed;
    data['background'] = background;
    return data;
  }
}

class MobileRiskModel {
  String? key;
  String? label;
  num? value;
  String? background;

  MobileRiskModel({this.key, this.label, this.value, this.background});

  MobileRiskModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['value'] = value;
    data['background'] = background;
    return data;
  }
}

class ProjectOutputModel {
  int? id;
  String? title;
  String? description;
  String? filePath;
  int? projectId;
  bool? isDelivered;
  int? workflowId;
  bool? isRuningWorkflow;
  bool? isCompletedWorkflow;
  String? updatedAt;
  String? createdAt;
  String? deliveredAt;
  bool? isHavepenalty;
  dynamic penaltyValue;

  ProjectOutputModel({
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
    this.deliveredAt,
    this.isHavepenalty,
    this.penaltyValue,
  });

  ProjectOutputModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    filePath = json['filePath'];
    projectId = json['projectId'];
    isDelivered = json['isDelivered'];
    workflowId = json['workflowId'];
    isRuningWorkflow = json['isRuningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    deliveredAt = json['deliveredAt'];
    isHavepenalty = json['isHavepenalty'];
    penaltyValue = json['penaltyValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['filePath'] = filePath;
    data['projectId'] = projectId;
    data['isDelivered'] = isDelivered;
    data['workflowId'] = workflowId;
    data['isRuningWorkflow'] = isRuningWorkflow;
    data['isCompletedWorkflow'] = isCompletedWorkflow;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['deliveredAt'] = deliveredAt;
    data['isHavepenalty'] = isHavepenalty;
    data['penaltyValue'] = penaltyValue;
    return data;
  }
}

class SavedDocumentModel {
  int? id;
  int? projectId;
  int? processId;
  int? stepDocumentId;
  String? data;
  DocumentItemModel? document;

  SavedDocumentModel({
    this.id,
    this.projectId,
    this.processId,
    this.stepDocumentId,
    this.data,
    this.document,
  });

  SavedDocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['projectId'];
    processId = json['processId'];
    stepDocumentId = json['stepDocumentId'];
    data = json['data']?.toString();
    document = json['document'] != null
        ? DocumentItemModel.fromJson(json['document'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['projectId'] = projectId;
    result['processId'] = processId;
    result['stepDocumentId'] = stepDocumentId;
    result['data'] = data;
    result['document'] = document?.toJson();
    return result;
  }
}

class DocumentItemModel {
  int? id;
  int? stepDocumentId;
  int? documentCopyId;
  String? documentTitle;
  bool? isActive;
  String? symbol;
  dynamic data;
  String? updatedBy;
  String? updatedAt;
  dynamic exportUrl;

  DocumentItemModel({
    this.id,
    this.stepDocumentId,
    this.documentCopyId,
    this.documentTitle,
    this.isActive,
    this.symbol,
    this.data,
    this.updatedBy,
    this.updatedAt,
    this.exportUrl,
  });

  DocumentItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepDocumentId = json['stepDocumentId'];
    documentCopyId = json['documentCopyId'];
    documentTitle = json['documentTitle'];
    isActive = json['isActive'];
    symbol = json['symbol'];
    data = json['data'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    exportUrl = json['exportUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['stepDocumentId'] = stepDocumentId;
    result['documentCopyId'] = documentCopyId;
    result['documentTitle'] = documentTitle;
    result['isActive'] = isActive;
    result['symbol'] = symbol;
    result['data'] = data;
    result['updatedBy'] = updatedBy;
    result['updatedAt'] = updatedAt;
    result['exportUrl'] = exportUrl;
    return result;
  }
}
