import 'package:core_package/core/utility/export.dart';

class ObjectiveKPIModel extends SingleMapper {
  String? kpiTitle;
  double? value;
  String? color;

  ObjectiveKPIModel({this.kpiTitle, this.value , this.color});

  ObjectiveKPIModel.fromJson(Map<String, dynamic> json) {
    kpiTitle = json['indicatorTitle'];
    value = json['kpiValue'];
    color = json['color'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['indicatorTitle'] = kpiTitle;
    data['kpiValue'] = value;
    data['color'] = color;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveKPIModel.fromJson(json);
  }
}
