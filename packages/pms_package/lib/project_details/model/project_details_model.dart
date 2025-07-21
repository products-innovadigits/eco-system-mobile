import 'package:core_package/core/utility/export.dart';

class ProjectDetailsModel extends SingleMapper {
  int? id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? lifeCycleId;
  ProjectLifeCycleModel? projectLifeCycle;
  int? projectCategoryId;
  int? budget;
  double? weight;
  num? progressRatio;
  List<String>? teamIds;
  SectionDepartmentModel? sectionDepartment;
  int? implementorDepartmentId;
  String? implementorDepartmentName;
  String? managerId;
  String? status;
  String? managerName;
  int? priorityLevelId;
  int? riskLevelId;
  List<dynamic>? initiativeIds;
  List<dynamic>? kpiIds;
  int? outputCount;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  ProjectDetailsModel(
      {this.id,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.weight,
      this.lifeCycleId,
      this.projectLifeCycle,
      this.projectCategoryId,
      this.budget,
      this.teamIds,
      this.sectionDepartment,
      this.implementorDepartmentId,
      this.implementorDepartmentName,
      this.managerId,
      this.status,
      this.progressRatio,
      this.managerName,
      this.priorityLevelId,
      this.riskLevelId,
      this.initiativeIds,
      this.kpiIds,
      this.outputCount,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    startDate =
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    lifeCycleId = json['lifeCycleId'];
    projectLifeCycle = json['projectLifeCycle'] != null
        ? new ProjectLifeCycleModel.fromJson(json['projectLifeCycle'])
        : null;
    projectCategoryId = json['projectCategoryId'];
    weight = json['weight'];
    budget = json['budget'];
    progressRatio = json['progressRation'];
    teamIds = json['teamIds'] != null ? json['teamIds'].cast<String>() : null;
    sectionDepartment = json['sectionDepartment'] != null
        ? SectionDepartmentModel.fromJson(json['sectionDepartment'])
        : null;
    implementorDepartmentId = json['implementorDepartmentId'];

    implementorDepartmentName = json['implementorDepartmentName'];
    managerId = json['managerId'];
    status = json['status'];
    managerName = json['managerName'];
    priorityLevelId = json['periortyLevelId'];
    riskLevelId = json['riskLevelId'];
    outputCount = json['outputCount'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['lifeCycleId'] = lifeCycleId;
    if (projectLifeCycle != null) {
      data['projectLifeCycle'] = projectLifeCycle!.toJson();
    }
    data['projectCategoryId'] = projectCategoryId;
    data['weight'] = weight;
    data['budget'] = budget;
    data['teamIds'] = teamIds;
    data['sectionDepartment'] = sectionDepartment?.toJson();
    data['implementorDepartmentId'] = implementorDepartmentId;
    data['implementorDepartmentName'] = implementorDepartmentName;
    data['managerId'] = managerId;
    data['status'] = status;
    data['progressRation'] = progressRatio;
    data['managerName'] = managerName;
    data['periortyLevelId'] = priorityLevelId;
    data['riskLevelId'] = riskLevelId;
    data['outputCount'] = outputCount;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectDetailsModel.fromJson(json);
  }
}

class ProjectLifeCycleModel {
  int? id;
  String? title;
  String? description;
  List<ProjectStagesModel>? projectStages;

  ProjectLifeCycleModel(
      {this.id, this.title, this.description, this.projectStages});

  ProjectLifeCycleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    if (json['projectStages'] != null) {
      projectStages = <ProjectStagesModel>[];
      json['projectStages'].forEach((v) {
        projectStages!.add(new ProjectStagesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    if (projectStages != null) {
      data['projectStages'] =
          projectStages!.map((v) => v.toJson()).toList();
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

  ProjectStagesModel(
      {this.id,
      this.title,
      this.description,
      this.lifeCycleId,
      this.progress,
      this.projectProcesses});

  ProjectStagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    lifeCycleId = json['lifeCycleId'];
    progress = double.tryParse(json['progress']?.toString() ?? "0");
    if (json['projectProcesses'] != null) {
      projectProcesses = <ProjectProcessModel>[];
      json['projectProcesses'].forEach((v) {
        projectProcesses!.add(new ProjectProcessModel.fromJson(v));
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
      data['projectProcesses'] =
          projectProcesses!.map((v) => v.toJson()).toList();
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

  ProjectProcessModel(
      {this.id,
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
      this.completedWorkflowTime});

  ProjectProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    description = json['description'];
    stageId = json['stageId'];
    departmentId = json['departmentId'];
    workflowId = json['workflowId'];
    workflow = json['workflow'];
    viewOrder = json['viewOrder'];
    progress = double.tryParse(json['progress']?.toString() ?? "0");
    isRunningWorkflow = json['isRunningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    runningWorkflowTime = json['runningWorkflowTime'];
    completedWorkflowTime = json['completedWorkflowTime'];
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
    return data;
  }
}

class SectionDepartmentModel {
  int? id;
  String? name;
  String? description;
  String? manager;
  int? projectCount;

  SectionDepartmentModel(
      {this.id, this.name, this.description, this.manager, this.projectCount});

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
