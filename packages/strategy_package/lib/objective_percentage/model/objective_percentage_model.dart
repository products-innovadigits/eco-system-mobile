

import '../../shared/strategy_exports.dart';

class ObjectivePercentageModel extends SingleMapper {
  String? categoryName;
  double? value;

  ObjectivePercentageModel({this.categoryName, this.value});

  ObjectivePercentageModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    value = json['value'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['value'] = value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectivePercentageModel.fromJson(json);
  }
}
