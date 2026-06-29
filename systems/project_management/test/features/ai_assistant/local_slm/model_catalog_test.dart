import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';

void main() {
  group('ModelCatalog', () {
    final catalog = ModelCatalog();

    test('exposes exactly 2 seed model entries', () {
      expect(catalog.entries.length, 2);
    });

    test('contains Gemma 3 1B as the first integration (primary) model', () {
      final gemma = catalog.byId('gemma_3_1b');
      expect(gemma, isNotNull);
      expect(gemma!.role, ModelRole.firstIntegration);
      expect(gemma.isPrimary, isTrue);
      expect(catalog.primary.id, 'gemma_3_1b');
      expect(gemma.format, ModelFormat.mediapipeTask);
      expect(gemma.expectedFileName, 'gemma3-1b-it-int4.task');
      expect(gemma.estimatedSizeLabel, '~529 MB');
      expect(gemma.gated, isTrue); // Gemma Terms
      expect(gemma.supportStatus, ModelSupportStatus.deskVerified);
    });

    test('contains Qwen2.5 1.5B as the Arabic challenger (conditional)', () {
      final qwen = catalog.byId('qwen_2_5_1_5b');
      expect(qwen, isNotNull);
      expect(qwen!.role, ModelRole.arabicChallenger);
      expect(qwen.isPrimary, isFalse);
      expect(qwen.gated, isFalse); // Apache-2.0
      expect(qwen.estimatedSizeLabel, '~1.57 GB');
      expect(qwen.supportStatus, ModelSupportStatus.conditional);
    });

    test('every entry carries required display + download metadata fields', () {
      for (final e in catalog.entries) {
        expect(e.id, isNotEmpty);
        expect(e.displayName, isNotEmpty);
        expect(e.shortDescription, isNotEmpty);
        expect(e.recommendationLabel, isNotEmpty);
        expect(e.version, isNotEmpty);
        expect(e.expectedSizeBytes, greaterThan(0));
        expect(e.accessNote, isNotEmpty);
      }
    });

    test('Gemma stays gated with no URL; Qwen is the demo-downloadable model', () {
      final gemma = catalog.byId('gemma_3_1b')!;
      // Gemma is gated → no public URL until distribution is resolved (FU-2).
      expect(gemma.gated, isTrue);
      expect(gemma.downloadUrl, isNull);

      // Qwen is the POC_DEMO_REAL_CHAT model: real public ungated URL, no SHA256
      // (checksum relaxed in demo mode).
      final qwen = catalog.byId('qwen_2_5_1_5b')!;
      expect(qwen.downloadUrl, isNotNull);
      expect(qwen.downloadUrl, contains('huggingface.co/litert-community/Qwen2.5-1.5B-Instruct'));
      expect(qwen.downloadUrl, endsWith('.task'));
      expect(qwen.sha256, isNull); // TODO(prod-hardening): enforce later
    });

    test('byId returns null for unknown id', () {
      expect(catalog.byId('does_not_exist'), isNull);
    });

    test('entries list is immutable (no files bundled, manifest only)', () {
      expect(
        () => catalog.entries.add(catalog.entries.first),
        throwsUnsupportedError,
      );
    });
  });
}
