import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/app_event.dart';
import '../../../../core/app_state.dart';

class JobsBloc extends Bloc<AppEvent, AppState> {
  JobsBloc() : super(Start()) {
    on<Click>(onClick);
    updateExpandedIndex(-1);
    on<Expand>(onExpand);
  }

  final _expandedIndex = BehaviorSubject<int?>.seeded(-1);

  Function(int?) get updateExpandedIndex => _expandedIndex.sink.add;

  Stream<int?> get updateExpandedStream =>
      _expandedIndex.stream.asBroadcastStream();

  Future<void> onExpand(Expand event, Emitter<AppState> emit) async {
    int index = event.arguments as int;
    if (_expandedIndex.value == index) {
      updateExpandedIndex(-1);
    } else {
      updateExpandedIndex(index);
    }
    emit(Done());
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
    // try {
    //   emit(Loading());
    //
    //   Response res = await JobsRepo.getObjectActiveCategorized();
    //
    //   if (res.statusCode == 200 && res.data != null) {
    //     List<JobsModel> data = List<JobsModel>.from(
    //         res.data["data"].map((e) => JobsModel.fromJson(e)));
    //     emit(Done(list: data));
    //   } else {
    //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //     emit(Error());
    //   }
    // } catch (e) {
    //   AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //
    //   emit(Error());
    // }
  }
}
