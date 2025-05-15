import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_event.dart';
import '../../../../core/app_state.dart';

class CandidatesBloc extends Bloc<AppEvent, AppState> {
  CandidatesBloc() : super(Start()) {
    on<InitCandidates>(_onInitCandidates);
    on<Click>(_onClick);
  }

  final ScrollController scrollController = ScrollController();


  final Map<String, GlobalKey> stageKeys = {
    'المرحلة التطبيقية': GlobalKey(),
    'مرحلة المقابلة الهاتفية': GlobalKey(),
    'مرحلة التقييم': GlobalKey(),
    'مرحلة المقابلة': GlobalKey(),
    'مرحلة العرض': GlobalKey(),
    'مرحلة التوظيف': GlobalKey(),
  };

  List<String> get stages => stageKeys.keys.toList();

  Map<String, GlobalKey> get keys => stageKeys;

  void scrollToStage(String stage) {
    final key = stageKeys[stage];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  void _onInitCandidates(InitCandidates event, Emitter<AppState> emit) {
    emit(Done(data: event.arguments as String?));
    WidgetsBinding.instance.addPostFrameCallback((_) {
     if(event.arguments != null) scrollToStage(event.arguments as String);
    });
  }

  void _onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
  }
}
