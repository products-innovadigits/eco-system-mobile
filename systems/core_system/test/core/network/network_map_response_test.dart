import 'package:core_system/core/debug/debug_interceptor.dart';
import 'package:core_system/core/debug/debug_log_store.dart';
import 'package:core_system/core/network/mapper.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the hand-written models: assigns JSON straight into typed fields.
class _StepModel implements SingleMapper {
  num? status;

  _StepModel();

  _StepModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => _StepModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'status': status};
}

/// Runs [options] through [DebugInterceptor] so it carries an overlay entry.
RequestOptions _trackedOptions() {
  final options = RequestOptions(path: 'https://api.test/Project/494');
  DebugInterceptor().onRequest(options, RequestInterceptorHandler());
  return options;
}

void main() {
  setUp(DebugLogStore.instance.clear);

  group('Network.mapResponse', () {
    test('returns the mapped model when the JSON matches', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 200,
        data: {'status': 2},
      );

      final result = Network.mapResponse(_StepModel(), response);

      expect(result, isA<_StepModel>());
      expect((result as _StepModel).status, 2);
    });

    test('rethrows the original parse error instead of swallowing it', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 200,
        data: {'status': 'None'},
      );

      expect(
        () => Network.mapResponse(_StepModel(), response),
        throwsA(isA<TypeError>()),
      );
    });

    test('marks the overlay entry as failed with the model and cause', () {
      final options = _trackedOptions();
      final response = Response(
        requestOptions: options,
        statusCode: 200,
        data: {'status': 'None'},
      );

      expect(
        () => Network.mapResponse(_StepModel(), response),
        throwsA(isA<TypeError>()),
      );

      final entry = DebugLogStore.instance.logs.single;
      expect(entry.isSuccess, isFalse);
      expect(entry.error, contains('Failed to parse _StepModel'));
      expect(entry.error, contains('/Project/494'));
      expect(entry.error, contains("'String' is not a subtype of type 'num?'"));
    });

    test('leaves the overlay alone when the request was not tracked', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 200,
        data: {'status': 'None'},
      );

      expect(
        () => Network.mapResponse(_StepModel(), response),
        throwsA(isA<TypeError>()),
      );
      expect(DebugLogStore.instance.logs, isEmpty);
    });
  });
}
