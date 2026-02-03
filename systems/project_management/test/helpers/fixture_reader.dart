import 'dart:convert';
import 'dart:io';

Map<String, dynamic> readJsonFixture(String relativePath) {
  final file = File('test/fixtures/$relativePath');
  if (!file.existsSync()) {
    throw Exception('Fixture not found at: ${file.absolute.path}');
  }
  final jsonString = file.readAsStringSync();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
