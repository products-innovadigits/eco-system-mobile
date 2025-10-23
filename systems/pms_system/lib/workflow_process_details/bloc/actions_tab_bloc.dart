import 'dart:developer';
import 'dart:io';
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class ActionsTabBloc extends Bloc<AppEvent, AppState> {
  ActionsTabBloc() : super(Start()) {
    on<Click>(_onClick);
    on<ComplianceClick>(_onComplianceClick);
    on<PickFile>(_onPickFile);
    on<RemoveFile>(_onRemoveFile);
  }

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controller for comment field
  final TextEditingController commentController = TextEditingController();

  // File-related state
  File? selectedFile;
  String? fileName;
  String? fileSize;

  Future<void> _onClick(Click event, Emitter<AppState> emit) async {
    // Validate form first
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      emit(Loading());

      final arguments = event.arguments as Map<String, dynamic>;
      final projectId = arguments['projectId'] as int;
      final projectStepId = arguments['projectStepId'] as int;
      final processId = arguments['processId'] as int;

      // Get text from controller
      final text = commentController.text.trim();

      final Response response =
          await WorkflowProcessDetailsRepo.addProjectStepComment(
            projectId: projectId,
            projectStepId: projectStepId,
            processId: processId,
            text: text,
            file: selectedFile,
          );

      if (response.statusCode == 200) {
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.comment_added_successfully),
        );
        // Clear form after successful submission
        commentController.clear();
        _clearFile();
        emit(Done());
      } else {
        AppCore.errorMessage(
          allTranslations.text(LocaleKeys.something_went_wrong),
        );
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      emit(Error());
    }
  }

  Future<void> _onComplianceClick(
    ComplianceClick event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(Loading());

      final arguments = event.arguments as Map<String, dynamic>;
      final projectId = arguments['projectId'] as int;
      final processId = arguments['processId'] as int;
      final nextStepId = arguments['nextStepId'] as int;

      final Response response = await WorkflowProcessDetailsRepo.moveToNextStep(
        processId: processId,
        projectId: projectId,
        nextStepId: nextStepId,
      );

      if (response.statusCode == 200) {
        AppCore.successMessage(response.data['data'] as String);
        emit(Done());
      } else {
        AppCore.errorMessage(
          allTranslations.text(LocaleKeys.something_went_wrong),
        );
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      emit(Error());
    }
  }

  Future<void> _onPickFile(PickFile event, Emitter<AppState> emit) async {
    try {
      File? file = await FilePickerHelper.pickFileAsFile(
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'jpg',
          'jpeg',
          'png',
          'gif',
        ],
      );

      if (file != null) {
        int fileLength = await file.length();
        selectedFile = file;
        fileName = FilePickerHelper.getFileName(file.path);
        fileSize = FilePickerHelper.formatFileSize(fileLength);
        emit(FileSelected());
      }
    } catch (e) {
      print('Error picking file: $e');
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
    }
  }

  void _onRemoveFile(RemoveFile event, Emitter<AppState> emit) {
    _clearFile();
    emit(FileRemoved());
  }

  void _clearFile() {
    selectedFile = null;
    fileName = null;
    fileSize = null;
  }

  @override
  Future<void> close() {
    commentController.dispose();
    return super.close();
  }
}

// Custom events for file handling
class PickFile extends AppEvent {
  PickFile() : super(null);
}

class RemoveFile extends AppEvent {
  RemoveFile() : super(null);
}

// Custom event for compliance button
class ComplianceClick extends AppEvent {
  ComplianceClick({Object? arguments}) : super(arguments);
}

// Custom states for file handling
class FileSelected extends AppState {
  @override
  Map<String, dynamic> toJson() => {'state': 'FileSelected'};
}

class FileRemoved extends AppState {
  @override
  Map<String, dynamic> toJson() => {'state': 'FileRemoved'};
}
