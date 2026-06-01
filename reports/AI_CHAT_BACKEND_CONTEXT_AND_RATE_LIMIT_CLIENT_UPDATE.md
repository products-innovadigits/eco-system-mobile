# AI Chat — backend context & rate limit — client update

## 1. Agreement with plan

The plan matches how the app is structured today: `AiAssistantRepoImpl` uses `Network.requestOrThrow`, which converted non-2xx responses into `NetworkException` **without** preserving structured JSON for callers. Adjusting `NetworkException` / `ApiErrorHandler` plus a small Project AI–specific mapper is the smallest safe fix. One deliberate tweak: **release builds** omit verbose AI response logs entirely (not only truncation), in addition to truncating non-release logs.

## 2. Files changed

| Area | Files |
|------|--------|
| Network errors | `systems/core_system/lib/core/network/error/network_exception.dart`, `systems/core_system/lib/core/network/error/api_error_handler.dart` |
| Logging | `systems/core_system/lib/core/network/network_logger.dart` |
| AI Assistant domain/data | `systems/project_management/lib/features/ai_assistant/domain/repositories/ai_assistant_repo.dart`, `systems/project_management/lib/features/ai_assistant/data/repositories/ai_assistant_repo_impl.dart` |
| Exceptions / mapper | `systems/project_management/lib/features/ai_assistant/exceptions/ai_assistant_query_exception.dart`, `systems/project_management/lib/features/ai_assistant/util/ai_assistant_query_error_mapper.dart` |
| UI | `systems/project_management/lib/features/ai_assistant/view/ai_assistant_view.dart`, `systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_body.dart` |
| Localization | `assets/langs/en.json`, `assets/langs/ar.json`, `systems/core_system/lib/core/core/app_strings/locale_keys.dart` |
| Tests | `systems/project_management/test/features/ai_assistant/ai_assistant_query_error_mapper_test.dart` |

## 3. What was already correct before this task

- `conversation_id` sent as snake_case JSON from `AiAssistantRepoImpl`.
- `queryProjects(String query, {required String conversationId})` requiring an id at the API boundary.
- Flexible `_parseQueryProjectsResult` (list / `data` / `items` / `projects` / `results` / single-row maps).
- Chat UI scoped `conversationId` to the assistant screen widget lifetime and reused it for every send **within that session** (but id format was not UUID v4; see limitations).

## 4. Where `conversation_id` is generated

- **`AiAssistantBodyState._newConversationId()`** in `widgets/ai_assistant_body.dart`: RFC 4122-style UUID v4 bytes formatted as `chat_<uuid-with-dashes>`.
- Regenerated when the user taps **New chat** in the assistant AppBar (`AiAssistantView` → `startNewChat()`).

## 5. How the same `conversation_id` is reused

- Stored in **`AiAssistantBodyState._conversationId`** and passed unchanged into **`queryProjects(..., conversationId: _conversationId)`** for every message until **New chat** replaces it.

## 6. How `reset_context` is sent

- Repository: optional **`resetContext`** (default `false`) adds **`'reset_context': resetContext`** to the POST JSON body.
- UI: AppBar **“Clear saved context (next message)”** sets **`_pendingResetContext`**; the **next** send passes **`resetContext: true`**, then clears the flag (whether success or failure).

## 7. How `debug` is controlled

- **`AiAssistantRepoImpl`**: `debug` is **`true` when `!kReleaseMode`** (debug/profile), **`false` in release**.

## 8. `LLM_RATE_LIMITED` parsing and UI

- **Detection**: HTTP **429**, or `status == "llm_rate_limited"`, or `error.code == "LLM_RATE_LIMITED"` (also on HTTP 200 failure envelopes via `_throwIfQueryFailed`).
- **Exception**: `AiAssistantQueryException` with `code: llmRateLimited`, `httpStatusCode`, optional `retryAfterSeconds`.
- **UI**: localized strings `ai_assistant_rate_limited` / `ai_assistant_rate_limited_retry_after` (placeholder `{seconds}`).

## 9. `Retry-After` parsing

- **`parseRetryAfterSeconds`** reads header map keys case-insensitively and parses integer delta-seconds (HTTP-date form not implemented).

## 10. `CONVERSATION_CONTEXT_REQUIRED` parsing and UI

- **Detection**: HTTP **422**, or `status == "context_required"`, or `error.code == "CONVERSATION_CONTEXT_REQUIRED"` (and HTTP 200 failure envelopes when applicable).
- **UI**: `ai_assistant_context_required`.

## 11. Logging masking / verbosity

- **Request**: `Authorization` logged as `Bearer <8-char-prefix>...<masked>`; common API-key header names masked.
- **Response**: full JSON pretty-print skipped in **release** (`<omitted in release build>`); non-release truncates at ~8000 chars.
- **AI repo**: response logging skipped in release; non-release truncates at ~6000 chars.

## 12. Test results

Executed:

```bash
cd systems/project_management && flutter test test/features/ai_assistant/ai_assistant_query_error_mapper_test.dart
```

**Result:** All **8** tests passed.

**Static analysis:**

```bash
cd systems/core_system && dart analyze lib/core/network
cd systems/project_management && dart analyze lib/features/ai_assistant
```

**Result:** No issues found.

## 13. Remaining limitations

- **`Retry-After` HTTP-date** values are not parsed (only integer seconds).
- **Staging flavor**: no separate staging flavor flag; profile builds behave like debug for `debug: true` / verbose logs (`!kReleaseMode`).
- **Automated tests** do not assert full HTTP request bodies against a live tunnel (manual/device verification still applies).
- **`deepHealth()`** is added on `AiAssistantRepo` but **no UI** calls it yet.
