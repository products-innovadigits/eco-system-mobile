import 'package:core_package/core/utility/export.dart';
class BscModel extends SingleMapper {
  bool? succeeded;
  VisionDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  BscModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  BscModel.fromJson(Map<String, dynamic> json) {
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
  Mapper fromJson(Map<String, dynamic> json) => BscModel.fromJson(json);

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

class VisionDataModel {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  List<MissionModel>? missions;
  // List<ObjectActiveModel>? objectActives;
  List<StrategicAxisModel>? strategicAxises;
  List<ManzorModel>? manzors;
  List<ValueModel>? values;

  VisionDataModel({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.missions,
    // this.objectActives,
    this.strategicAxises,
    this.manzors,
    this.values,
  });

  VisionDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    isActive = json['isActive'] as bool?;
    if (json['missions'] != null) {
      missions = <MissionModel>[];
      for (var v in json['missions'] as List) {
        missions!.add(MissionModel.fromJson(v as Map<String, dynamic>));
      }
    }
    // if (json['objectActives'] != null) {
    //   objectActives = <ObjectActiveModel>[];
    //   for (var v in json['objectActives'] as List) {
    //     objectActives!.add(ObjectActiveModel.fromJson(v as Map<String, dynamic>));
    //   }
    // }
    if (json['strategicAxises'] != null) {
      strategicAxises = <StrategicAxisModel>[];
      for (var v in json['strategicAxises'] as List) {
        strategicAxises!.add(StrategicAxisModel.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['manzors'] != null) {
      manzors = <ManzorModel>[];
      for (var v in json['manzors'] as List) {
        manzors!.add(ManzorModel.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['values'] != null) {
      values = <ValueModel>[];
      for (var v in json['values'] as List) {
        values!.add(ValueModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isActive': isActive,
    };
    if (missions != null) {
      map['missions'] = missions!.map((e) => e.toJson()).toList();
    }
    // if (objectActives != null) {
    //   map['objectActives'] = objectActives!.map((e) => e.toJson()).toList();
    // }
    if (strategicAxises != null) {
      map['strategicAxises'] = strategicAxises!.map((e) => e.toJson()).toList();
    }
    if (manzors != null) {
      map['manzors'] = manzors!.map((e) => e.toJson()).toList();
    }
    if (values != null) {
      map['values'] = values!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

/// Missions
class MissionModel {
  int? id;
  String? name;
  int? vesionId;

  MissionModel({this.id, this.name, this.vesionId});

  MissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    vesionId = json['vesionId'] as int?;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vesionId': vesionId,
  };
}

/// Strategic Axis
class StrategicAxisModel {
  int? id;
  String? title;
  String? description;
  String? colorCode;
  bool? isShow;
  int? typeAxisLookupId;

  StrategicAxisModel({
    this.id,
    this.title,
    this.description,
    this.colorCode,
    this.isShow,
    this.typeAxisLookupId,
  });

  StrategicAxisModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    colorCode = json['colorCode'] as String?;
    isShow = json['isShow'] as bool?;
    typeAxisLookupId = json['typeAxisLookupId'] as int?;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'colorCode': colorCode,
    'isShow': isShow,
    'typeAxisLookupId': typeAxisLookupId,
  };
}

/// Manzor
class ManzorModel {
  int? id;
  String? title;
  List<ObjectActiveModel>? objectives;

  ManzorModel({this.id, this.title , this.objectives});

  ManzorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    if (json['objectActives'] != null) {
      objectives = <ObjectActiveModel>[];
      for (var v in json['objectActives'] as List) {
        objectives!.add(ObjectActiveModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'objectActives': objectives != null
        ? objectives!.map((e) => e.toJson()).toList()
        : <ObjectActiveModel>[],
  };
}

/// Values
class ValueModel {
  int? id;
  String? name;
  int? vesionId;

  ValueModel({this.id, this.name, this.vesionId});

  ValueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    vesionId = json['vesionId'] as int?;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vesionId': vesionId,
  };
}

/// ObjectActive (with KPIs & Initiatives)
class ObjectActiveModel {
  int? id;
  String? title;
  String? description;
  int? strategicAxisId;
  int? manzorId;
  List<int>? releatedIds;
  List<IndicatorModel>? kpIs;
  List<IndicatorModel>? initiatives;

  ObjectActiveModel({
    this.id,
    this.title,
    this.description,
    this.strategicAxisId,
    this.manzorId,
    this.releatedIds,
    this.kpIs,
    this.initiatives,
  });

  ObjectActiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    strategicAxisId = json['strategicAxisId'] as int?;
    manzorId = json['manzorId'] as int?;
    if (json['releatedIds'] != null) {
      releatedIds = List<int>.from(json['releatedIds'] as List);
    }
    if (json['kpIs'] != null) {
      kpIs = <IndicatorModel>[];
      for (var v in json['kpIs'] as List) {
        kpIs!.add(IndicatorModel.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['initiatives'] != null) {
      initiatives = <IndicatorModel>[];
      for (var v in json['initiatives'] as List) {
        initiatives!
            .add(IndicatorModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'strategicAxisId': strategicAxisId,
      'manzorId': manzorId,
      'releatedIds': releatedIds,
    };
    if (kpIs != null) {
      map['kpIs'] = kpIs!.map((e) => e.toJson()).toList();
    }
    if (initiatives != null) {
      map['initiatives'] = initiatives!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

/// KPI
class IndicatorModel {
  int? id;
  String? title;
  String? description;

  IndicatorModel({this.id, this.title, this.description});

  IndicatorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };
}

// /// Initiative
// class InitiativeModel {
//   int? id;
//   String? title;
//   String? description;
//
//   InitiativeModel({this.id, this.title, this.description});
//
//   InitiativeModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     title = json['title'] as String?;
//     description = json['description'] as String?;
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'description': description,
//   };
// }
