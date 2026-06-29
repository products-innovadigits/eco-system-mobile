import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_log.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';

/// CTA shown on a model card.
enum ModelCtaType {
  /// Not installed (or failed/corrupt without a usable file) → "Download".
  download,

  /// Installed and usable → "Use".
  use,

  /// File present but checksum/version mismatch → "Repair".
  repair,
}

/// Immutable view-model for one model card in the Model Selection UI.
class ModelCardViewModel {
  const ModelCardViewModel({
    required this.id,
    required this.displayName,
    required this.estimatedSizeLabel,
    required this.shortDescription,
    required this.recommendationLabel,
    required this.installState,
    required this.isActive,
    required this.cta,
    required this.gated,
    required this.accessNote,
  });

  final String id;
  final String displayName;
  final String estimatedSizeLabel;
  final String shortDescription;
  final String recommendationLabel;
  final ModelInstallationState installState;
  final bool isActive;
  final ModelCtaType cta;
  final bool gated;
  final String accessNote;

  bool get isInstalled => installState.isUsable;
}

/// Planned action emitted by [ModelSelectionController.onSelect].
///
/// The controller never downloads, never runs inference, and never navigates.
/// It only sets the active model (for installed selections) and reports what
/// the caller should do next. M3 wires [DownloadRequired] to real downloads;
/// chat wiring (M4/M6) wires [OpenChatRequested] to the local chat route.
sealed class ModelSelectionAction {
  const ModelSelectionAction(this.modelId);
  final String modelId;
}

/// Selected model is installed and has been set active (in the current
/// in-memory session). Caller may route to chat once chat wiring exists.
class OpenChatRequested extends ModelSelectionAction {
  const OpenChatRequested(super.modelId);
}

/// Selected model is not installed. **No download is started in M2.**
/// M3 will wire this to the actual user-initiated download flow.
class DownloadRequired extends ModelSelectionAction {
  const DownloadRequired(super.modelId);
}

/// Selected model's file is corrupt (checksum/version mismatch) → repair/redownload.
class RepairRequired extends ModelSelectionAction {
  const RepairRequired(super.modelId);
}

/// Drives the Model Selection UI from [ModelCatalog] + [ActiveModelStore].
///
/// M2 scope: no download, no inference, no durable persistence. Active-model
/// state is set/read via the (in-memory) [ActiveModelStore]; durability across
/// app restart is deferred (see FU-DURABLE-STORE).
class ModelSelectionController {
  ModelSelectionController({
    required this.catalog,
    required this.activeModelStore,
  });

  final ModelCatalog catalog;
  final ActiveModelStore activeModelStore;

  /// Build the cards for the selection screen. Reflects current install/active
  /// state from [ActiveModelStore]. Opening the screen does NOT start downloads.
  List<ModelCardViewModel> buildCards() {
    final active = activeModelStore.activeModelId;
    return catalog.entries.map((e) {
      final state = activeModelStore.statusOf(e.id);
      return ModelCardViewModel(
        id: e.id,
        displayName: e.displayName,
        estimatedSizeLabel: e.estimatedSizeLabel,
        shortDescription: e.shortDescription,
        recommendationLabel: e.recommendationLabel,
        installState: state,
        isActive: active == e.id,
        cta: _ctaFor(state),
        gated: e.gated,
        accessNote: e.accessNote,
      );
    }).toList(growable: false);
  }

  ModelCtaType _ctaFor(ModelInstallationState state) {
    switch (state) {
      case ModelInstallationState.installed:
        return ModelCtaType.use;
      case ModelInstallationState.corrupt:
        return ModelCtaType.repair;
      case ModelInstallationState.notInstalled:
      case ModelInstallationState.downloading:
      case ModelInstallationState.failed:
        return ModelCtaType.download;
    }
  }

  /// Handle a model card tap.
  ///
  /// - Installed → set active (in-memory) and return [OpenChatRequested].
  /// - Corrupt → return [RepairRequired] (no active change).
  /// - Otherwise → return [DownloadRequired] (**no download started in M2**, no
  ///   active change).
  Future<ModelSelectionAction> onSelect(String modelId) async {
    final state = activeModelStore.statusOf(modelId);
    final ModelSelectionAction action;
    switch (state) {
      case ModelInstallationState.installed:
        await activeModelStore.setActiveModel(modelId);
        action = OpenChatRequested(modelId);
      case ModelInstallationState.corrupt:
        action = RepairRequired(modelId);
      case ModelInstallationState.notInstalled:
      case ModelInstallationState.downloading:
      case ModelInstallationState.failed:
        action = DownloadRequired(modelId);
    }
    aiLog(
      'select id=$modelId state=${state.name} action=${action.runtimeType}',
    );
    return action;
  }
}
