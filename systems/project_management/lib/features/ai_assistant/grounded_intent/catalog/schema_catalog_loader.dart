import 'dart:convert';

import 'package:flutter/services.dart';

import 'schema_catalog.dart';
import 'schema_catalog_validator.dart';

class SchemaCatalogLoader {
  const SchemaCatalogLoader({
    AssetBundle? assetBundle,
    this.assetPath = defaultAssetPath,
    this.validateOnLoad = true,
  }) : _assetBundle = assetBundle;

  static const String defaultAssetPath = 'assets/ai/schema/schema_catalog.json';

  final AssetBundle? _assetBundle;
  final String assetPath;
  final bool validateOnLoad;

  Future<SchemaCatalog?> load() async {
    final bundle = _assetBundle ?? rootBundle;
    final candidates = <String>[
      assetPath,
      'packages/project_management/$assetPath',
    ];
    String? text;
    for (final path in candidates) {
      try {
        text = await bundle.loadString(path);
        break;
      } catch (_) {
        // Try the package-prefixed path when hosted by another app.
      }
    }
    if (text == null) return null;
    return parse(text);
  }

  SchemaCatalog parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const SchemaCatalogException('Catalog root must be an object.');
    }
    final catalog = SchemaCatalog.fromJson(decoded);
    if (validateOnLoad) {
      final errors = const SchemaCatalogValidator().validate(catalog);
      if (errors.isNotEmpty) {
        throw SchemaCatalogException(
          'Invalid schema catalog: ${errors.map((e) => e.toString()).join('; ')}',
        );
      }
    }
    return catalog;
  }
}
