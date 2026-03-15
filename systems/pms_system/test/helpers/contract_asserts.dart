import 'package:flutter_test/flutter_test.dart';

enum DataShape { map, list, any }

void expectWrapperContract(
  Map<String, dynamic> json, {
  required DataShape dataShape,
}) {
  expect(json.containsKey('succeeded'), isTrue,
      reason:
          'Contract error: missing "succeeded" key. Available keys: ${json.keys.toList()}');
  expect(json.containsKey('data'), isTrue,
      reason:
          'Contract error: missing "data" key. Available keys: ${json.keys.toList()}');

  final data = json['data'];
  switch (dataShape) {
    case DataShape.map:
      expect(data, isA<Map<String, dynamic>>(),
          reason:
              'Contract error: "data" should be a Map but was ${data.runtimeType}.\nJSON: $json');
      break;
    case DataShape.list:
      expect(data, isA<List>(),
          reason:
              'Contract error: "data" should be a List but was ${data.runtimeType}.\nJSON: $json');
      break;
    case DataShape.any:
      break;
  }
}
