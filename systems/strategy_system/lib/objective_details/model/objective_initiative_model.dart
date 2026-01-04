import 'package:core_system/core/utility/export.dart';

class ObjectiveInitiativeModel extends SingleMapper {
  String? initiativeTitle;
  double? value;

  ObjectiveInitiativeModel({this.initiativeTitle, this.value});

  ObjectiveInitiativeModel.fromJson(Map<String, dynamic> json) {
    initiativeTitle = json['initiativeTitle'];
    value =
        json['initiativeUpdateLogs'] != null &&
            json["initiativeUpdateLogs"]["newValue"] != null
        ? json["initiativeUpdateLogs"]["newValue"]
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['initiativeTitle'] = initiativeTitle;
    data['value'] = value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveInitiativeModel.fromJson(json);
  }
}
