import '../../../network/mapper.dart';

class GoalProgressModel extends SingleMapper {
  int? id;
  int? image;
  String? title;
  DateTime? startDate;
  int? trainee;

  GoalProgressModel({
    this.id,
    this.title,
    this.image,
    this.startDate,
    this.trainee,
  });

  GoalProgressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    trainee = json['trainee'] ?? 0;
    startDate =
        json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['trainee'] = trainee;
    data['start_date'] = startDate;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return GoalProgressModel.fromJson(json);
  }
}
