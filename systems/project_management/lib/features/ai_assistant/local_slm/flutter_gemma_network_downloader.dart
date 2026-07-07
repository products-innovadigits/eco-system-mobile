import 'dart:async';

import 'package:flutter_gemma/flutter_gemma.dart' as gemma;
import 'package:project_management/features/ai_assistant/local_slm/ai_log.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';

/// POC_DEMO_REAL_CHAT real downloader.
///
/// Delegates the actual network download + on-device install to
/// `flutter_gemma` (which provides resume + an Android foreground service for
/// large files — important for the ~1.57 GB demo model). The model is stored in
/// the package-managed location; [FlutterGemmaLocalSlmService] then loads it via
/// `createModel()` (see `assumeAlreadyInstalled`).
///
/// Only runs when [ModelManager.downloadSelectedModel] is called — i.e. after
/// an explicit user "Download" tap. There is no auto-download path.
///
/// TODO(prod-hardening): add real cancel/resume control surfaced to the UI, and
/// validate the downloaded file with SHA256 once production checksums exist.
class FlutterGemmaNetworkDownloader implements ModelDownloader {
  const FlutterGemmaNetworkDownloader({this.token});

  /// Optional HF token for gated models. MUST stay null for the public demo
  /// model. TODO(prod-hardening): inject via secure config, never hardcode.
  final String? token;

  @override
  bool get isAvailable => true;

  @override
  Stream<double> download({
    required ModelCatalogEntry entry,
    required String destinationPath,
  }) {
    final url = entry.downloadUrl;
    final controller = StreamController<double>();

    if (url == null || url.isEmpty) {
      controller.addError(
        const ModelDownloadException('No download URL for this model.'),
      );
      controller.close();
      return controller.stream;
    }

    Future<void> run() async {
      try {
        // flutter_gemma must be initialized before installModel/createModel.
        // Safe to call repeatedly; this fixes "FlutterGemma not initialized".
        aiLog('download.network init id=${entry.id}');
        await gemma.FlutterGemma.initialize(huggingFaceToken: token);
        aiLog('download.network fetching id=${entry.id} url=$url');
        var builder = gemma.FlutterGemma.installModel(
          modelType: _modelTypeFor(entry.id),
          fileType: gemma.ModelFileType.task,
        ).fromNetwork(url, token: token).withProgress((p) {
          if (!controller.isClosed) {
            controller.add((p / 100).clamp(0.0, 1.0));
          }
        });
        await builder.install();
        aiLog('download.network install complete id=${entry.id}');
        if (!controller.isClosed) {
          controller.add(1.0);
          await controller.close();
        }
      } catch (e) {
        aiLog('download.network error id=${entry.id} err=$e');
        if (!controller.isClosed) {
          controller.addError(ModelDownloadException('$e'));
          await controller.close();
        }
      }
    }

    run();
    return controller.stream;
  }

  @override
  Future<void> cancel(String modelId) async {
    // TODO(prod-hardening): wire flutter_gemma cancellation when surfaced.
  }

  gemma.ModelType _modelTypeFor(String modelId) {
    // Match the whole Qwen 2.5 family (e.g. qwen_2_5_1_5b, ..._ekv4096) by
    // prefix so long-context variants are not misidentified as Gemma.
    if (modelId.startsWith('qwen_2_5')) return gemma.ModelType.qwen;
    return gemma.ModelType.gemmaIt;
  }
}

/// Demo path resolver. `flutter_gemma` manages the model file location itself,
/// so this returns a logical marker (stored only as informational `localPath`
/// in ActiveModelStore; never opened directly in demo mode).
///
/// TODO(prod-hardening): if we move to self-managed storage, return a real
/// app-documents path (path_provider) and download to it.
class DemoMarkerPathResolver implements ModelFilePathResolver {
  const DemoMarkerPathResolver();

  @override
  Future<String> resolve(ModelCatalogEntry entry) async =>
      'flutter_gemma://installed/${entry.id}/${entry.expectedFileName}';
}
