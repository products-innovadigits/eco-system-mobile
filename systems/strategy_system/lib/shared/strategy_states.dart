import 'package:core_system/core/core/core_state.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';

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
