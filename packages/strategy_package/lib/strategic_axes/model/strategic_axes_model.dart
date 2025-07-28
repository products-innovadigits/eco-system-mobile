import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
class StrategicAxesModel extends SingleMapper {
  bool? succeeded;
  VisionDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  StrategicAxesModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  StrategicAxesModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? VisionDataModel.fromJson(json['data'] as Map<String, dynamic>)
        : null;
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'] as List)
        : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => StrategicAxesModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    map['warningErrors'] = warningErrors;
    map['validationErrors'] = validationErrors;
    return map;
  }
}
