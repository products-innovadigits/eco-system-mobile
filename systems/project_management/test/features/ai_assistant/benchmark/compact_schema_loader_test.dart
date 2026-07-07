import 'dart:convert';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/benchmark/compact_schema_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadCompactSchema', () {
    test('loads the bundled compact schema as unchanged raw text', () async {
      final schema = await loadCompactSchema();
      final directAssetText = await rootBundle.loadString(
        compactSchemaAssetPath,
      );

      expect(schema, isNotEmpty);
      expect(schema.length, greaterThan(0));
      expect(schema, directAssetText);
    });

    test(
      'falls back to the bare asset path when package path is missing',
      () async {
        const rawSchema = 'raw compact schema text\nunchanged';
        final bundle = _FallbackAssetBundle(rawSchema);

        final schema = await loadCompactSchema(assetBundle: bundle);

        expect(schema, rawSchema);
        expect(bundle.loadedKeys, [
          compactSchemaPackageAssetPath,
          compactSchemaAssetPath,
        ]);
      },
    );
  });
}

class _FallbackAssetBundle extends CachingAssetBundle {
  _FallbackAssetBundle(this.rawSchema);

  final String rawSchema;
  final List<String> loadedKeys = [];

  @override
  Future<ByteData> load(String key) async {
    loadedKeys.add(key);

    if (key == compactSchemaPackageAssetPath) {
      throw FlutterError('missing package asset');
    }
    if (key == compactSchemaAssetPath) {
      final bytes = Uint8List.fromList(utf8.encode(rawSchema));
      return ByteData.view(bytes.buffer);
    }

    throw FlutterError('unexpected asset path: $key');
  }
}
