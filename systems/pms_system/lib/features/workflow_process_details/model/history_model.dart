import 'package:core_system/core/model/meta.dart';
import 'package:pms_system/core/utility/pms_exports.dart';

class HistoryResponseModel extends SingleMapper {
  List<HistoryItemModel>? data;
  bool? succeeded;
  String? message;
  Meta? meta;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  HistoryResponseModel({
    this.data,
    this.succeeded,
    this.meta,
    this.message,
    this.warningErrors,
    this.validationErrors,
  });

  HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    if (json['data'] != null && json['data'] is List) {
      data = <HistoryItemModel>[];
      (json['data'] as List).forEach((v) {
        data!.add(HistoryItemModel.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    message = json['message'];
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = <dynamic>[];
      (json['validationErrors'] as List).forEach((v) {
        validationErrors!.add(v);
      });
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
    return HistoryResponseModel.fromJson(json);
  }
}

class HistoryItemModel extends SingleMapper {
  int? id;
  String? name;
  ResponsaiblUserModel? responsibleUser;
  StepGroupModel? stepGroup;
  List<StepCommentModel>? stepComments;
  List<AttachmentModel>? slicesData;
  String? lastChangeTime;

  HistoryItemModel({
    this.id,
    this.name,
    this.responsibleUser,
    this.stepGroup,
    this.stepComments,
    this.slicesData,
    this.lastChangeTime,
  });

  HistoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    responsibleUser = json['responsaiblUser'] != null
        ? ResponsaiblUserModel.fromJson(json['responsaiblUser'])
        : null;
    stepGroup = json['stepGroup'] != null
        ? StepGroupModel.fromJson(json['stepGroup'])
        : null;

    if (json['stepComments'] != null) {
      stepComments = <StepCommentModel>[];
      (json['stepComments'] as List).forEach((v) {
        stepComments!.add(StepCommentModel.fromJson(v));
      });
    }

    if (json['slicesData'] != null) {
      slicesData = <AttachmentModel>[];
      (json['slicesData'] as List).forEach((v) {
        slicesData!.add(AttachmentModel.fromJson(v));
      });
    }

    lastChangeTime = json['lastChangeTime'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (responsibleUser != null) {
      data['responsaiblUser'] = responsibleUser!.toJson();
    }
    if (stepGroup != null) {
      data['stepGroup'] = stepGroup!.toJson();
    }
    if (stepComments != null) {
      data['stepComments'] = stepComments!.map((v) => v.toJson()).toList();
    }
    if (slicesData != null) {
      data['slicesData'] = slicesData!.map((v) => v.toJson()).toList();
    }
    data['lastChangeTime'] = lastChangeTime;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return HistoryItemModel.fromJson(json);
  }
}

class ResponsaiblUserModel extends SingleMapper {
  String? id;
  String? email;
  String? userName;
  String? name;
  String? fullName;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  dynamic roles;

  ResponsaiblUserModel({
    this.id,
    this.email,
    this.userName,
    this.name,
    this.fullName,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.roles,
  });

  ResponsaiblUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    userName = json['userName'];
    name = json['name'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    roles = json['roles'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['userName'] = userName;
    data['name'] = name;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['roles'] = roles;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ResponsaiblUserModel.fromJson(json);
  }
}

class StepGroupModel extends SingleMapper {
  int? id;
  String? groupName;
  bool? isActive;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  StepGroupModel({
    this.id,
    this.groupName,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  StepGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['groupName'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupName'] = groupName;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return StepGroupModel.fromJson(json);
  }
}

class StepCommentModel extends SingleMapper {
  int? id;
  String? text;
  String? filePath;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  // CommenterModel? commenter;

  StepCommentModel({
    this.id,
    this.text,
    this.filePath,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    // this.commenter,
  });

  StepCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    filePath = json['filePath'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    // commenter = json['commenter'] != null
    //     ? CommenterModel.fromJson(json['commenter'])
    //     : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['filePath'] = filePath;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    // if (commenter != null) {
    //   data['commenter'] = commenter!.toJson();
    // }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return StepCommentModel.fromJson(json);
  }
}

class CommenterModel extends SingleMapper {
  String? id;
  String? name;
  String? fullName;
  String? email;
  String? userName;

  CommenterModel({
    this.id,
    this.name,
    this.fullName,
    this.email,
    this.userName,
  });

  CommenterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fullName = json['fullName'];
    email = json['email'];
    userName = json['userName'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fullName'] = fullName;
    data['email'] = email;
    data['userName'] = userName;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CommenterModel.fromJson(json);
  }
}

class AttachmentModel extends SingleMapper {
  int? id;
  String? value;
  SliceModel? slice;
  int? sliceId;
  int? processId;
  int? projectId;
  int? projectStepId;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  AttachmentModel({
    this.id,
    this.value,
    this.slice,
    this.sliceId,
    this.processId,
    this.projectId,
    this.projectStepId,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value']?.toString();
    slice = json['slice'] != null ? SliceModel.fromJson(json['slice']) : null;
    sliceId = json['sliceId'];
    processId = json['processId'];
    projectId = json['projectId'];
    projectStepId = json['projectStepId'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    if (slice != null) {
      data['slice'] = slice!.toJson();
    }
    data['sliceId'] = sliceId;
    data['processId'] = processId;
    data['projectId'] = projectId;
    data['projectStepId'] = projectStepId;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return AttachmentModel.fromJson(json);
  }
}

class SliceModel extends SingleMapper {
  int? id;
  String? title;
  String? type;
  int? viewOrder;
  String? defaultValue;
  int? workFlowStepId;
  bool? isRequired;
  bool? isActive;
  List<dynamic>? sliceOptions;

  SliceModel({
    this.id,
    this.title,
    this.type,
    this.viewOrder,
    this.defaultValue,
    this.workFlowStepId,
    this.isRequired,
    this.isActive,
    this.sliceOptions,
  });

  SliceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    viewOrder = json['viewOrder'];
    defaultValue = json['defaultValue']?.toString();
    workFlowStepId = json['workFlowStepId'];
    isRequired = json['isRequired'];
    isActive = json['isActive'];
    if (json['sliceOptions'] != null) {
      sliceOptions = <dynamic>[];
      (json['sliceOptions'] as List).forEach((v) {
        sliceOptions!.add(v);
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['viewOrder'] = viewOrder;
    data['defaultValue'] = defaultValue;
    data['workFlowStepId'] = workFlowStepId;
    data['isRequired'] = isRequired;
    data['isActive'] = isActive;
    if (sliceOptions != null) {
      data['sliceOptions'] = sliceOptions!.map((v) => v).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return SliceModel.fromJson(json);
  }
}
