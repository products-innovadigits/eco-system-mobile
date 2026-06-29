import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';

/// Builds the compact free-text prompt that will later be sent to
/// LocalSlmService.generateText.
///
/// Phase-1 prompt output stays natural-language only and offline/local-ready.
class PromptBuilder {
  const PromptBuilder({
    this.maxPromptChars = 2200,
    this.maxMetadataChars = 900,
  });

  final int maxPromptChars;
  final int maxMetadataChars;

  PromptLanguage detectLanguage(String text) {
    var arabic = 0;
    var latin = 0;
    for (final codePoint in text.runes) {
      if ((codePoint >= 0x0600 && codePoint <= 0x06FF) ||
          (codePoint >= 0x0750 && codePoint <= 0x077F) ||
          (codePoint >= 0x08A0 && codePoint <= 0x08FF)) {
        arabic++;
      } else if ((codePoint >= 0x0041 && codePoint <= 0x005A) ||
          (codePoint >= 0x0061 && codePoint <= 0x007A)) {
        latin++;
      }
    }

    if (arabic > 0 && latin > 0) {
      return arabic >= latin
          ? PromptLanguage.mixedArabicDominant
          : PromptLanguage.mixedEnglishDominant;
    }
    if (arabic > 0) return PromptLanguage.arabic;
    return PromptLanguage.english;
  }

  /// The trailing cue the model continues from. Always kept at the very end of
  /// the prompt; never truncated away.
  static const String _assistantCue = 'Assistant response:';

  /// Marker that the variable section (user text / metadata) was shortened.
  static const String _ellipsis = ' …';

  String build({
    required String userText,
    required String systemInstruction,
    MetadataBundle? metadata,
    Iterable<String>? metadataDomains,
    ModelCatalogEntry? activeModel,
  }) {
    final trimmedSystem = systemInstruction.trim();
    final trimmedUserText = userText.trim();
    final language = detectLanguage(trimmedUserText);

    // Fixed structural sections that must always survive truncation.
    final fixedSections = <String>[
      trimmedSystem,
      _languageInstruction(language),
      if (activeModel != null)
        'Active local model: ${activeModel.displayName} (${activeModel.estimatedSizeLabel}).',
    ].where((section) => section.trim().isNotEmpty).toList();

    // Budget = total minus the fixed sections, the user-message label, the
    // assistant cue, and the separators between all joined sections. Only the
    // *variable* parts (metadata + user text) are trimmed to fit this budget.
    const userLabel = 'User message:\n';
    const separator = '\n\n';
    final fixedJoined = fixedSections.join(separator);
    // Sections after the fixed block: [optional metadata], user message, cue.
    // Account for separators: fixed↔(rest) + between each remaining section.
    final fixedOverhead =
        fixedJoined.length +
        separator.length + // fixed ↔ user message (metadata adds its own below)
        userLabel.length +
        separator.length + // user message ↔ assistant cue
        _assistantCue.length;
    var variableBudget = maxPromptChars - fixedOverhead;
    if (variableBudget < 0) variableBudget = 0;

    // Metadata is optional context; give it at most maxMetadataChars but never
    // more than half of whatever variable budget remains, so the user message
    // is never starved.
    var metadataText =
        metadata?.compactText(
          domainIds: metadataDomains,
          maxChars: maxMetadataChars,
        ) ??
        '';
    if (metadataText.isNotEmpty) {
      final metadataCap = variableBudget ~/ 2;
      final metadataSection = 'Optional safe context:\n$metadataText';
      if (metadataSection.length + separator.length > metadataCap) {
        // Drop metadata entirely rather than emit a confusingly cut fragment.
        metadataText = '';
      }
    }

    final hasMetadata = metadataText.isNotEmpty;
    final metadataSection =
        hasMetadata ? 'Optional safe context:\n$metadataText' : '';
    final remainingForUser = hasMetadata
        ? variableBudget - metadataSection.length - separator.length
        : variableBudget;

    final safeUserText = _fitUserText(
      trimmedUserText,
      remainingForUser < 0 ? 0 : remainingForUser,
    );

    final sections = <String>[
      ...fixedSections,
      if (hasMetadata) metadataSection,
      '$userLabel$safeUserText',
      _assistantCue,
    ].where((section) => section.trim().isNotEmpty).join(separator);

    return sections;
  }

  /// Truncates the user message to [budget] chars, preserving a trailing
  /// ellipsis marker so the model can tell the input was shortened. Never
  /// returns more than [budget] characters.
  String _fitUserText(String text, int budget) {
    if (text.length <= budget) return text;
    if (budget <= _ellipsis.length) {
      return text.substring(0, budget);
    }
    final keep = budget - _ellipsis.length;
    return '${text.substring(0, keep).trimRight()}$_ellipsis';
  }

  String _languageInstruction(PromptLanguage language) {
    switch (language) {
      case PromptLanguage.arabic:
        return 'Language guidance: answer in Arabic.';
      case PromptLanguage.english:
        return 'Language guidance: answer in English.';
      case PromptLanguage.mixedArabicDominant:
        return 'Language guidance: the message mixes Arabic and English; answer mainly in Arabic and preserve necessary English terms.';
      case PromptLanguage.mixedEnglishDominant:
        return 'Language guidance: the message mixes Arabic and English; answer mainly in English and preserve necessary Arabic terms.';
    }
  }
}

enum PromptLanguage {
  arabic,
  english,
  mixedArabicDominant,
  mixedEnglishDominant,
}
