import 'package:eco_system/network/mapper.dart';

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
    title = json['title']??json['name'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.title;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['lifeCycleId'] = this.lifeCycleId;
    if (this.projectLifeCycle != null) {
      data['projectLifeCycle'] = this.projectLifeCycle!.toJson();
    }
    data['projectCategoryId'] = this.projectCategoryId;
    data['weight'] = this.weight;
    data['budget'] = this.budget;
    data['teamIds'] = this.teamIds;
    data['sectionDepartment'] = this.sectionDepartment?.toJson();
    data['implementorDepartmentId'] = this.implementorDepartmentId;
    data['implementorDepartmentName'] = this.implementorDepartmentName;
    data['managerId'] = this.managerId;
    data['status'] = this.status;
    data['managerName'] = this.managerName;
    data['periortyLevelId'] = this.priorityLevelId;
    data['riskLevelId'] = this.riskLevelId;
    data['outputCount'] = this.outputCount;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedBy'] = this.updatedBy;
    data['updatedAt'] = this.updatedAt;
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
    title = json['title']??json['name'];
    description = json['description'];
    if (json['projectStages'] != null) {
      projectStages = <ProjectStagesModel>[];
      json['projectStages'].forEach((v) {
        projectStages!.add(new ProjectStagesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.projectStages != null) {
      data['projectStages'] =
          this.projectStages!.map((v) => v.toJson()).toList();
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
    title = json['title']??json['name'];
    description = json['description'];
    lifeCycleId = json['lifeCycleId'];
    progress = double.tryParse(json['progress']?.toString()??"0");
    if (json['projectProcesses'] != null) {
      projectProcesses = <ProjectProcessModel>[];
      json['projectProcesses'].forEach((v) {
        projectProcesses!.add(new ProjectProcessModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['lifeCycleId'] = this.lifeCycleId;
    data['progress'] = this.progress;
    if (this.projectProcesses != null) {
      data['projectProcesses'] =
          this.projectProcesses!.map((v) => v.toJson()).toList();
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
  Null? workflow;
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
    title = json['title']??json['name'];
    description = json['description'];
    stageId = json['stageId'];
    departmentId = json['departmentId'];
    workflowId = json['workflowId'];
    workflow = json['workflow'];
    viewOrder = json['viewOrder'];
    progress = double.tryParse(json['progress']?.toString()??"0");
    isRunningWorkflow = json['isRunningWorkflow'];
    isCompletedWorkflow = json['isCompletedWorkflow'];
    runningWorkflowTime = json['runningWorkflowTime'];
    completedWorkflowTime = json['completedWorkflowTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['stageId'] = this.stageId;
    data['departmentId'] = this.departmentId;
    data['workflowId'] = this.workflowId;
    data['workflow'] = this.workflow;
    data['viewOrder'] = this.viewOrder;
    data['progress'] = this.progress;
    data['isRunningWorkflow'] = this.isRunningWorkflow;
    data['isCompletedWorkflow'] = this.isCompletedWorkflow;
    data['runningWorkflowTime'] = this.runningWorkflowTime;
    data['completedWorkflowTime'] = this.completedWorkflowTime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['manager'] = this.manager;
    data['projectCount'] = this.projectCount;
    return data;
  }
}
