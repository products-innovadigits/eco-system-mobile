import 'package:pms_system/core/utility/pms_exports.dart';

class LatestRequestModel extends SingleMapper {
  bool? succeeded;
  List<LatestRequestItem>? data;
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
    if (json['data'] != null) {
      data = <LatestRequestItem>[];
      json['data'].forEach((v) {
        data!.add(LatestRequestItem.fromJson(v));
      });
    }
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = List<dynamic>.from(json['validationErrors']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class LatestRequestItem {
  int? processId;
  Process? process;
  int? projectId;
  Project? project;
  bool? isRuningWorkflow;
  bool? isCompletedWorkflow;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  LatestRequestItem({
    this.processId,
    this.process,
    this.projectId,
    this.project,
    this.isRuningWorkflow,
    this.isCompletedWorkflow,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  LatestRequestItem.fromJson(Map<String, dynamic> json) {
    processId = json['processId'];
    process = json['process'] != null
        ? Process.fromJson(json['process'])
        : null;
    projectId = json['projectId'];
    project = json['project'] != null
        ? Project.fromJson(json['project'])
        : null;
    isRuningWorkflow = json['isRuningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    id = json['id'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['processId'] = processId;
    if (process != null) {
      data['process'] = process!.toJson();
    }
    data['projectId'] = projectId;
    if (project != null) {
      data['project'] = project!.toJson();
    }
    data['isRuningWorkflow'] = isRuningWorkflow;
    data['isCompletedWorkflow'] = isCompletedWorkflow;
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class Process {
  String? title;
  String? description;
  int? stageId;
  dynamic projectStage;
  int? viewOrder;
  int? departmentId;
  dynamic department;
  int? workflowId;
  dynamic workflow;
  String? filePath;
  List<ProcessStatus>? processStatuses;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  Process({
    this.title,
    this.description,
    this.stageId,
    this.projectStage,
    this.viewOrder,
    this.departmentId,
    this.department,
    this.workflowId,
    this.workflow,
    this.filePath,
    this.processStatuses,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  Process.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    stageId = json['stageId'];
    projectStage = json['projectStage'];
    viewOrder = json['viewOrder'];
    departmentId = json['departmentId'];
    department = json['department'];
    workflowId = json['workflowId'];
    workflow = json['workflow'];
    filePath = json['filePath'];
    if (json['processStatuses'] != null) {
      processStatuses = <ProcessStatus>[];
      json['processStatuses'].forEach((v) {
        processStatuses!.add(ProcessStatus.fromJson(v));
      });
    }
    id = json['id'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['stageId'] = stageId;
    data['projectStage'] = projectStage;
    data['viewOrder'] = viewOrder;
    data['departmentId'] = departmentId;
    data['department'] = department;
    data['workflowId'] = workflowId;
    data['workflow'] = workflow;
    data['filePath'] = filePath;
    if (processStatuses != null) {
      data['processStatuses'] = processStatuses!
          .map((v) => v.toJson())
          .toList();
    }
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class Project {
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  int? lifeCycleId;
  dynamic projectLifeCycle;
  int? projectCategoryId;
  dynamic projectCategory;
  num? budget;
  int? implementorDepartmentId;
  dynamic implementorDepartment;
  String? implementorDepartmentName;
  int? sectionDepartmentId;
  dynamic sectionDepartment;
  String? managerId;
  dynamic manager;
  int? periortyLevelId;
  dynamic archivedBy;
  dynamic dateArchiving;
  dynamic periortyLevel;
  int? riskLevelId;
  dynamic riskLevel;
  int? outputCount;
  dynamic teamUsers;
  dynamic initiativeProjects;
  dynamic kpiProjects;
  dynamic projectComments;
  dynamic savedDocuments;
  dynamic projectProcessTimeLines;
  dynamic projectStageTimeLines;
  dynamic projectOutPuts;
  dynamic sliceDatas;
  dynamic stepStatuses;
  dynamic mainActivities;
  dynamic projectLogs;
  dynamic projectDocuments;
  dynamic projectStepComments;
  dynamic risks;
  dynamic challenges;
  dynamic riskLogs;
  dynamic value;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  Project({
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.lifeCycleId,
    this.projectLifeCycle,
    this.projectCategoryId,
    this.projectCategory,
    this.budget,
    this.implementorDepartmentId,
    this.implementorDepartment,
    this.implementorDepartmentName,
    this.sectionDepartmentId,
    this.sectionDepartment,
    this.managerId,
    this.manager,
    this.periortyLevelId,
    this.archivedBy,
    this.dateArchiving,
    this.periortyLevel,
    this.riskLevelId,
    this.riskLevel,
    this.outputCount,
    this.teamUsers,
    this.initiativeProjects,
    this.kpiProjects,
    this.projectComments,
    this.savedDocuments,
    this.projectProcessTimeLines,
    this.projectStageTimeLines,
    this.projectOutPuts,
    this.sliceDatas,
    this.stepStatuses,
    this.mainActivities,
    this.projectLogs,
    this.projectDocuments,
    this.projectStepComments,
    this.risks,
    this.challenges,
    this.riskLogs,
    this.value,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  Project.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    lifeCycleId = json['lifeCycleId'];
    projectLifeCycle = json['projectLifeCycle'];
    projectCategoryId = json['projectCategoryId'];
    projectCategory = json['projectCategory'];
    budget = json['budget'];
    implementorDepartmentId = json['implementorDepartmentId'];
    implementorDepartment = json['implementorDepartment'];
    implementorDepartmentName = json['implementorDepartmentName'];
    sectionDepartmentId = json['sectionDepartmentId'];
    sectionDepartment = json['sectionDepartment'];
    managerId = json['managerId'];
    manager = json['manager'];
    periortyLevelId = json['periortyLevelId'];
    archivedBy = json['archivedBy'];
    dateArchiving = json['dateArchiving'];
    periortyLevel = json['periortyLevel'];
    riskLevelId = json['riskLevelId'];
    riskLevel = json['riskLevel'];
    outputCount = json['outputCount'];
    teamUsers = json['teamUsers'];
    initiativeProjects = json['initiativeProjects'];
    kpiProjects = json['kpiProjects'];
    projectComments = json['projectComments'];
    savedDocuments = json['savedDocuments'];
    projectProcessTimeLines = json['projectProcessTimeLines'];
    projectStageTimeLines = json['projectStageTimeLines'];
    projectOutPuts = json['projectOutPuts'];
    sliceDatas = json['sliceDatas'];
    stepStatuses = json['stepStatuses'];
    mainActivities = json['mainActivities'];
    projectLogs = json['projectLogs'];
    projectDocuments = json['projectDocuments'];
    projectStepComments = json['projectStepComments'];
    risks = json['risks'];
    challenges = json['challenges'];
    riskLogs = json['riskLogs'];
    value = json['value'];
    id = json['id'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['lifeCycleId'] = lifeCycleId;
    data['projectLifeCycle'] = projectLifeCycle;
    data['projectCategoryId'] = projectCategoryId;
    data['projectCategory'] = projectCategory;
    data['budget'] = budget;
    data['implementorDepartmentId'] = implementorDepartmentId;
    data['implementorDepartment'] = implementorDepartment;
    data['implementorDepartmentName'] = implementorDepartmentName;
    data['sectionDepartmentId'] = sectionDepartmentId;
    data['sectionDepartment'] = sectionDepartment;
    data['managerId'] = managerId;
    data['manager'] = manager;
    data['periortyLevelId'] = periortyLevelId;
    data['archivedBy'] = archivedBy;
    data['dateArchiving'] = dateArchiving;
    data['periortyLevel'] = periortyLevel;
    data['riskLevelId'] = riskLevelId;
    data['riskLevel'] = riskLevel;
    data['outputCount'] = outputCount;
    data['teamUsers'] = teamUsers;
    data['initiativeProjects'] = initiativeProjects;
    data['kpiProjects'] = kpiProjects;
    data['projectComments'] = projectComments;
    data['savedDocuments'] = savedDocuments;
    data['projectProcessTimeLines'] = projectProcessTimeLines;
    data['projectStageTimeLines'] = projectStageTimeLines;
    data['projectOutPuts'] = projectOutPuts;
    data['sliceDatas'] = sliceDatas;
    data['stepStatuses'] = stepStatuses;
    data['mainActivities'] = mainActivities;
    data['projectLogs'] = projectLogs;
    data['projectDocuments'] = projectDocuments;
    data['projectStepComments'] = projectStepComments;
    data['risks'] = risks;
    data['challenges'] = challenges;
    data['riskLogs'] = riskLogs;
    data['value'] = value;
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class ProcessStatus {
  int? processId;
  int? projectId;
  Project? project;
  bool? isRuningWorkflow;
  bool? isCompletedWorkflow;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  ProcessStatus({
    this.processId,
    this.projectId,
    this.project,
    this.isRuningWorkflow,
    this.isCompletedWorkflow,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  ProcessStatus.fromJson(Map<String, dynamic> json) {
    processId = json['processId'];
    projectId = json['projectId'];
    project = json['project'] != null
        ? Project.fromJson(json['project'])
        : null;
    isRuningWorkflow = json['isRuningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    id = json['id'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['processId'] = processId;
    data['projectId'] = projectId;
    if (project != null) {
      data['project'] = project!.toJson();
    }
    data['isRuningWorkflow'] = isRuningWorkflow;
    data['isCompletedWorkflow'] = isCompletedWorkflow;
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
