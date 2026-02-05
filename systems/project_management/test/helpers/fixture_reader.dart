import 'dart:convert';
import 'dart:io';

Map<String, dynamic> readJsonFixture(String relativePath) {
  // Primary: when running tests from within the project_management package.
  final localPath = 'test/fixtures/$relativePath';
  File file = File(localPath);

  // Fallback: when running tests from the app root with a systems prefix.
  if (!file.existsSync()) {
    final fallbackPath = 'systems/project_management/test/fixtures/$relativePath';
    file = File(fallbackPath);
  }

  if (!file.existsSync()) {
    throw Exception('Fixture not found at: ${file.absolute.path}');
  }

  final jsonString = file.readAsStringSync();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
