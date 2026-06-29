import 'dart:convert';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MetadataLoader', () {
    const loader = MetadataLoader();

    test('loads bundled sample metadata asset', () async {
      final bundle = await loader.load();

      expect(bundle, isNotNull);
      expect(bundle!.version, 'sample-2026-06');
      expect(
        bundle.domains.keys,
        containsAll(['projects', 'meetings', 'strategy']),
      );
      expect(bundle.generatedAt.toIso8601String(), '2026-06-29T00:00:00.000Z');
    });

    test('builds compact context with Arabic and English labels', () {
      final bundle = loader.parse(_validMetadata());

      final text = bundle.compactText(domainIds: ['projects'], maxChars: 900);

      expect(text, contains('Projects / المشاريع'));
      expect(text, contains('delayed (Delayed / متأخر)'));
      expect(text, isNot(contains('Meetings')));
      expect(text.length, lessThanOrEqualTo(900));
    });

    test('returns empty compact context when selected domain is absent', () {
      final bundle = loader.parse(_validMetadata());

      expect(bundle.compactText(domainIds: ['unknown']), isEmpty);
    });

    test(
      'returns empty compact context when metadata would exceed max size',
      () {
        final bundle = loader.parse(
          _validMetadata(extraDescription: 'x' * 1600),
        );

        expect(bundle.compactText(maxChars: 200), isEmpty);
      },
    );

    test('malformed metadata throws validation error', () {
      expect(
        () => loader.parse('{"version": "x", "generated_at": 7}'),
        throwsA(isA<MetadataValidationException>()),
      );
    });

    test('tryParse returns safe fallback for malformed metadata', () {
      expect(loader.tryParse('not-json'), isNull);
    });

    test('forbidden metadata keys are rejected', () {
      for (final key in [
        'sql',
        'database_credentials',
        'dsn',
        'tenant_secrets',
        'permission_logic',
        'real_data_rows',
        'table_columns',
        'api_token',
      ]) {
        final source = jsonEncode({
          'version': 'sample',
          'generated_at': '2026-06-29T00:00:00Z',
          'domains': {
            'projects': {
              'label': {'en': 'Projects', 'ar': 'المشاريع'},
              key: 'forbidden',
            },
          },
        });

        expect(
          () => loader.parse(source),
          throwsA(isA<MetadataValidationException>()),
          reason: key,
        );
      }
    });

    test('missing metadata asset returns null fallback', () async {
      final missingLoader = MetadataLoader(
        assetBundle: _MissingAssetBundle(),
        assetPath: 'assets/ai/missing.json',
      );

      expect(await missingLoader.load(), isNull);
    });
  });

  group('forbidden-key matching (fix #3)', () {
    const loader = MetadataLoader();

    Map<String, Object?> domainWithExtraKey(String key) => {
          'version': 'v1',
          'generated_at': '2026-06-29T00:00:00Z',
          'domains': {
            'projects': {
              'label': {'en': 'Projects', 'ar': 'المشاريع'},
              'terms': [],
              'concepts': [],
              'enums': [],
              key: 'anything',
            },
          },
        };

    for (final unsafe in [
      'sql',
      'database',
      'db',
      'dsn',
      'password',
      'secret',
      'token',
      'access_token',
      'refresh_token',
      'tenant_secret',
      'permission',
      'permissions',
      'table',
      'column',
      'rows',
      'schema',
      'connection',
      'connection_string',
      'apiKey',
    ]) {
      test('blocks unsafe key "$unsafe"', () {
        expect(
          () => loader.parse(jsonEncode(domainWithExtraKey(unsafe))),
          throwsA(isA<MetadataValidationException>()),
        );
      });
    }

    for (final safe in ['feedback', 'borrow', 'tablet', 'rowdy', 'columnist']) {
      test('allows safe collision word as a domain key "$safe"', () {
        final json = {
          'version': 'v1',
          'generated_at': '2026-06-29T00:00:00Z',
          'domains': {
            safe: {
              'label': {'en': 'Safe', 'ar': 'آمن'},
              'terms': [],
              'concepts': [],
              'enums': [],
            },
          },
        };
        final bundle = loader.parse(jsonEncode(json));
        expect(bundle.domains.containsKey(safe), isTrue);
      });
    }

    test('detects nested unsafe key inside a term', () {
      final json = {
        'version': 'v1',
        'generated_at': '2026-06-29T00:00:00Z',
        'domains': {
          'projects': {
            'label': {'en': 'Projects', 'ar': 'المشاريع'},
            'terms': [
              {
                'key': 'delayed',
                'label': {'en': 'Delayed', 'ar': 'متأخر'},
                'password': 'leak',
              },
            ],
            'concepts': [],
            'enums': [],
          },
        },
      };
      expect(
        () => loader.parse(jsonEncode(json)),
        throwsA(isA<MetadataValidationException>()),
      );
    });

    test('shipped metadata.sample.json remains valid', () async {
      final bundle = await const MetadataLoader().load();
      expect(bundle, isNotNull);
      expect(bundle!.domains, isNotEmpty);
    });
  });
}

String _validMetadata({String extraDescription = ''}) => jsonEncode({
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
      'enums': [
        {
          'key': 'status',
          'values': [
            {
              'key': 'in_progress',
              'label': {'en': 'In progress', 'ar': 'قيد التنفيذ'},
            },
          ],
        },
      ],
    },
    'meetings': {
      'label': {'en': 'Meetings', 'ar': 'الاجتماعات'},
      'terms': [],
      'concepts': [],
      'enums': [],
    },
  },
});

class _MissingAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('missing');
  }
}
