import 'package:project_management/core/utility/pms_exports.dart';

class ProjectsFiltersModel extends SingleMapper {
  bool? succeeded;
  ProjectsFiltersData? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectsFiltersModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectsFiltersModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? ProjectsFiltersData.fromJson(json['data'])
        : null;
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = <dynamic>[];
      json['validationErrors'].forEach((v) {
        validationErrors!.add(v);
      });
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
    return ProjectsFiltersModel.fromJson(json);
  }
}

class ProjectsFiltersData {
  List<ProjectCategoryModel>? categories;
  List<ProjectPriorityModel>? priorities;
  List<ProjectRiskModel>? risks;
  List<ProjectStatusModel>? statuses;

  ProjectsFiltersData({
    this.categories,
    this.priorities,
    this.risks,
    this.statuses,
  });

  ProjectsFiltersData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <ProjectCategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(ProjectCategoryModel.fromJson(v));
      });
    }
    if (json['priorities'] != null) {
      priorities = <ProjectPriorityModel>[];
      json['priorities'].forEach((v) {
        priorities!.add(ProjectPriorityModel.fromJson(v));
      });
    }
    if (json['risks'] != null) {
      risks = <ProjectRiskModel>[];
      json['risks'].forEach((v) {
        risks!.add(ProjectRiskModel.fromJson(v));
      });
    }
    if (json['statuses'] != null) {
      statuses = <ProjectStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(ProjectStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (priorities != null) {
      data['priorities'] = priorities!.map((v) => v.toJson()).toList();
    }
    if (risks != null) {
      data['risks'] = risks!.map((v) => v.toJson()).toList();
    }
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectCategoryModel {
  String? name;
  String? description;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  ProjectCategoryModel({
    this.name,
    this.description,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  ProjectCategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
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
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class ProjectPriorityModel {
  String? name;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  ProjectPriorityModel({
    this.name,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  ProjectPriorityModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
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
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class ProjectRiskModel {
  String? name;
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  bool? isDeleted;

  ProjectRiskModel({
    this.name,
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  ProjectRiskModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
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
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class ProjectStatusModel {
  String? item1; // Arabic name
  String? item2; // English name
  int? item3; // Status ID

  ProjectStatusModel({this.item1, this.item2, this.item3});

  ProjectStatusModel.fromJson(Map<String, dynamic> json) {
    item1 = json['item1'];
    item2 = json['item2'];
    item3 = json['item3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item1'] = item1;
    data['item2'] = item2;
    data['item3'] = item3;
    return data;
  }
}
