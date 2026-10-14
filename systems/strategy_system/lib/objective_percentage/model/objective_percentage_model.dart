

import '../../shared/strategy_exports.dart';

class ObjectivePercentageModel extends SingleMapper {
  String? categoryName;
  double? value;
  num? count;

  ObjectivePercentageModel({this.categoryName, this.value , this.count});

  ObjectivePercentageModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    // `value` arrives as int when it is a whole number (0, 100); a direct
    // assignment to double? throws and the whole card falls into Error.
    value = (json['value'] as num?)?.toDouble();
    // TODO(backend): `count` is not returned by ObjectActive/Categorized yet,
    // so the legend shows "(0)" for every category.
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
