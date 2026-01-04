import 'dart:developer';
import 'dart:io';

import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/actions_tab/actions_tab_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/actions_tab/actions_tab_state.dart';
import 'package:pms_system/features/workflow_process_details/repo/workflow_process_details_repo.dart';

class ActionsTabBloc extends Bloc<ActionsTabEvent, ActionsTabState> {
  ActionsTabBloc() : super(const ActionsTabInitial()) {
    on<SaveComment>(_onSaveComment);
    on<MoveToNextStep>(_onMoveToNextStep);
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

  // Flag to track if compliance was just completed (for reload trigger)
  bool _isComplianceCompleted = false;

  // Flag to track which action is currently loading
  bool _isComplianceActionLoading = false;

  // Getter to check if compliance was just completed
  bool get isComplianceCompleted => _isComplianceCompleted;

  // Getter to check if compliance action is currently loading
  bool get isComplianceActionLoading => _isComplianceActionLoading;

  // Method to reset the compliance completed flag
  void resetComplianceFlag() {
    _isComplianceCompleted = false;
  }

  Future<void> _onSaveComment(
    SaveComment event,
    Emitter<ActionsTabState> emit,
  ) async {
    // Validate form first
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      _isComplianceActionLoading = false; // This is a save action
      emit(const ActionsTabLoading());

      // Get text from controller
      final text = commentController.text.trim();

      final Response response =
          await WorkflowProcessDetailsRepo.addProjectStepComment(
            projectId: event.projectId,
            projectStepId: event.projectStepId,
            processId: event.processId,
            text: text,
            file: selectedFile,
          );

      if (response.statusCode == 200) {
        AppCore.successToastMessage(
          allTranslations.text(LocaleKeys.comment_added_successfully),
        );
        // Clear form after successful submission
        commentController.clear();
        _clearFile();
        _isComplianceCompleted = false; // This is a save action, not compliance
        _isComplianceActionLoading = false;
        emit(const ActionsTabSuccess());
      } else {
        AppCore.errorToastMessage(
          allTranslations.text(LocaleKeys.something_went_wrong),
        );
        _isComplianceActionLoading = false;
        emit(const ActionsTabFailure(message: 'Failed to save comment'));
      }
    } catch (e) {
      _isComplianceActionLoading = false;
      emit(const ActionsTabFailure(message: 'Failed to save comment'));
    }
  }

  Future<void> _onMoveToNextStep(
    MoveToNextStep event,
    Emitter<ActionsTabState> emit,
  ) async {
    try {
      _isComplianceActionLoading = true; // This is a compliance action
      emit(const ActionsTabLoading());

      final Response response = await WorkflowProcessDetailsRepo.moveToNextStep(
        processId: event.processId,
        projectId: event.projectId,
        nextStepId: event.nextStepId,
      );

      if (response.statusCode == 200) {
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.process_done_successfully),
        );
        _isComplianceCompleted = true; // Mark that compliance was completed
        _isComplianceActionLoading = false; // Compliance action is done
        emit(const ActionsTabSuccess());
      } else {
        AppCore.errorMessage(
          allTranslations.text(LocaleKeys.something_went_wrong),
        );
        _isComplianceCompleted = false; // Reset on error
        _isComplianceActionLoading = false;
        emit(const ActionsTabFailure(message: 'Failed to move to next step'));
      }
    } catch (e) {
      _isComplianceCompleted = false; // Reset on error
      _isComplianceActionLoading = false;
      emit(const ActionsTabFailure(message: 'Failed to move to next step'));
    }
  }

  Future<void> _onPickFile(
    PickFile event,
    Emitter<ActionsTabState> emit,
  ) async {
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
        emit(const ActionsTabFileSelected());
      }
    } catch (e) {
      log('Error picking file: $e');
    }
  }

  void _onRemoveFile(RemoveFile event, Emitter<ActionsTabState> emit) {
    _clearFile();
    emit(const ActionsTabFileRemoved());
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
