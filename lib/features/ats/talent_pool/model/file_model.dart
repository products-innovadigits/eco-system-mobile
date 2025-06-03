import 'package:eco_system/network/mapper.dart';

class FileModel extends SingleMapper {
  final String? id;
  final String? name;
  final String? message;
  final String? url;
  final DateTime? createdAt;
  final String? fileType;
  final int? fileSize;

  FileModel({
    this.id,
    this.name,
    this.message,
    this.url,
    this.createdAt,
    this.fileType,
    this.fileSize,
  });

  @override
  FileModel fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      message: json['message'] as String?,
      url: json['url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      fileType: json['file_type'] as String?,
      fileSize: json['file_size'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'url': url,
      'created_at': createdAt?.toIso8601String(),
      'file_type': fileType,
      'file_size': fileSize,
    };
  }
}
