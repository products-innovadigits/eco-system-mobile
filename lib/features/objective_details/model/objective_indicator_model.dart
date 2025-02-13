import '../../../network/mapper.dart';

class ObjectiveKPIModel extends SingleMapper {
  String? kpiTitle;
  double? value;

  ObjectiveKPIModel({this.kpiTitle, this.value});

  ObjectiveKPIModel.fromJson(Map<String, dynamic> json) {
    kpiTitle = json['indicatorTitle'];
    value = json['kpiValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['indicatorTitle'] = this.kpiTitle;
    data['kpiValue'] = this.value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveKPIModel.fromJson(json);
  }
}
