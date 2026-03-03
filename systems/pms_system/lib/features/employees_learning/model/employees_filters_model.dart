import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeesFiltersModel extends SingleMapper {
  bool? succeeded;
  EmployeesFiltersData? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  EmployeesFiltersModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  EmployeesFiltersModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? EmployeesFiltersData.fromJson(json['data'])
        : null;
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) data['data'] = this.data!.toJson();
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) data['validationErrors'] = validationErrors;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return EmployeesFiltersModel.fromJson(json);
  }
}

class EmployeesFiltersData {
  List<FilterOptionItem>? teams;
  List<FilterOptionItem>? seniorityLevels;

  EmployeesFiltersData({this.teams, this.seniorityLevels});

  EmployeesFiltersData.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teams = <FilterOptionItem>[];
      json['teams'].forEach((v) {
        teams!.add(FilterOptionItem.fromJson(v));
      });
    }
    if (json['seniorityLevels'] != null) {
      seniorityLevels = <FilterOptionItem>[];
      json['seniorityLevels'].forEach((v) {
        seniorityLevels!.add(FilterOptionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teams != null) data['teams'] = teams!.map((v) => v.toJson()).toList();
    if (seniorityLevels != null) {
      data['seniorityLevels'] =
          seniorityLevels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterOptionItem {
  int? id;
  String? name;

  FilterOptionItem({this.id, this.name});

  FilterOptionItem.fromJson(Map<String, dynamic> json) {
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
