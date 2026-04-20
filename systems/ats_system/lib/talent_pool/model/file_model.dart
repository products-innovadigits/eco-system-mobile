import 'package:core_system/core/utility/export.dart';

class FileModel extends SingleMapper {
  final String? id;
  final String? name;
  final String? message;
  final String? url;
  final String? downloadUrl;
  final String? fileName;
  final DateTime? createdAt;
  final String? fileType;
  final int? fileSize;

  FileModel({
    this.id,
    this.name,
    this.message,
    this.url,
    this.downloadUrl,
    this.fileName,
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
      downloadUrl: json['download_url'] as String?,
      fileName: json['file_name'] as String?,
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
      'download_url': downloadUrl,
      'file_name': fileName,
      'created_at': createdAt?.toIso8601String(),
      'file_type': fileType,
      'file_size': fileSize,
    };
  }
}
