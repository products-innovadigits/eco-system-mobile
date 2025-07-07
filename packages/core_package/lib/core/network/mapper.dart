abstract class Mapper {
  factory Mapper(Mapper type, dynamic data) {
    if (type is SingleMapper) {
      return type.fromJson(data);
    } else if (type is ListMapper) {
      return type.fromJsonList(data as List);
    } else if (type is LocaleSingleMapper) {
      return type.fromMapper(data);
    }
    return Mapper(type, data);
  }
  Map<String, dynamic> toJson();
}

abstract class SingleMapper implements Mapper {
  Mapper fromJson(Map<String, dynamic> json);
  @override
  Map<String, dynamic> toJson();
}

abstract class ListMapper implements Mapper {
  Mapper fromJsonList(List json);
}

abstract class LocaleSingleMapper implements Mapper {
  Mapper fromMapper(Map<String, dynamic> data);
  Map<String, dynamic> toMap();
}
