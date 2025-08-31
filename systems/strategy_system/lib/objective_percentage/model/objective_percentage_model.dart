

import '../../shared/strategy_exports.dart';

class ObjectivePercentageModel extends SingleMapper {
  String? categoryName;
  double? value;
  num? count;

  ObjectivePercentageModel({this.categoryName, this.value , this.count});

  ObjectivePercentageModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    value = json['value'];
    count = json['count'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['value'] = value;
    data['count'] = count;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectivePercentageModel.fromJson(json);
  }
}
