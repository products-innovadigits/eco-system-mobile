import 'dart:convert';
import 'dart:io';

Map<String, dynamic> readJsonFixture(String relativePath) {
  final localPath = 'test/fixtures/$relativePath';
  File file = File(localPath);

  if (!file.existsSync()) {
    final fallbackPath = 'systems/pms_system/test/fixtures/$relativePath';
    file = File(fallbackPath);
  }

  if (!file.existsSync()) {
    throw Exception('Fixture not found at: ${file.absolute.path}');
  }

  final jsonString = file.readAsStringSync();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
