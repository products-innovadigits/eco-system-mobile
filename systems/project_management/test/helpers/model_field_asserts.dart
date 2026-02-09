import 'package:flutter_test/flutter_test.dart';

/// Asserts that each (key, actual, expected) pair matches.
/// On failure, reports all failed/changed keys with expected vs actual so you
/// see exactly which JSON key or model field changed.
void expectModelFields(
  List<({String key, dynamic actual, dynamic expected})> checks,
) {
  final failures = <String>[];
  for (final c in checks) {
    final actual = c.actual;
    final expected = c.expected;
    final match = expected == actual ||
        (expected != null && actual != null && expected == actual);
    if (!match) {
      failures.add('  "${c.key}": expected $expected, got $actual');
    }
  }
  if (failures.isNotEmpty) {
    fail(
      'Failed/changed keys (fix JSON key or model mapping):\n${failures.join('\n')}',
    );
  }
}
