import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/prompt_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PromptBuilder', () {
    const builder = PromptBuilder();
    late String systemInstruction;

    setUpAll(() async {
      systemInstruction = await rootBundle.loadString(
        'assets/ai/prompts/system_instruction.txt',
      );
    });

    test('builds prompt with system instruction and user message', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'Summarize project risks.',
      );

      expect(prompt, contains('local, phase-1 AI assistant'));
      expect(prompt, contains('Summarize project risks.'));
      expect(prompt, contains('Assistant response:'));
    });

    test('Arabic user message produces Arabic-language guidance', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'ما هي المشاريع المتأخرة؟',
      );

      expect(
        builder.detectLanguage('ما هي المشاريع المتأخرة؟'),
        PromptLanguage.arabic,
      );
      expect(prompt, contains('answer in Arabic'));
    });

    test('English user message produces English-language guidance', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'What are the main delivery risks?',
      );

      expect(
        builder.detectLanguage('What are the main delivery risks?'),
        PromptLanguage.english,
      );
      expect(prompt, contains('answer in English'));
    });

    test(
      'mixed Arabic and English message uses dominant language handling',
      () {
        const arabicDominant = 'ما حالة project Alpha والمخاطر؟';
        const englishDominant = 'Summarize مخاطر project Alpha this week';

        expect(
          builder.detectLanguage(arabicDominant),
          PromptLanguage.mixedArabicDominant,
        );
        expect(
          builder.detectLanguage(englishDominant),
          PromptLanguage.mixedEnglishDominant,
        );
        expect(
          builder.build(
            systemInstruction: systemInstruction,
            userText: arabicDominant,
          ),
          contains('answer mainly in Arabic'),
        );
        expect(
          builder.build(
            systemInstruction: systemInstruction,
            userText: englishDominant,
          ),
          contains('answer mainly in English'),
        );
      },
    );

    test('valid small metadata is included', () {
      final metadata = const MetadataLoader().parse(_metadata());
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'What does delayed mean?',
        metadata: metadata,
        metadataDomains: ['projects'],
      );

      expect(prompt, contains('Optional safe context:'));
      expect(prompt, contains('Projects / المشاريع'));
      expect(prompt, contains('delayed (Delayed / متأخر)'));
    });

    test('oversized metadata is not included', () {
      final metadata = const MetadataLoader().parse(
        _metadata(extraDescription: 'x' * 1600),
      );
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'What does delayed mean?',
        metadata: metadata,
      );

      expect(prompt, isNot(contains('Optional safe context:')));
    });

    test('missing metadata does not crash prompt building', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'Give me a concise update.',
        metadata: null,
      );

      expect(prompt, contains('Give me a concise update.'));
      expect(prompt, isNot(contains('Optional safe context:')));
    });

    test(
      'can include compact active model information without access details',
      () {
        final model = ModelCatalog().primary;
        final prompt = builder.build(
          systemInstruction: systemInstruction,
          userText: 'Hi',
          activeModel: model,
        );

        expect(prompt, contains('Active local model: Gemma 3 1B (~529 MB).'));
        expect(prompt, isNot(contains(model.accessNote)));
      },
    );

    test('prompt stays free-text and avoids future-scope instructions', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'What are the delayed projects?',
      );
      final lower = prompt.toLowerCase();

      expect(lower, isNot(contains('intent')));
      expect(lower, isNot(contains('json')));
      expect(lower, isNot(contains('sql')));
      expect(lower, isNot(contains('db')));
      expect(lower, isNot(contains('mcp')));
      expect(lower, isNot(contains('backend')));
    });

    test('prompt contains local free-text no-live-data limitation', () {
      final prompt = builder.build(
        systemInstruction: systemInstruction,
        userText: 'What is current project status?',
      );

      expect(prompt, contains('generated locally as free text'));
      expect(prompt, contains('not live system results'));
      expect(prompt, contains('do not have enough information'));
    });
  });

  group('PromptBuilder truncation (fix #1)', () {
    const sys = 'SYSTEM: local free-text only. Do not invent live data.';

    test('long user message: stays within budget, keeps cue + system + label',
        () {
      const builder = PromptBuilder(maxPromptChars: 400);
      final longUser = 'X' * 5000;
      final prompt = builder.build(systemInstruction: sys, userText: longUser);

      expect(prompt.length, lessThanOrEqualTo(400));
      expect(prompt.trimRight().endsWith('Assistant response:'), isTrue);
      expect(prompt, contains('SYSTEM: local free-text only.'));
      expect(prompt, contains('User message:'));
      // User text was truncated (not the full 5000 chars) with an ellipsis.
      expect(prompt, contains('…'));
      expect('X'.allMatches(prompt).length, lessThan(5000));
    });

    test('short user message is preserved verbatim, ends with cue', () {
      const builder = PromptBuilder(maxPromptChars: 2200);
      final prompt =
          builder.build(systemInstruction: sys, userText: 'ما هي المشاريع المتأخرة؟');
      expect(prompt, contains('ما هي المشاريع المتأخرة؟'));
      expect(prompt.trimRight().endsWith('Assistant response:'), isTrue);
      expect(prompt, isNot(contains('…')));
    });

    test('tight budget still ends with the assistant cue', () {
      const builder = PromptBuilder(maxPromptChars: 200);
      final prompt =
          builder.build(systemInstruction: sys, userText: 'Y' * 1000);
      expect(prompt.length, lessThanOrEqualTo(200));
      expect(prompt.trimRight().endsWith('Assistant response:'), isTrue);
    });
  });
}

String _metadata({String extraDescription = ''}) => jsonEncode({
  'version': 'sample',
  'generated_at': '2026-06-29T00:00:00Z',
  'domains': {
    'projects': {
      'label': {'en': 'Projects', 'ar': 'المشاريع'},
      'terms': [
        {
          'key': 'delayed',
          'label': {'en': 'Delayed', 'ar': 'متأخر'},
        },
      ],
      'concepts': [
        {
          'key': 'progress',
          'label': {'en': 'Progress', 'ar': 'نسبة الإنجاز'},
          'description': {
            'en': 'High-level completion indicator.$extraDescription',
            'ar': 'مؤشر عام لمستوى الإنجاز.',
          },
        },
      ],
      'enums': [],
    },
  },
});
