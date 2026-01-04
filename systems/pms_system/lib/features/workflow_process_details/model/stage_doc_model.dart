import 'package:core_system/core/utility/export.dart';

class StageDocResponseModel extends SingleMapper {
  bool? succeeded;
  StageDocData? data;

  StageDocResponseModel({this.succeeded, this.data});

  StageDocResponseModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? StageDocData.fromJson((json['data'] as Map).cast<String, dynamic>())
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      StageDocResponseModel.fromJson(json);
}

class StageDocData {
  WorkflowStep? currentStep;
  List<WorkflowStep>? nextStep;
  String? workFlowStatus;
  String? pdfFilePath;
  num? stepDocumentId;

  StageDocData({
    this.currentStep,
    this.nextStep,
    this.workFlowStatus,
    this.pdfFilePath,
  });

  StageDocData.fromJson(Map<String, dynamic> json) {
    currentStep = json['currentStep'] != null
        ? WorkflowStep.fromJson(
            (json['currentStep'] as Map).cast<String, dynamic>(),
          )
        : null;
    if (json['nextStep'] != null && json['nextStep'] is List) {
      nextStep = <WorkflowStep>[];
      for (var v in (json['nextStep'] as List)) {
        if (v != null) {
          nextStep!.add(
            WorkflowStep.fromJson((v as Map).cast<String, dynamic>()),
          );
        }
      }
    }
    workFlowStatus = json['workFlowStatus']?.toString();
    pdfFilePath = json['pdfFilePath']?.toString();
    stepDocumentId = json['stepDocumentId'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (currentStep != null) map['currentStep'] = currentStep!.toJson();
    if (nextStep != null) {
      map['nextStep'] = nextStep!.map((e) => e.toJson()).toList();
    }
    map['workFlowStatus'] = workFlowStatus;
    map['pdfFilePath'] = pdfFilePath;
    map['stepDocumentId'] = stepDocumentId;
    return map;
  }
}

class WorkflowStep extends SingleMapper {
  int? id;
  String? text;
  int? deadLineDays;
  int? toTopLevelDays;
  int? roleId;
  String? responsibleUserId;
  dynamic responsibleUser;
  int? workFlowId;
  int? stepGroupId;
  dynamic slicesCount;
  dynamic stepGroup;
  bool? isEmailActive;
  String? deadLineDate;
  String? toTopLevel;
  List<int>? stepDocumentIds;
  List<StageDocument?>? stepDocuments;
  List<dynamic>? complaintFollowerIds;
  List<dynamic>? complaintTopLevelIds;
  bool? isActive;
  String? category;
  String? loc;
  int? key;
  int? status;
  bool? isActiveStep;
  bool? isStartStep;
  bool? isLastStep;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  WorkflowStep({
    this.id,
    this.text,
    this.deadLineDays,
    this.toTopLevelDays,
    this.roleId,
    this.responsibleUserId,
    this.responsibleUser,
    this.workFlowId,
    this.stepGroupId,
    this.slicesCount,
    this.stepGroup,
    this.isEmailActive,
    this.deadLineDate,
    this.toTopLevel,
    this.stepDocumentIds,
    this.stepDocuments,
    this.complaintFollowerIds,
    this.complaintTopLevelIds,
    this.isActive,
    this.category,
    this.loc,
    this.key,
    this.status,
    this.isActiveStep,
    this.isStartStep,
    this.isLastStep,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  WorkflowStep.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    text = json['text']?.toString();
    deadLineDays = (json['deadLineDays'] as num?)?.toInt();
    toTopLevelDays = (json['toTopLevelDays'] as num?)?.toInt();
    roleId = (json['roleId'] as num?)?.toInt();
    responsibleUserId = json['responsibleUserId']?.toString();
    responsibleUser = json['responsibleUser'];
    workFlowId = (json['workFlowId'] as num?)?.toInt();
    stepGroupId = (json['stepGroupId'] as num?)?.toInt();
    slicesCount = json['slicesCount'];
    stepGroup = json['stepGroup'];
    isEmailActive = json['isEmailActive'] as bool?;
    deadLineDate = json['deadLineDate']?.toString();
    toTopLevel = json['toTopLevel']?.toString();

    if (json['stepDocumentIds'] != null && json['stepDocumentIds'] is List) {
      stepDocumentIds = <int>[];
      for (var v in (json['stepDocumentIds'] as List)) {
        if (v is num) {
          stepDocumentIds!.add(v.toInt());
        }
      }
    }

    if (json['stepDocuments'] != null && json['stepDocuments'] is List) {
      stepDocuments = <StageDocument?>[];
      for (var v in (json['stepDocuments'] as List)) {
        if (v != null && v is Map) {
          stepDocuments!.add(StageDocument.fromJson(v.cast<String, dynamic>()));
        } else {
          stepDocuments!.add(null);
        }
      }
    }

    if (json['complaintFollowerIds'] != null &&
        json['complaintFollowerIds'] is List) {
      complaintFollowerIds = json['complaintFollowerIds'] as List<dynamic>;
    }

    if (json['complaintTopLevelIds'] != null &&
        json['complaintTopLevelIds'] is List) {
      complaintTopLevelIds = json['complaintTopLevelIds'] as List<dynamic>;
    }

    isActive = json['isActive'] as bool?;
    category = json['category']?.toString();
    loc = json['loc']?.toString();
    key = (json['key'] as num?)?.toInt();
    status = (json['status'] as num?)?.toInt();
    isActiveStep = json['isActiveStep'] as bool?;
    isStartStep = json['isStartStep'] as bool?;
    isLastStep = json['isLastStep'] as bool?;
    createdBy = json['createdBy']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedBy = json['updatedBy']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    map['deadLineDays'] = deadLineDays;
    map['toTopLevelDays'] = toTopLevelDays;
    map['roleId'] = roleId;
    map['responsibleUserId'] = responsibleUserId;
    map['responsibleUser'] = responsibleUser;
    map['workFlowId'] = workFlowId;
    map['stepGroupId'] = stepGroupId;
    map['slicesCount'] = slicesCount;
    map['stepGroup'] = stepGroup;
    map['isEmailActive'] = isEmailActive;
    map['deadLineDate'] = deadLineDate;
    map['toTopLevel'] = toTopLevel;
    if (stepDocumentIds != null) map['stepDocumentIds'] = stepDocumentIds;
    if (stepDocuments != null) {
      map['stepDocuments'] = stepDocuments!.map((e) => e?.toJson()).toList();
    }
    if (complaintFollowerIds != null) {
      map['complaintFollowerIds'] = complaintFollowerIds;
    }
    if (complaintTopLevelIds != null) {
      map['complaintTopLevelIds'] = complaintTopLevelIds;
    }
    map['isActive'] = isActive;
    map['category'] = category;
    map['loc'] = loc;
    map['key'] = key;
    map['status'] = status;
    map['isActiveStep'] = isActiveStep;
    map['isStartStep'] = isStartStep;
    map['isLastStep'] = isLastStep;
    map['createdBy'] = createdBy;
    map['createdAt'] = createdAt;
    map['updatedBy'] = updatedBy;
    map['updatedAt'] = updatedAt;
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => WorkflowStep.fromJson(json);
}

class StageDocument {
  int? id;
  String? documentTitle;
  bool? isActive;
  String? symbol;
  StageDocPayload? data;
  String? updatedBy;
  String? updatedAt;

  StageDocument({
    this.id,
    this.documentTitle,
    this.isActive,
    this.symbol,
    this.data,
    this.updatedBy,
    this.updatedAt,
  });

  StageDocument.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    documentTitle = json['documentTitle']?.toString();
    isActive = json['isActive'] as bool?;
    symbol = json['symbol']?.toString();
    if (json['data'] is Map) {
      data = StageDocPayload.fromJson(
        (json['data'] as Map).cast<String, dynamic>(),
      );
    }
    updatedBy = json['updatedBy']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['documentTitle'] = documentTitle;
    map['isActive'] = isActive;
    map['symbol'] = symbol;
    if (data != null) map['data'] = data!.toJson();
    map['updatedBy'] = updatedBy;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class StageDocPayload {
  String? content; // HTML
  Map<String, dynamic>? fields; // dynamic keyed object of field definitions

  StageDocPayload({this.content, this.fields});

  StageDocPayload.fromJson(Map<String, dynamic> json) {
    content = json['content']?.toString();
    if (json['fields'] is Map) {
      fields = (json['fields'] as Map).cast<String, dynamic>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['content'] = content;
    if (fields != null) map['fields'] = fields;
    return map;
  }
}
