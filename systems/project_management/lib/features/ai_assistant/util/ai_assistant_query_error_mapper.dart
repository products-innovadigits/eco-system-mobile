import 'dart:convert';

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';

/// Normalizes Dio/raw JSON into a map for Project AI envelopes.
Map<String, dynamic>? normalizeAiAssistantJsonMap(dynamic data) {
  if (data == null) return null;
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) {
    try {
      final decoded = jsonDecode(data);
      return normalizeAiAssistantJsonMap(decoded);
    } catch (_) {
      return null;
    }
  }
  return null;
}

/// Parses HTTP [Retry-After] when it is a delta-seconds value (common for 429).
int? parseRetryAfterSeconds(Map<String, List<String>>? headers) {
  if (headers == null) return null;
  for (final e in headers.entries) {
    if (e.key.toLowerCase() != 'retry-after') continue;
    if (e.value.isEmpty) continue;
    final raw = e.value.first.trim();
    final secs = int.tryParse(raw);
    if (secs != null && secs >= 0) return secs;
  }
  return null;
}

String? _readErrorCode(Map<String, dynamic> map) {
  final error = map['error'];
  if (error is Map) {
    final errMap = error is Map<String, dynamic>
        ? error
        : Map<String, dynamic>.from(error);
    final c = errMap['code'];
    if (c is String && c.isNotEmpty) return c;
  }
  return null;
}

String? _readStatus(Map<String, dynamic> map) {
  final s = map['status'];
  return s is String ? s : null;
}

/// Maps a backend failure envelope to a typed [AiAssistantQueryException], or null if unknown.
AiAssistantQueryException? mapBackendFailureEnvelope(
  Map<String, dynamic> map, {
  required int? httpStatusCode,
  int? retryAfterSeconds,
}) {
  final status = _readStatus(map);
  final errorCode = _readErrorCode(map);

  final isRateLimited = httpStatusCode == 429 ||
      status == 'llm_rate_limited' ||
      errorCode == 'LLM_RATE_LIMITED';

  final isContextRequired = httpStatusCode == 422 ||
      status == 'context_required' ||
      errorCode == 'CONVERSATION_CONTEXT_REQUIRED';

  final isContextConflict =
      status == 'context_conflict' || errorCode == 'CONVERSATION_CONTEXT_CONFLICT';

  final isPipeline = errorCode == 'PROJECT_AI_PIPELINE_ERROR';
  final isProvider = errorCode == 'LLM_PROVIDER_ERROR';

  if (isRateLimited) {
    return AiAssistantQueryException(
      'LLM_RATE_LIMITED',
      code: AiAssistantQueryErrorCode.llmRateLimited,
      status: status,
      httpStatusCode: httpStatusCode ?? 429,
      retryAfterSeconds: retryAfterSeconds,
      rawSafeMessage: _shortMessage(map),
    );
  }
  if (isContextRequired) {
    return AiAssistantQueryException(
      'CONVERSATION_CONTEXT_REQUIRED',
      code: AiAssistantQueryErrorCode.conversationContextRequired,
      status: status,
      httpStatusCode: httpStatusCode ?? 422,
      retryAfterSeconds: retryAfterSeconds,
      rawSafeMessage: _shortMessage(map),
    );
  }
  if (isContextConflict) {
    return AiAssistantQueryException(
      'CONVERSATION_CONTEXT_CONFLICT',
      code: AiAssistantQueryErrorCode.conversationContextConflict,
      status: status,
      httpStatusCode: httpStatusCode,
      retryAfterSeconds: retryAfterSeconds,
      rawSafeMessage: _shortMessage(map),
    );
  }
  if (isPipeline) {
    return AiAssistantQueryException(
      'PROJECT_AI_PIPELINE_ERROR',
      code: AiAssistantQueryErrorCode.projectAiPipelineError,
      status: status,
      httpStatusCode: httpStatusCode,
      retryAfterSeconds: retryAfterSeconds,
      rawSafeMessage: _shortMessage(map),
    );
  }
  if (isProvider) {
    return AiAssistantQueryException(
      'LLM_PROVIDER_ERROR',
      code: AiAssistantQueryErrorCode.llmProviderError,
      status: status,
      httpStatusCode: httpStatusCode,
      retryAfterSeconds: retryAfterSeconds,
      rawSafeMessage: _shortMessage(map),
    );
  }

  return null;
}

/// Converts [NetworkException] from `/projects/query` into [AiAssistantQueryException] when possible.
AiAssistantQueryException? mapNetworkExceptionToAiAssistantQueryException(
  NetworkException e,
) {
  final retry = parseRetryAfterSeconds(e.responseHeaders);
  final map = normalizeAiAssistantJsonMap(e.responseData);
  if (map != null) {
    final structured = mapBackendFailureEnvelope(
      map,
      httpStatusCode: e.statusCode,
      retryAfterSeconds: retry,
    );
    if (structured != null) return structured;
  }

  if (e.statusCode == 429) {
    return AiAssistantQueryException(
      'LLM_RATE_LIMITED',
      code: AiAssistantQueryErrorCode.llmRateLimited,
      httpStatusCode: 429,
      retryAfterSeconds: retry,
    );
  }
  if (e.statusCode == 422) {
    return AiAssistantQueryException(
      'CONVERSATION_CONTEXT_REQUIRED',
      code: AiAssistantQueryErrorCode.conversationContextRequired,
      httpStatusCode: 422,
      retryAfterSeconds: retry,
    );
  }

  return null;
}

String? _shortMessage(Map<String, dynamic> map) {
  final message = map['message'];
  if (message is String && message.trim().isNotEmpty) {
    return _truncate(message.trim(), 400);
  }
  final error = map['error'];
  if (error is Map) {
    final em = error is Map<String, dynamic>
        ? error
        : Map<String, dynamic>.from(error);
    final m = em['message'];
    if (m is String && m.trim().isNotEmpty) return _truncate(m.trim(), 400);
  }
  return null;
}

String _truncate(String s, int max) {
  if (s.length <= max) return s;
  return '${s.substring(0, max)}…';
}
