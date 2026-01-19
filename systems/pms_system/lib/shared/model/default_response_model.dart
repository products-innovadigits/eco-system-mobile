import 'package:core_system/core/network/mapper.dart';

class DefaultResponseModel extends SingleMapper {
  final bool? succeeded;
  final DefaultResponseData? data;
  final List<dynamic>? warningErrors;
  final List<dynamic>? validationErrors;

  DefaultResponseModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return DefaultResponseModel(
      succeeded: json['succeeded'] as bool?,
      data: json['data'] != null
          ? DefaultResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      warningErrors: json['warningErrors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'succeeded': succeeded,
      'data': data != null
          ? {'message': data!.message, 'messageEn': data!.messageEn}
          : null,
      'warningErrors': warningErrors,
      'validationErrors': validationErrors,
    };
  }
}

class DefaultResponseData {
  final String? message;
  final String? messageEn;

  DefaultResponseData({this.message, this.messageEn});

  factory DefaultResponseData.fromJson(Map<String, dynamic> json) {
    return DefaultResponseData(
      message: json['message'] as String?,
      messageEn: json['messageEn'] as String?,
    );
  }
}
