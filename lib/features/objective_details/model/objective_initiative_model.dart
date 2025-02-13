import '../../../network/mapper.dart';

class ObjectiveInitiativeModel extends SingleMapper {
  String? initiativeTitle;
  double? value;

  ObjectiveInitiativeModel({this.initiativeTitle, this.value});

  ObjectiveInitiativeModel.fromJson(Map<String, dynamic> json) {
    initiativeTitle = json['initiativeTitle'];
    value = json['initiativeUpdateLogs'] != null &&
            json["initiativeUpdateLogs"]["newValue"] != null
        ? json["initiativeUpdateLogs"]["newValue"]
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['initiativeTitle'] = this.initiativeTitle;
    data['value'] = this.value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveInitiativeModel.fromJson(json);
  }
}
