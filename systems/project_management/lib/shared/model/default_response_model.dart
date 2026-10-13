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
      data: DefaultResponseData.parse(json['data']),
      warningErrors: json['warningErrors'] is List
          ? json['warningErrors'] as List<dynamic>
          : null,
      validationErrors: json['validationErrors'] is List
          ? json['validationErrors'] as List<dynamic>
          : null,
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
      message: json['message']?.toString(),
      messageEn: json['messageEn']?.toString(),
    );
  }

  /// Endpoints send `data` either as `{message, messageEn}` or as the message
  /// itself (`"data": "تمت العملية بنجاح"`); anything else carries no message.
  static DefaultResponseData? parse(dynamic data) => switch (data) {
    Map() => DefaultResponseData.fromJson(data.cast<String, dynamic>()),
    String() => DefaultResponseData(message: data),
    _ => null,
  };
}
