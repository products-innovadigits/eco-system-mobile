import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';

abstract class AppState {
  Map<String, dynamic> toJson();
}

class Start extends AppState {
  Start();

  @override
  Map<String, dynamic> toJson() => {"state": "Start"};
}

class Done extends AppState {
  Mapper? model;
  List<Widget>? cards;
  List<Mapper>? list;
  bool? reload;
  bool? loading;
  dynamic data;

  Done({
    this.model,
    this.data,
    this.cards,
    this.list,
    this.reload = true,
    this.loading = false,
  });

  @override
  Map<String, dynamic> toJson() => {
    "state": "Done",
    "model": jsonEncode(model?.toJson()),
    "list": jsonEncode(list?.map((e) => e.toJson()).toList()),
    "data": data is List<dynamic>
        ? jsonEncode(data?.map((e) => e.toJson()).toList())
        : jsonEncode(model?.toJson()),
    "cards": jsonEncode(cards),
    "reload": jsonEncode(reload),
    "loading": jsonEncode(loading),
  };
}

class Error extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "Error"};
}

class Loading extends AppState {
  int? progress;
  int? total;

  Loading({this.progress, this.total});

  @override
  Map<String, dynamic> toJson() => {"state": "Loading"};
}

class Exporting extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "Exporting"};
}

class Empty extends AppState {
  final bool? initial;

  Empty({this.initial});

  @override
  Map<String, dynamic> toJson() => {"state": "Empty"};
}

class BscLoaded extends AppState {
  final VisionDataModel? data;
  final int selectedAxes;
  final int expandedObjectiveId;
  final bool showKpis;
  final bool showInitiatives;
  final bool showMessages;

  BscLoaded({
    this.data,
    this.selectedAxes = 0,
    this.expandedObjectiveId = -1,
    this.showKpis = false,
    this.showInitiatives = false,
    this.showMessages = false,
  });

  BscLoaded copyWith({
    VisionDataModel? data,
    int? selectedAxes,
    int? expandedObjectiveId,
    bool? showKpis,
    bool? showInitiatives,
    bool? showMessages,
  }) {
    return BscLoaded(
      data: data ?? this.data,
      selectedAxes: selectedAxes ?? this.selectedAxes,
      expandedObjectiveId: expandedObjectiveId ?? this.expandedObjectiveId,
      showKpis: showKpis ?? this.showKpis,
      showInitiatives: showInitiatives ?? this.showInitiatives,
      showMessages: showMessages ?? this.showMessages,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "state": "BscLoaded",
    "data": data?.toJson(),
    "selectedAxes": selectedAxes,
    "expandedObjectiveId": expandedObjectiveId,
    "showKpis": showKpis,
    "showInitiatives": showInitiatives,
    "showMessages": showMessages,
  };
}
