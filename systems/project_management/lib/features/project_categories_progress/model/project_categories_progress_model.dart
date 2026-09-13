import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectCategoriesProgressModel extends SingleMapper {
  int? id;
  String? name;
  double? progress;
  Color? color;

  ProjectCategoriesProgressModel({
    this.id,
    this.name,
    this.progress,
    this.color,
  });

  ProjectCategoriesProgressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // The API sends whole percentages as ints, which the old `is! double`
    // check turned into 0.0.
    progress = (json['progress'] as num?)?.toDouble() ?? 0.0;
    // The API sends the colour as a string ("#RRGGBB" or "0xAARRGGBB");
    // assigning it straight into a Color? field threw a TypeError.
    color = _parseColor(json['color']);
  }

  /// Reads the API's colour string. Returns null for anything unparseable, so
  /// a malformed colour never takes the whole response down with it.
  static Color? _parseColor(dynamic value) {
    if (value is Color) return value;
    if (value is int) return Color(value);
    if (value is! String || value.trim().isEmpty) return null;

    var raw = value.trim();
    if (raw.startsWith('#')) {
      raw = raw.substring(1);
      // #RRGGBB carries no alpha, so make it opaque.
      if (raw.length == 6) raw = 'ff$raw';
      return _fromRadix(raw, 16);
    }
    if (raw.startsWith('0x') || raw.startsWith('0X')) {
      return _fromRadix(raw.substring(2), 16);
    }
    return _fromRadix(raw, 16);
  }

  static Color? _fromRadix(String source, int radix) {
    final parsed = int.tryParse(source, radix: radix);
    return parsed == null ? null : Color(parsed);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['progress'] = progress;
    data['color'] = color;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectCategoriesProgressModel.fromJson(json);
  }
}
