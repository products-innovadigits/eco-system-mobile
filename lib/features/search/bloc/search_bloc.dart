import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_event.dart';
import '../../../core/app_state.dart';

class SearchBloc extends Bloc<AppEvent, AppState> {
  SearchBloc() : super(Start()) {
    on<Click>(onClick);
    on<TapSearch>(_onTapSearch);
    on<Searching>(_onSearching);
    on<CancelSearch>(_onCancelSearch);
  }

  TextEditingController searchController = TextEditingController();
  bool isActiveSearching = false;

  void _onTapSearch(TapSearch event, Emitter<AppState> emit) {
    isActiveSearching = true;
    emit(Done());
  }

  void _onSearching(Searching event, Emitter<AppState> emit) {
    emit(Done());
  }

  void _onCancelSearch(CancelSearch event, Emitter<AppState> emit) {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
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
