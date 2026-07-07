import 'package:get_it/get_it.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/flutter_gemma_local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/flutter_gemma_network_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_demo_flags.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_metrics.dart';
import 'package:project_management/features/ai_assistant/local_slm/prompt_builder.dart';

final GetIt projectManagementSl = GetIt.asNewInstance();

void setupProjectManagementLocator() {
  // Network
  if (!projectManagementSl.isRegistered<Network>()) {
    projectManagementSl.registerLazySingleton<Network>(() => Network());
  }

  // AI Assistant — Local SLM (M1: catalog + model-state persistence only).
  // No model files bundled; no download; no chat-history persistence.
  if (!projectManagementSl.isRegistered<ModelCatalog>()) {
    projectManagementSl.registerLazySingleton<ModelCatalog>(
      () => ModelCatalog(),
    );
  }
  // In-memory model-state store for now; swap to a durable backend
  // (Hive via core_system / shared_preferences) when wiring M2/M3.
  if (!projectManagementSl.isRegistered<ModelStateStore>()) {
    projectManagementSl.registerLazySingleton<ModelStateStore>(
      () => InMemoryModelStateStore(),
    );
  }
  if (!projectManagementSl.isRegistered<ActiveModelStore>()) {
    projectManagementSl.registerLazySingleton<ActiveModelStore>(
      () => ActiveModelStore(store: projectManagementSl<ModelStateStore>()),
    );
  }
  // M2: Model Selection (no download / no inference). Emits planned actions.
  if (!projectManagementSl.isRegistered<ModelSelectionController>()) {
    projectManagementSl.registerLazySingleton<ModelSelectionController>(
      () => ModelSelectionController(
        catalog: projectManagementSl<ModelCatalog>(),
        activeModelStore: projectManagementSl<ActiveModelStore>(),
      ),
    );
  }
  // M3 / POC_DEMO_REAL_CHAT: user-initiated download/install lifecycle.
  // In demo mode (kPocDemoRealChat) we wire the REAL flutter_gemma network
  // downloader so a public model can actually be fetched + installed; otherwise
  // the safe Noop/Pending defaults report `pendingDistribution` (no bytes).
  // TODO(prod-hardening): drop the demo branch and restore the gated defaults.
  if (!projectManagementSl.isRegistered<ModelDownloader>()) {
    projectManagementSl.registerLazySingleton<ModelDownloader>(
      () => kPocDemoRealChat
          ? const FlutterGemmaNetworkDownloader()
          : const NoopModelDownloader(),
    );
  }
  if (!projectManagementSl.isRegistered<ChecksumVerifier>()) {
    projectManagementSl.registerLazySingleton<ChecksumVerifier>(
      () => const PendingChecksumVerifier(),
    );
  }
  if (!projectManagementSl.isRegistered<ModelFilePathResolver>()) {
    projectManagementSl.registerLazySingleton<ModelFilePathResolver>(
      () => kPocDemoRealChat
          ? const DemoMarkerPathResolver()
          : const PendingModelFilePathResolver(),
    );
  }
  if (!projectManagementSl.isRegistered<DeviceCapabilityProbe>()) {
    projectManagementSl.registerLazySingleton<DeviceCapabilityProbe>(
      () => const PermissiveDeviceCapabilityProbe(),
    );
  }
  if (!projectManagementSl.isRegistered<ModelManager>()) {
    projectManagementSl.registerLazySingleton<ModelManager>(
      () => ModelManager(
        catalog: projectManagementSl<ModelCatalog>(),
        activeModelStore: projectManagementSl<ActiveModelStore>(),
        downloader: projectManagementSl<ModelDownloader>(),
        checksumVerifier: projectManagementSl<ChecksumVerifier>(),
        pathResolver: projectManagementSl<ModelFilePathResolver>(),
        deviceProbe: projectManagementSl<DeviceCapabilityProbe>(),
        // Demo: allow install without SHA256 (public URL only).
        // TODO(prod-hardening): set back to false (mandatory checksum).
        allowUnverifiedInstall: kPocDemoRealChat,
      ),
    );
  }
  // M4 / POC_DEMO_REAL_CHAT: text-only inference. Demo wires the REAL
  // flutter_gemma engine (model already network-installed → assumeAlreadyInstalled);
  // otherwise the safe UnavailableLocalSlmService (no inference).
  // TODO(prod-hardening): gate real engine behind FU-1 (device spike) + FU-2.
  if (!projectManagementSl.isRegistered<LocalSlmService>()) {
    projectManagementSl.registerLazySingleton<LocalSlmService>(
      () => kPocDemoRealChat
          ? FlutterGemmaLocalSlmService(
              assumeAlreadyInstalled: true,
              // Context length is per active model, sourced from the catalog's
              // `maxContextTokens` (e.g. ekv1280 → 1280, ekv4096 → 4096). The
              // config value below is only a fallback for unknown model ids.
              // Low temperature keeps the schema-mapping output stable and
              // structured (fewer format wobbles) while topK 40 avoids the
              // greedy repetition loop.
              catalog: projectManagementSl<ModelCatalog>(),
              config: const FlutterGemmaSpikeConfig(
                contextTokens: 4096,
                temperature: 0.2,
              ),
            )
          : const UnavailableLocalSlmService(),
    );
  }
  if (!projectManagementSl.isRegistered<PocMetrics>()) {
    projectManagementSl.registerLazySingleton<PocMetrics>(
      () => InMemoryPocMetrics(),
    );
  }
  // M5/M6-A2: prompt assembly + mobile-safe metadata. Registered before
  // AiInferenceController so local generation receives final prompts.
  if (!projectManagementSl.isRegistered<MetadataLoader>()) {
    projectManagementSl.registerLazySingleton<MetadataLoader>(
      () => const MetadataLoader(),
    );
  }
  if (!projectManagementSl.isRegistered<PromptBuilder>()) {
    projectManagementSl.registerLazySingleton<PromptBuilder>(
      () => const PromptBuilder(),
    );
  }
  if (!projectManagementSl.isRegistered<AiInferenceController>()) {
    projectManagementSl.registerLazySingleton<AiInferenceController>(
      () => AiInferenceController(
        activeModelStore: projectManagementSl<ActiveModelStore>(),
        modelManager: projectManagementSl<ModelManager>(),
        localSlm: projectManagementSl<LocalSlmService>(),
        metrics: projectManagementSl<PocMetrics>(),
        promptBuilder: projectManagementSl<PromptBuilder>(),
        metadataLoader: projectManagementSl<MetadataLoader>(),
      ),
    );
  }

  // Repositories
  if (!projectManagementSl.isRegistered<AiAssistantRepo>()) {
    projectManagementSl.registerLazySingleton<AiAssistantRepo>(
      () => AiAssistantRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<LatestRequestRepo>()) {
    projectManagementSl.registerLazySingleton<LatestRequestRepo>(
      () => LatestRequestRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectCategoriesProgressRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectCategoriesProgressRepo>(
      () => ProjectCategoriesProgressRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectDetailsRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectDetailsRepo>(
      () => ProjectDetailsRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectReportRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectReportRepo>(
      () => ProjectReportRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectsRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectsRepo>(
      () => ProjectsRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectProgressRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectProgressRepo>(
      () => ProjectProgressRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProcessDetailsRepo>()) {
    projectManagementSl.registerLazySingleton<ProcessDetailsRepo>(
      () => ProcessDetailsRepoImpl(network: projectManagementSl()),
    );
  }
}
