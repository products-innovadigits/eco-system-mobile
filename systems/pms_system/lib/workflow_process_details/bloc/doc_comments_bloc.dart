import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class DocCommentsBloc extends Bloc<AppEvent, AppState> {
  DocCommentsBloc() : super(Start()) {
    on<AddComment>(_onAddComment);
    on<Click>(_onClick);
  }

  TextEditingController commentCtrl = TextEditingController();
  CommentsData? _commentsData;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    int documentId = event.arguments as int;
    emit(Loading());
    try {
      DocumentCommentsModel res =
          await WorkflowProcessDetailsRepo.getDocComments(
            documentId: documentId,
          );

      if (res.succeeded == true && res.data != null) {
        _commentsData = res.data;
        if ((res.data!.items ?? []).isNotEmpty) {
          emit(Done(data: _commentsData));
        } else {
          emit(Empty());
        }
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  void _onAddComment(AppEvent event, Emitter<AppState> emit) {
    commentCtrl.clear();
    emit(Done(data: _commentsData));
  }
}
