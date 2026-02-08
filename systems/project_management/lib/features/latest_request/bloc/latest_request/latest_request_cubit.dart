import 'package:project_management/core/utility/project_management_exports.dart';

class LatestRequestCubit extends Cubit<LatestRequestState> {
  final LatestRequestRepo repo;
  final bool _ownsSearchController;

  LatestRequestCubit({
    required this.repo,
    TextEditingController? searchController,
  })  : _ownsSearchController = searchController == null,
        searchTEC = searchController ?? TextEditingController(),
        super(const LatestRequestInitial());

  final TextEditingController searchTEC;

  Future<void> getLatestRequest({SearchEngine? searchEngine}) async {
    emit(const LatestRequestLoading());
    try {
      LatestRequestModel model = await repo.getLatestRequest(
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
    if (_ownsSearchController) {
      searchTEC.dispose();
    }
    return super.close();
  }
}
