import '../../../network/mapper.dart';

class JobsModel extends SingleMapper {
  String? categoryName;
  double? value;

  JobsModel({this.categoryName, this.value});

  JobsModel.fromJson(Map<String, dynamic> json) {
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
    return JobsModel.fromJson(json);
  }
}
