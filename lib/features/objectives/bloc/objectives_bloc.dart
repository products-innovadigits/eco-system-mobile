import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../../../model/search_engine.dart';
import '../model/objectives_model.dart';
import '../repo/objectives_repo.dart';
import '../widgets/objective_card.dart';

class ObjectivesBloc extends Bloc<AppEvent, AppState> {
  ObjectivesBloc() : super(Start()) {
    on<Click>(_getObjectives);
    scrollController = ScrollController();
    customScroll(scrollController);
  }

  late SearchEngine _engine;
  final List<Widget> _cards = [];

  late ScrollController scrollController;

  customScroll(scrollController) {
    scrollController.addListener(() {
      bool scroll = AppCore.scrollListener(
          scrollController, _engine.maxPages, _engine.currentPage);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage);
        add(Click(arguments: _engine));
      }
    });
  }

  _getObjectives(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        _cards.clear();
        emit(Loading());
      } else {
        emit(Done(cards: _cards, loading: true));
      }

      ObjectivesModel res = await ObjectivesRepo.getObjectives(_engine);

      if (res.data!.isNotEmpty) {
        for (var objective in res.data ?? []) {
          _cards.add(ObjectiveCard(objective: objective));
        }
        if (_cards.isNotEmpty) {
          emit(Done(cards: _cards));
        } else {
          emit(Empty());
        }
        _engine.currentPage += 1;
        _engine.maxPages += 1;
        // _engine.updateCurrentPage(res.meta!.currPage!);
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
