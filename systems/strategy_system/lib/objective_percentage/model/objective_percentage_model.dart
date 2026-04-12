

import '../../shared/strategy_exports.dart';

class ObjectivePercentageModel extends SingleMapper {
  String? categoryName;
  double? value;
  num? count;

  ObjectivePercentageModel({this.categoryName, this.value , this.count});

  ObjectivePercentageModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName']?.toString();
    final rawValue = json['value'];
    if (rawValue == null) {
      value = null;
    } else if (rawValue is num) {
      value = rawValue.toDouble();
    } else {
      value = double.tryParse(rawValue.toString());
    }
    final rawCount = json['count'];
    if (rawCount == null) {
      count = null;
    } else if (rawCount is num) {
      count = rawCount;
    } else {
      count = num.tryParse(rawCount.toString());
    }
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
