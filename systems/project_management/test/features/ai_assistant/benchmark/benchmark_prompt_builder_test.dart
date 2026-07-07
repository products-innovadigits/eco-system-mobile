import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_prompt_builder.dart';

void main() {
  group('buildBenchmarkPrompt', () {
    const schema = 'alpha_table|alpha_id|beta_id\nbeta_table|id|label';
    const question = 'what is the budget of أتمتة العقود والقوانين';

    String build() =>
        buildBenchmarkPrompt(compactSchema: schema, question: question);

    test('embeds schema and question verbatim', () {
      final prompt = build();

      expect(prompt, contains('SCHEMA:\n$schema'));
      expect(prompt, contains('QUESTION:\n$question'));
    });

    test('places the schema before the question (schema-first order)', () {
      final prompt = build();

      expect(prompt.indexOf(schema), lessThan(prompt.indexOf(question)));
      expect(prompt.trimRight().endsWith('ANSWER:'), isTrue);
    });

    test('emits exactly five output labels in order, without Entity(s)', () {
      final prompt = build();
      final labels = [
        'Table(s):',
        'Column(s):',
        'Relationship(s):',
        'Filter(s):',
        'Order By(s):',
      ];
      var previousIndex = -1;

      for (final label in labels) {
        final index = prompt.indexOf(label);
        expect(index, greaterThan(previousIndex), reason: label);
        previousIndex = index;
      }

      expect(prompt, isNot(contains('Entity(s)')));
      expect(prompt, isNot(contains('Sort(s)')));
    });

    test('does not mention SQL anywhere', () {
      final prompt = build();

      expect(prompt.toLowerCase(), isNot(contains('sql')));
    });

    test('has no literal backslash-n or anti-newline guidance', () {
      final prompt = build();

      expect(prompt, isNot(contains(r'\n')));
      expect(prompt.toLowerCase(), isNot(contains('backslash')));
      // Uses the plain one-line-per-label phrasing instead.
      expect(prompt, contains('one real line per label'));
    });

    test('includes the compact spelling guard and lookup ids', () {
      final prompt = build();

      expect(
        prompt,
        contains(
          'Use Projects.PeriortyLevelId exactly. Never use Projects.PriorityLevelId.',
        ),
      );
      expect(prompt, contains('Risk high=1, medium=2, low=3 -> Projects.RiskLevelId'));
      expect(
        prompt,
        contains('Priority high=1, medium=2, low=3 -> Projects.PeriortyLevelId'),
      );
    });

    test('keeps the direct progress and manager mapping hints', () {
      final prompt = build();

      // Progress uses the Projects metric column, not the child/detail table.
      expect(prompt, contains('Projects.OutputCount'));
      expect(prompt, contains('not ProjectOutPutModels'));
      // Manager questions join Projects to AspNetUsers.
      expect(prompt, contains('Projects.ManagerId -> AspNetUsers.Id'));
      expect(prompt, contains('AspNetUsers.FullName'));
    });

    test('strengthens Arabic/text preservation for filters', () {
      final prompt = build();

      expect(
        prompt,
        contains(
          'Never translate or rewrite text copied from QUESTION into Filter(s)',
        ),
      );
      expect(
        prompt,
        contains('Copy Arabic names and titles exactly as they appear in QUESTION'),
      );
    });

    test('separates lookup filters from ordering in the Order By rule', () {
      final prompt = build();

      expect(
        prompt,
        contains(
          'High/low risk and high/low priority are lookup filters, not ordering',
        ),
      );
      // Ranking keywords, including Arabic, gate Order By.
      expect(prompt, contains('تقدما'));
    });

    test('ends with the compact output guard before ANSWER', () {
      final prompt = build();

      final guard =
          'Return only the 5 labeled lines. Start with Table(s): and stop after Order By(s):.';
      expect(prompt, contains(guard));
      expect(prompt.indexOf(guard), greaterThan(prompt.indexOf('QUESTION:\n')));
      expect(prompt.indexOf(guard), lessThan(prompt.indexOf('ANSWER:')));
    });

    test('uses at most one worked example and no benchmark questions', () {
      final prompt = build();

      // Exactly one EXAMPLE block.
      expect('EXAMPLE:'.allMatches(prompt).length, 1);

      // No exact benchmark questions baked into the template.
      final template = prompt.substring(0, prompt.indexOf('QUESTION:\n'));
      const benchmarkPhrases = [
        'استعراض المخاطر والتدقيق التشغيلي',
        'أتمتة العقود والقوانين',
        'أكثر المشاريع تقدما من حيث المخرجات',
        'مشاريع عالية الخطورة',
        'low priority projects',
        'high risk projects',
      ];
      for (final phrase in benchmarkPhrases) {
        expect(template, isNot(contains(phrase)), reason: phrase);
      }
    });

    test('is much shorter than the previous policy-heavy prompt', () {
      final prompt = build();

      // Previous prompt was ~7000 chars with the test schema; the compact
      // rewrite must be materially shorter.
      expect(prompt.length, lessThan(4000));
    });

    test('is deterministic for identical inputs', () {
      expect(build(), build());
    });
  });
}
