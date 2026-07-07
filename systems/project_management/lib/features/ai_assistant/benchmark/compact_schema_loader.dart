import 'package:flutter/services.dart';

const compactSchemaPackageAssetPath =
    'packages/project_management/assets/ai/schema/'
    'nawah_compact_schema_no_terms.slim.v1.txt';
const compactSchemaAssetPath =
    'assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt';

Future<String> loadCompactSchema({AssetBundle? assetBundle}) async {
  final bundle = assetBundle ?? rootBundle;

  try {
    return await bundle.loadString(compactSchemaPackageAssetPath);
  } catch (_) {
    return bundle.loadString(compactSchemaAssetPath);
  }
}
