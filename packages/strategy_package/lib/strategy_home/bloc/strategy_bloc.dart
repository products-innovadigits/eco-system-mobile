

import '../../shared/strategy_exports.dart';

class StrategyBloc extends Bloc<AppEvent, AppState> {
  StrategyBloc() : super(Start()) {
    // on<Click>(onClick);
  }

  // onClick(AppEvent event, Emitter<AppState> emit) async {
  //   try {
  //     emit(Loading());
  //
  //     Response res =
  //     await ObjectiveDetailsRepo.getObjectDetails(event.arguments as int);
  //
  //     if (res.statusCode == 200 &&
  //         res.data != null &&
  //         res.data["data"] != null) {
  //       KpisInitiativesProgressModel model =
  //       KpisInitiativesProgressModel.fromJson(res.data["data"]);
  //       emit(Done(model: model));
  //     } else {
  //       AppCore.errorMessage(allTranslations.text('something_went_wrong'));
  //       emit(Error());
  //     }
  //   } catch (e) {
  //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
  //
  //     emit(Error());
  //   }
  // }
}
