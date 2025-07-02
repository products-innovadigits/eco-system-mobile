import '../utility/export.dart';

class DefaultRequestModel extends SingleMapper {
  int? status;
  String? message;

  DefaultRequestModel({this.status, this.message});

  @override
  DefaultRequestModel fromJson(Map<String, dynamic> json) {
    return DefaultRequestModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
