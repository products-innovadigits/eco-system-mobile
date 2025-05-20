import 'package:dio/dio.dart';
import 'package:eco_system/features/ats/profile/repo/profile_repo.dart';
import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/utility/export.dart';

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(Start()) {
    on<Click>(_getTalentDetails);
    on<Select>(_onSelectTab);
    on<SelectTab>(_onSelectRatingTab);
    on<ShowDialog>(_onShowMoreDialog);
    on<Expand>(_onExpand);
    on<ToggleExpand>(_onToggleExpansion);
    on<UpdateRating>(_onUpdateRating);
    on<AddComment>(_onAddComment);
    on<ToggleCommentField>(_onToggleCommentField);
  }

  bool isCareerObjExpanded = false;
  bool isEducationExpanded = false;
  bool isWorkExperienceExpanded = false;
  int reviewExpandedIndex = -1;
  bool showMoreDialog = false;

  CandidateModel? candidateModel;
  ProfileEnum selectedTab = ProfileEnum.profile;
  int selectedRatingTabIndex = 0;
  List<RatingItemModel> ratingItems = [
    RatingItemModel(title: LocaleKeys.technical_skills),
    RatingItemModel(title: LocaleKeys.knowledge),
    RatingItemModel(title: LocaleKeys.communications),
  ];

  _onUpdateRating(UpdateRating event, Emitter<AppState> emit) {
    ratingItems[event.index] =
        ratingItems[event.index].copyWith(rating: event.rating);
    emit(Done());
  }

  _onAddComment(AddComment event, Emitter<AppState> emit) {
    ratingItems[event.index] = ratingItems[event.index].copyWith(
      comment: event.comment,
      isCommentFieldVisible: false,
    );
    emit(Done());
  }

  _onToggleCommentField(ToggleCommentField event, Emitter<AppState> emit) {
    ratingItems[event.index] = ratingItems[event.index].copyWith(
      isCommentFieldVisible: !ratingItems[event.index].isCommentFieldVisible,
    );
    emit(Done());
  }

  _onExpand(Expand event, Emitter<AppState> emit) async {
    if (event.arguments == 2) {
      isCareerObjExpanded = !isCareerObjExpanded;
    } else if (event.arguments == 1) {
      isEducationExpanded = !isEducationExpanded;
    } else if (event.arguments == 0) {
      isWorkExperienceExpanded = !isWorkExperienceExpanded;
    }
    showMoreDialog = false;
    emit(Done());
  }

  _onToggleExpansion(ToggleExpand event, Emitter<AppState> emit) async {
    int index = event.arguments as int;
    if (reviewExpandedIndex == index) {
      reviewExpandedIndex = -1;
    } else {
      reviewExpandedIndex = index;
    }
    emit(Done());
  }

  _onSelectTab(Select event, Emitter<AppState> emit) async {
    showMoreDialog = false;
    final ProfileEnum tab = event.arguments as ProfileEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
    }
    emit(Done());
  }

  _onSelectRatingTab(SelectTab event, Emitter<AppState> emit) async {
    int tabIndex = event.arguments as int;
    if (selectedRatingTabIndex != tabIndex) {
      selectedRatingTabIndex = tabIndex;
    }
    emit(Done());
  }

  _onShowMoreDialog(ShowDialog event, Emitter<AppState> emit) async {
    bool? isDialogOpen = event.arguments as bool?;
    if (isDialogOpen == null) {
      showMoreDialog = !showMoreDialog;
    } else {
      showMoreDialog = false;
    }

    emit(Done());
  }

  void resetRatingBottomSheetData() {
    selectedRatingTabIndex = 0;
    reviewExpandedIndex = -1;
    ratingItems = [
      RatingItemModel(title: LocaleKeys.technical_skills),
      RatingItemModel(title: LocaleKeys.knowledge),
      RatingItemModel(title: LocaleKeys.communications),
    ];
  }

  _getTalentDetails(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res =
          await ProfileRepo.getCandidateDetails(event.arguments as int);

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data["data"] != null) {
        CandidateModel model = CandidateModel.fromJson(res.data["data"]);
        candidateModel = model;
        emit(Done());
      } else {
        AppCore.errorMessage(allTranslations.text('something_went_wrong'));
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
