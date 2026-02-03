import 'package:project_management/core/utility/pms_exports.dart';

class CurrentStepDocumentModel extends SingleMapper {
  bool? succeeded;
  CurrentStepDocumentData? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  CurrentStepDocumentModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  CurrentStepDocumentModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? CurrentStepDocumentData.fromJson(
            (json['data'] as Map).cast<String, dynamic>(),
          )
        : null;
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
      data['data'] = this.data!.toJson();
    }
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      data['validationErrors'] = validationErrors!.map((v) => v).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CurrentStepDocumentModel.fromJson(json);
  }
}

class CurrentStepDocumentData extends SingleMapper {
  int? totalCount;
  List<CurrentStepDocumentItem>? items;

  CurrentStepDocumentData({this.totalCount, this.items});

  CurrentStepDocumentData.fromJson(Map<String, dynamic> json) {
    totalCount = (json['totalCount'] as num?)?.toInt();
    if (json['items'] != null && json['items'] is List) {
      items = <CurrentStepDocumentItem>[];
      for (var v in (json['items'] as List)) {
        items!.add(
          CurrentStepDocumentItem.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCount'] = totalCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CurrentStepDocumentData.fromJson(json);
  }
}

class CurrentStepDocumentItem extends SingleMapper {
  int? id;
  int? projectId;
  int? processId;
  int? stepDocumentId;
  StepDocument? document;

  CurrentStepDocumentItem({
    this.id,
    this.projectId,
    this.processId,
    this.stepDocumentId,
    this.document,
  });

  CurrentStepDocumentItem.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    projectId = (json['projectId'] as num?)?.toInt();
    processId = (json['processId'] as num?)?.toInt();
    stepDocumentId = (json['stepDocumentId'] as num?)?.toInt();
    document = json['document'] != null
        ? StepDocument.fromJson(
            (json['document'] as Map).cast<String, dynamic>(),
          )
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['projectId'] = projectId;
    data['processId'] = processId;
    data['stepDocumentId'] = stepDocumentId;
    if (document != null) {
      data['document'] = document!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CurrentStepDocumentItem.fromJson(json);
  }
}

class StepDocumentItem extends SingleMapper {
  int? documentId;
  StepDocument? document;

  StepDocumentItem({this.documentId, this.document});

  StepDocumentItem.fromJson(Map<String, dynamic> json) {
    documentId = (json['documentId'] as num?)?.toInt();
    document = json['document'] != null
        ? StepDocument.fromJson(json['document'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    if (document != null) {
      data['document'] = document!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return StepDocumentItem.fromJson(json);
  }
}

class StepDocument extends SingleMapper {
  int? id;
  int? stepDocumentId;
  String? documentTitle;
  bool? isActive;
  String? symbol;
  StepDocumentDataPayload? data;

  StepDocument({
    this.id,
    this.stepDocumentId,
    this.documentTitle,
    this.isActive,
    this.symbol,
    this.data,
  });

  StepDocument.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    stepDocumentId = (json['stepDocumentId'] as num?)?.toInt();
    documentTitle = json['documentTitle']?.toString();
    isActive = json['isActive'] as bool?;
    symbol = json['symbol']?.toString();
    data = json['data'] != null
        ? StepDocumentDataPayload.fromJson(json['data'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stepDocumentId'] = stepDocumentId;
    data['documentTitle'] = documentTitle;
    data['isActive'] = isActive;
    data['symbol'] = symbol;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return StepDocument.fromJson(json);
  }
}

class StepDocumentDataPayload {
  String? content;
  Map<String, FieldDefinition>? fields;

  StepDocumentDataPayload({this.content, this.fields});

  StepDocumentDataPayload.fromJson(Map<String, dynamic> json) {
    content = json['content']?.toString();
    if (json['fields'] != null && json['fields'] is Map) {
      fields = <String, FieldDefinition>{};
      (json['fields'] as Map<String, dynamic>).forEach((key, value) {
        if (value is Map) {
          fields![key] = FieldDefinition.fromJson(
            value.cast<String, dynamic>(),
          );
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    if (fields != null) {
      data['fields'] = fields!.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
    }
    return data;
  }
}

class FieldDefinition {
  String? type;
  String? label;
  dynamic icon;
  dynamic configUI;
  FieldMeta? meta;

  FieldDefinition({this.type, this.label, this.icon, this.configUI, this.meta});

  FieldDefinition.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    label = json['label']?.toString();
    icon = json['icon'];
    configUI = json['configUI'];
    meta = json['meta'] != null ? FieldMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['label'] = label;
    data['icon'] = icon;
    data['configUI'] = configUI;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class FieldMeta {
  String? placeholder;
  String? value;
  Map<String, dynamic>? rules;
  String? name;

  FieldMeta({this.placeholder, this.value, this.rules, this.name});

  FieldMeta.fromJson(Map<String, dynamic> json) {
    placeholder = json['placeholder']?.toString();
    value = json['value']?.toString();
    if (json['rules'] != null && json['rules'] is Map) {
      rules = (json['rules'] as Map).cast<String, dynamic>();
    }
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeholder'] = placeholder;
    data['value'] = value;
    if (rules != null) {
      data['rules'] = rules;
    }
    data['name'] = name;
    return data;
  }
}
