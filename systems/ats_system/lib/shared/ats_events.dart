import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/core/core_event.dart';

class InitCandidates extends AppEvent {
  final String? targetStage;
  final List<StageModel>? stages;
  final String? jobTitle;

  InitCandidates({this.targetStage, this.stages, this.jobTitle}) : super(null);
}
