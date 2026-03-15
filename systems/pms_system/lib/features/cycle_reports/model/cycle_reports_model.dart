/// Model for a single cycle report item (reviewee with view/download actions).
/// Replace with API response model when endpoint is available.
class CycleReportItemModel {
  final int id;
  final String name;
  final String jobTitle;
  final String? imageUrl;

  CycleReportItemModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    this.imageUrl,
  });

  factory CycleReportItemModel.fromJson(Map<String, dynamic> json) {
    return CycleReportItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'jobTitle': jobTitle,
      'imageUrl': imageUrl,
    };
  }
}
