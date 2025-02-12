import '../../../network/mapper.dart';

class ObjectiveIndicatorModel extends SingleMapper {
  String? categoryName;
  double? value;

  ObjectiveIndicatorModel({this.categoryName, this.value});

  ObjectiveIndicatorModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['value'] = this.value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveIndicatorModel.fromJson(json);
  }
}
