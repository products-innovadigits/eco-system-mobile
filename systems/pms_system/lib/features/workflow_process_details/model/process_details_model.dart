import 'package:core_system/core/model/meta.dart';
import 'package:pms_system/core/utility/pms_exports.dart';

class GroupStepsModel extends SingleMapper {
  List<GroupStepsData>? data;
  bool? succeeded;
  String? message;
  Meta? meta;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  GroupStepsModel({
    this.data,
    this.succeeded,
    this.meta,
    this.message,
    this.warningErrors,
    this.validationErrors,
  });

  GroupStepsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    // data is a direct List of groups
    if (json['data'] != null && json['data'] is List) {
      data = <GroupStepsData>[];
      for (var v in (json['data'] as List)) {
        data!.add(GroupStepsData.fromJson(v));
      }
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    message = json['message'];
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = <dynamic>[];
      for (var v in (json['validationErrors'] as List)) {
        validationErrors!.add(v);
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (message != null) {
      data['message'] = message;
    }
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      data['validationErrors'] = validationErrors!.map((v) => v).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return GroupStepsModel.fromJson(json);
  }
}

class GroupStepsData extends SingleMapper {
  int? groupId;
  String? groupName;
  double? progress;
  List<WorkflowProcessStepModel>? steps;

  GroupStepsData({this.groupId, this.groupName, this.progress, this.steps});

  GroupStepsData.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    progress = double.tryParse(json['progress']?.toString() ?? '0');
    if (json['steps'] != null) {
      steps = <WorkflowProcessStepModel>[];
      for (var v in (json['steps'] as List)) {
        steps!.add(WorkflowProcessStepModel.fromJson(v));
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['groupName'] = groupName;
    data['progress'] = progress;
    if (steps != null) {
      data['steps'] = steps!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return GroupStepsData.fromJson(json);
  }
}

class WorkflowProcessStepModel extends SingleMapper {
  int? id;
  String? stepName;
  int? status;

  WorkflowProcessStepModel({this.id, this.stepName, this.status});

  WorkflowProcessStepModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepName = json['stepName'];
    status = json['status'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepName'] = stepName;
    data['status'] = status;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return WorkflowProcessStepModel.fromJson(json);
  }
}
