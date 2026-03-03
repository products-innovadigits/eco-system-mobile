import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_events.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_states.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleReviewBloc extends Bloc<CycleReviewEvent, CycleReviewState> {
  final CycleReviewRepo repo;

  CycleReviewBloc({required this.repo}) : super(const CycleReviewInitial()) {
    on<LoadCycleReview>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCycleReview event,
    Emitter<CycleReviewState> emit,
  ) async {
    try {
      emit(const CycleReviewLoading());

      CycleDetailModel model = await repo.getCycleDetail(event.cycleId);

      if (model.data != null) {
        emit(CycleReviewLoaded(detail: model.data!));
      } else {
        emit(const CycleReviewFailure(message: 'No data found'));
      }
    } catch (e) {
      emit(CycleReviewFailure(message: e.toString()));
    }
  }
}
