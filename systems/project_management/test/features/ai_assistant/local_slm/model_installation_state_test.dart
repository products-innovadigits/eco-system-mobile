import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';

void main() {
  group('ModelInstallationState', () {
    test('represents the full planned lifecycle', () {
      expect(ModelInstallationState.values, containsAll([
        ModelInstallationState.notInstalled,
        ModelInstallationState.downloading,
        ModelInstallationState.installed,
        ModelInstallationState.failed,
        ModelInstallationState.corrupt,
      ]));
    });

    test('only installed is usable', () {
      expect(ModelInstallationState.installed.isUsable, isTrue);
      expect(ModelInstallationState.downloading.isUsable, isFalse);
      expect(ModelInstallationState.corrupt.isUsable, isFalse);
      expect(ModelInstallationState.notInstalled.isUsable, isFalse);
    });

    test('downloadable from notInstalled/failed/corrupt only', () {
      expect(ModelInstallationState.notInstalled.isDownloadable, isTrue);
      expect(ModelInstallationState.failed.isDownloadable, isTrue);
      expect(ModelInstallationState.corrupt.isDownloadable, isTrue);
      expect(ModelInstallationState.installed.isDownloadable, isFalse);
      expect(ModelInstallationState.downloading.isDownloadable, isFalse);
    });

    test('wire name round-trips; unknown falls back to notInstalled', () {
      for (final s in ModelInstallationState.values) {
        expect(ModelInstallationStateX.fromWireName(s.wireName), s);
      }
      expect(
        ModelInstallationStateX.fromWireName('bogus'),
        ModelInstallationState.notInstalled,
      );
      expect(
        ModelInstallationStateX.fromWireName(null),
        ModelInstallationState.notInstalled,
      );
    });
  });
}
