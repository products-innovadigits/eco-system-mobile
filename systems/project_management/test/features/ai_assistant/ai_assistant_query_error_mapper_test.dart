import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';
import 'package:project_management/features/ai_assistant/util/ai_assistant_query_error_mapper.dart';

void main() {
  group('normalizeAiAssistantJsonMap', () {
    test('parses JSON object string', () {
      final m = normalizeAiAssistantJsonMap(
        '{"success":false,"status":"context_required"}',
      );
      expect(m?['status'], 'context_required');
    });
  });

  group('parseRetryAfterSeconds', () {
    test('parses delta-seconds value', () {
      expect(
        parseRetryAfterSeconds({'retry-after': ['12']}),
        12,
      );
    });

    test('is case-insensitive on header name', () {
      expect(
        parseRetryAfterSeconds({'Retry-After': ['3']}),
        3,
      );
    });
  });

  group('mapBackendFailureEnvelope', () {
    test('detects LLM_RATE_LIMITED from status string', () {
      final ex = mapBackendFailureEnvelope(
        {
          'success': false,
          'status': 'llm_rate_limited',
          'error': {'code': 'LLM_RATE_LIMITED', 'stage': 'planner'},
        },
        httpStatusCode: 200,
        retryAfterSeconds: 9,
      );
      expect(ex, isNotNull);
      expect(ex!.code, AiAssistantQueryErrorCode.llmRateLimited);
      expect(ex.retryAfterSeconds, 9);
    });

    test('detects CONVERSATION_CONTEXT_REQUIRED from error.code', () {
      final ex = mapBackendFailureEnvelope(
        {
          'success': false,
          'error': {'code': 'CONVERSATION_CONTEXT_REQUIRED'},
        },
        httpStatusCode: 200,
        retryAfterSeconds: null,
      );
      expect(ex?.code, AiAssistantQueryErrorCode.conversationContextRequired);
    });
  });

  group('mapNetworkExceptionToAiAssistantQueryException', () {
    test('maps HTTP 429 with structured JSON and Retry-After', () {
      final nex = NetworkException(
        'Rate limit reached',
        statusCode: 429,
        responseData: <String, dynamic>{
          'success': false,
          'status': 'llm_rate_limited',
          'message': 'Rate limit reached',
          'data': <dynamic>[],
          'meta': <String, dynamic>{'row_count': 0},
          'error': <String, dynamic>{
            'code': 'LLM_RATE_LIMITED',
            'stage': 'planner',
            'message': 'Rate limit reached',
          },
        },
        responseHeaders: <String, List<String>>{'retry-after': <String>['12']},
      );
      final ex = mapNetworkExceptionToAiAssistantQueryException(nex);
      expect(ex?.code, AiAssistantQueryErrorCode.llmRateLimited);
      expect(ex?.httpStatusCode, 429);
      expect(ex?.retryAfterSeconds, 12);
    });

    test('maps HTTP 422 context_required body', () {
      final nex = NetworkException(
        'ctx',
        statusCode: 422,
        responseData: <String, dynamic>{
          'success': false,
          'status': 'context_required',
          'error': <String, dynamic>{
            'code': 'CONVERSATION_CONTEXT_REQUIRED',
            'message': 'needs context',
          },
        },
      );
      final ex = mapNetworkExceptionToAiAssistantQueryException(nex);
      expect(ex?.code, AiAssistantQueryErrorCode.conversationContextRequired);
      expect(ex?.httpStatusCode, 422);
    });

    test('falls back to status-only 429 when body missing', () {
      final nex = NetworkException(
        'Too Many Requests',
        statusCode: 429,
        responseHeaders: <String, List<String>>{'retry-after': <String>['5']},
      );
      final ex = mapNetworkExceptionToAiAssistantQueryException(nex);
      expect(ex?.code, AiAssistantQueryErrorCode.llmRateLimited);
      expect(ex?.retryAfterSeconds, 5);
    });
  });
}
