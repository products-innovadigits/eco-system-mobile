import '../../shared/strategy_exports.dart';

class ObjectiveInitiativesBloc
    extends ObjectiveListBloc<ObjectiveInitiativeModel> {
  @override
  Future<dynamic> fetch(int id) =>
      ObjectiveDetailsRepo.getObjectiveInitiatives(id);

  @override
  ObjectiveInitiativeModel fromJson(Map<String, dynamic> json) =>
      ObjectiveInitiativeModel.fromJson(json);
}
