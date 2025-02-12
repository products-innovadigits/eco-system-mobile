import '../../../network/mapper.dart';

class ObjectivePercentageModel extends SingleMapper {
  String? categoryName;
  double? value;

  ObjectivePercentageModel({this.categoryName, this.value});

  ObjectivePercentageModel.fromJson(Map<String, dynamic> json) {
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
    return ObjectivePercentageModel.fromJson(json);
  }
}
