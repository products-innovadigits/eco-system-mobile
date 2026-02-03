import 'package:core_system/core/network/error/api_error_handler.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiErrorHandler', () {
    group('getException', () {
      test('returns unauthorized NetworkException for 401 response', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
            data: {'message': 'Token expired'},
          ),
          type: DioExceptionType.badResponse,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.isUnauthorized,
          isTrue,
          reason: 'Expected isUnauthorized to be true for 401 response',
        );
        expect(
          exception.statusCode,
          equals(401),
          reason: 'Expected statusCode to be 401',
        );
        expect(
          exception.type,
          equals(NetworkExceptionType.unauthorized),
          reason: 'Expected type to be unauthorized',
        );
        expect(
          exception.message,
          equals('Token expired'),
          reason: 'Expected message to be extracted from response data',
        );
      });

      test('returns timeout NetworkException for connection timeout', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.timeout),
          reason: 'Expected type to be timeout',
        );
        expect(
          exception.isTimeout,
          isTrue,
          reason: 'Expected isTimeout to be true',
        );
      });

      test('returns timeout for send timeout', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.sendTimeout,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.timeout),
          reason: 'Expected type to be timeout for sendTimeout',
        );
      });

      test('returns timeout for receive timeout', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.timeout),
          reason: 'Expected type to be timeout for receiveTimeout',
        );
      });

      test('returns noConnection for connection error', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.noConnection),
          reason: 'Expected type to be noConnection for connectionError',
        );
        expect(
          exception.isNoConnection,
          isTrue,
          reason: 'Expected isNoConnection to be true',
        );
      });

      test('returns cancelled for cancel type', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.cancelled),
          reason: 'Expected type to be cancelled',
        );
      });

      test('returns serverError for 500 response', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/test'),
            data: {'message': 'Internal server error'},
          ),
          type: DioExceptionType.badResponse,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.serverError),
          reason: 'Expected type to be serverError for 500',
        );
        expect(
          exception.statusCode,
          equals(500),
          reason: 'Expected statusCode to be 500',
        );
      });

      test('returns badRequest for 404 response', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/test'),
            data: {'message': 'Not found'},
          ),
          type: DioExceptionType.badResponse,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.type,
          equals(NetworkExceptionType.badRequest),
          reason: 'Expected type to be badRequest for 404',
        );
        expect(
          exception.statusCode,
          equals(404),
          reason: 'Expected statusCode to be 404',
        );
      });

      test('extracts message from nested data object', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/test'),
            data: {
              'data': {'message': 'Nested error message'}
            },
          ),
          type: DioExceptionType.badResponse,
        );

        final exception = ApiErrorHandler.getException(dioError);

        expect(
          exception.message,
          equals('Nested error message'),
          reason: 'Expected message to be extracted from nested data object',
        );
      });

      test('does not perform any side effects (no logout, no navigation)', () {
        // This test verifies no navigation/logout is triggered.
        // If any side effects existed (like SharedHelper.logout()),
        // this test would fail as we have no mock setup for those dependencies.
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
          ),
          type: DioExceptionType.badResponse,
        );

        // Should not throw, should not call any external methods
        expect(
          () => ApiErrorHandler.getException(dioError),
          returnsNormally,
          reason:
              'ApiErrorHandler.getException should return normally without side-effects',
        );

        final exception = ApiErrorHandler.getException(dioError);
        expect(
          exception.isUnauthorized,
          isTrue,
          reason:
              'Should still correctly identify unauthorized without performing logout',
        );
      });
    });

    group('getMessage (legacy)', () {
      test('returns message string for backwards compatibility', () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
            data: {'message': 'Session expired'},
          ),
          type: DioExceptionType.badResponse,
        );

        final message = await ApiErrorHandler.getMessage(dioError);

        expect(
          message,
          equals('Session expired'),
          reason: 'getMessage should return the message string',
        );
        expect(
          message,
          isA<String>(),
          reason: 'getMessage should return a String type',
        );
      });
    });
  });
}
