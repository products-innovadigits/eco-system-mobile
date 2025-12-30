import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/bloc/latest_request/latest_request_state.dart';

class LatestRequestCubit extends Cubit<LatestRequestState> {
  LatestRequestCubit() : super(const LatestRequestInitial());

  TextEditingController searchTEC = TextEditingController();

  Future<void> getLatestRequest({SearchEngine? searchEngine}) async {
    emit(const LatestRequestLoading());
    try {
      LatestRequestModel model = await LatestRequestRepo.getLatestRequest(
        searchEngine ?? SearchEngine(),
      );

      if (model.succeeded == true &&
          model.data != null &&
          model.data!.isNotEmpty) {
        emit(LatestRequestLoaded(requests: model.data!));
      } else {
        emit(LatestRequestEmpty(isInitial: searchEngine == null));
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(
        const LatestRequestFailure(message: 'Failed to load latest request'),
      );
    }
  }

  Future<void> refreshLatestRequest() async {
    await getLatestRequest(searchEngine: SearchEngine());
  }

  @override
  Future<void> close() {
    searchTEC.dispose();
    return super.close();
  }
}
