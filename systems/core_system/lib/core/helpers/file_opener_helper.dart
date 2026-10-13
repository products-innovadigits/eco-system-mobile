import 'dart:developer';
import 'dart:io';

import 'package:core_system/core/utility/export.dart';
import 'package:dio/io.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads a file inside the app and opens it with the device's viewer.
///
/// Files are fetched through the same HTTP client as the API, so the server's
/// certificate is accepted here, where a browser would stop on a warning.
abstract class FileOpenerHelper {
  /// Its own client: the API client logs every response and toasts API
  /// errors, neither of which fits a file download.
  static final Dio _dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 40),
            receiveTimeout: const Duration(minutes: 2),
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: Network.createHttpClient,
        );

  static Future<void> downloadAndOpen({
    required BuildContext context,
    required String url,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );

    String? error;
    try {
      final file = await download(url);
      final result = await OpenFilex.open(file.path);
      if (result.type == ResultType.noAppToOpen) {
        error = allTranslations.text(LocaleKeys.no_app_to_open_file);
      } else if (result.type != ResultType.done) {
        log('Failed to open ${file.path}: ${result.message}');
        error = allTranslations.text(LocaleKeys.download_failed);
      }
    } catch (e) {
      log('Failed to download $url: $e');
      error = allTranslations.text(LocaleKeys.download_failed);
    } finally {
      if (navigator.mounted && navigator.canPop()) navigator.pop();
    }

    if (error != null) AppCore.errorToastMessage(error);
  }

  /// Downloads [url] into the app's cache, reusing an earlier download of the
  /// same URL. Each URL gets its own folder, so the file keeps its own name
  /// for the viewer while two URLs ending in the same name never collide.
  static Future<File> download(String url) async {
    final cacheDir = await getTemporaryDirectory();
    final file = File(
      '${cacheDir.path}/attachments/${urlHash(url)}/${cacheFileName(url)}',
    );
    if (await file.exists() && await file.length() > 0) return file;

    await file.parent.create(recursive: true);
    // Written aside first, so an interrupted download is never reused.
    final partial = File('${file.path}.part');
    try {
      await _dio.download(url, partial.path);
      return await partial.rename(file.path);
    } catch (_) {
      if (await partial.exists()) await partial.delete();
      rethrow;
    }
  }

  /// FNV-1a hash of [url]. Unlike [String.hashCode] it is the same on every
  /// run, so a cached download is found again after a restart.
  @visibleForTesting
  static String urlHash(String url) {
    var hash = 0x811c9dc5;
    for (final unit in url.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  /// The URL's file name, safe to use as a single path segment.
  @visibleForTesting
  static String cacheFileName(String url) {
    final segments = Uri.tryParse(url)?.pathSegments ?? const <String>[];
    final name = segments.isNotEmpty && segments.last.isNotEmpty
        ? segments.last
        : 'file';
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }
}
