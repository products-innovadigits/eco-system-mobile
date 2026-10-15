import '../../shared/strategy_exports.dart';

class ObjectiveKPISBloc extends ObjectiveListBloc<ObjectiveKPIModel> {
  @override
  Future<dynamic> fetch(int id) => ObjectiveDetailsRepo.getObjectiveKPIS(id);

  @override
  ObjectiveKPIModel fromJson(Map<String, dynamic> json) =>
      ObjectiveKPIModel.fromJson(json);
}
