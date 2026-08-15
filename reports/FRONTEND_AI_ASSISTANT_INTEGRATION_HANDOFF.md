# Front-end AI Assistant integration handoff

Generated from the current mobile workspace on **2026-07-13**. This document is intended to be given directly to an agent that has access to the front-end project.

## 1. Scope and source-of-truth warning

The mobile app has two relevant backends:

1. The normal Project Management API for login and project details.
2. A separate Project AI API for natural-language project queries.

Do not combine their paths under one base URL.

The AI repository has an **uncommitted local override** to a temporary Cloudflare tunnel. The committed code identifies the `sslip.io` URL as production. The tunnel URL can rotate and must not be shipped as a permanent production value.

## 2. Base URLs

| Purpose | Recommended environment variable | Value seen in mobile | Notes |
|---|---|---|---|
| Project Management API | `PROJECT_API_BASE_URL` | `https://194.163.168.5:447/api/` | Used for login, projects, and project details. Must end in `/` if paths are concatenated like mobile. |
| Project AI production API | `PROJECT_AI_BASE_URL` | `https://188-166-44-162.sslip.io/` | Committed mobile production value. Full query URL is `https://188-166-44-162.sslip.io/projects/query`. |
| Project AI temporary tunnel | development override only | `https://prefers-duties-shots-civil.trycloudflare.com/` | Current uncommitted mobile override. Temporary; do not hardcode for production. |
| ATS API | `ATS_API_BASE_URL` | `https://ats.innoeg.com/api/v1/` | Outside the AI assistant scope. |
| PMS API | `PMS_API_BASE_URL` | `https://pms-dev.nawahtech.com/api/v2/` | Outside the Project Management assistant scope. |
| Strategy API | `STRATEGY_API_BASE_URL` | `https://194.163.168.5:447/api/` | Currently the same host as Project Management. |

Suggested front-end environment file:

```dotenv
PROJECT_API_BASE_URL=https://194.163.168.5:447/api/
PROJECT_AI_BASE_URL=https://188-166-44-162.sslip.io/
```

Use the framework's public/server naming rules, for example `VITE_...`, `NEXT_PUBLIC_...`, or server-only variables as appropriate. Prefer a same-origin server route for authenticated calls rather than exposing more configuration than the browser needs.

### Critical browser TLS issue

The Project Management API currently presents a **self-signed certificate** (`curl` verification result 18). Mobile hides this because its Dio client accepts all bad certificates. Browser JavaScript cannot safely reproduce that behavior.

Before a browser front end directly calls the Project Management API, one of these must happen:

- install a valid certificate on a trusted hostname; or
- route calls through the front end's server/BFF/reverse proxy, where the upstream is controlled and secured.

Do not disable TLS verification in production. The Project Management server did return permissive CORS headers during an insecure diagnostic preflight, so the certificate—not CORS—is the immediate browser blocker.

The Project AI production URL has trusted HTTPS and its preflight currently allows `authorization`, `content-type`, and `lang`, with `Access-Control-Allow-Origin: *`.

## 3. Authentication and common headers

### Project Management login

```http
POST {PROJECT_API_BASE_URL}Auth/Login
Content-Type: application/json
Accept: application/json
Lang: en | ar
```

```json
{
  "login": "<username>",
  "password": "<password>"
}
```

On a successful Project Management login, mobile reads the user object from:

```text
response.data.data
```

The access-token field is misspelled by this backend and mobile model as:

```text
data.tokken
```

It is not `data.token` for the Project Management flow. PMS uses `data.token`, which is a different flow.

### Authenticated request headers

Mobile sends these headers to both the Project Management and Project AI endpoints:

```http
Authorization: Bearer <access token>
Accept: application/json
Content-Type: application/json
Lang: en | ar
```

Mobile also sends `User-Agent: Dart`; browser code should not try to set that forbidden header.

The AI query endpoint accepted an anonymous contract probe on 2026-07-13, but the front end should **not rely on anonymous access**. Send the logged-in user's bearer token like mobile so future authorization and per-user query scoping do not break the client.

On HTTP `401`, clear the complete front-end session/token state and navigate to login. Do not copy the mobile detail that merely navigates away while its secure token may remain stored.

## 4. AI query endpoint

```http
POST {PROJECT_AI_BASE_URL}projects/query
```

There is no SSE/WebSocket streaming in the mobile implementation. Each user message is one JSON request followed by one JSON response.

### Request body

```json
{
  "conversation_id": "chat_550e8400-e29b-41d4-a716-446655440000",
  "query": "Show projects with high risk",
  "debug": false,
  "reset_context": false,
  "page": 1,
  "page_size": 5
}
```

| Field | Type | Required | Mobile behavior |
|---|---|---|---|
| `conversation_id` | string | yes | Generated by the client and reused across turns in one chat. |
| `query` | string | yes | Trimmed natural-language question. May be Arabic or English. |
| `debug` | boolean | yes in mobile | `false` in release. Never expose debug/provider details in production. |
| `reset_context` | boolean | yes in mobile | Normally `false`; set to `true` once on the next message after the user chooses clear context. |
| `page` | positive integer | yes | API pages are 1-based. |
| `page_size` | positive integer | yes | Mobile uses 5 inline and 100 in the all-results view. |

### Conversation lifecycle

- Create one UUID v4 when the assistant screen/chat session starts.
- Mobile prefixes it with `chat_`, for example `chat_<uuid>`.
- Reuse the same ID for every user turn and for clarification-suggestion clicks in that chat.
- “New chat” clears client-side messages and creates a new conversation ID.
- “Clear saved context” does not call a separate endpoint. It queues `reset_context: true` for exactly the next query using the current conversation ID, then returns to `false` whether the request succeeds or fails.
- Do not create a new conversation ID for every message; follow-up questions depend on the prior ID.
- Current deep-health data reports an in-memory conversation TTL of 1,800 seconds and a maximum of 100 project IDs. Treat these as server configuration, not a permanent public contract.

For the dedicated all-results pager, mobile creates a separate `pager_<uuid>` conversation, repeats the original query, and fetches page 1 again. This isolates result pagination from the conversational follow-up context.

## 5. Canonical success response

A sanitized version of the production response shape verified on 2026-07-13:

```json
{
  "success": true,
  "status": "success",
  "message": "Query executed successfully.",
  "data": [
    {
      "projects_id": 21,
      "projects_name": "Example project"
    }
  ],
  "meta": {
    "row_count": 1,
    "columns": ["projects_id", "projects_name"],
    "root_table": "Projects",
    "referenced_tables": ["Projects"],
    "limit_applied": 6,
    "result_type": "results",
    "pagination": {
      "page": 1,
      "page_size": 5,
      "has_more": true,
      "next_page": 2
    }
  },
  "error": null,
  "clarification": null,
  "suggestions": null,
  "debug": null
}
```

`data` rows are dynamic. Do not define one rigid project-card DTO; the selected columns change with the question.

Suggested TypeScript contracts:

```ts
export type AiResultType =
  | 'results'
  | 'empty'
  | 'clarification'
  | 'error'
  | string;

export interface AiSuggestion {
  id: string;
  label: string;
  question: string;
}

export interface AiPagination {
  page: number;
  page_size: number;
  has_more: boolean;
  next_page: number | null;
}

export interface AiMeta {
  row_count?: number;
  columns?: string[];
  root_table?: string;
  referenced_tables?: string[];
  limit_applied?: number;
  result_type?: AiResultType;
  pagination?: AiPagination;
  [key: string]: unknown;
}

export interface AiErrorBody {
  code?: string;
  stage?: string;
  message?: string;
  [key: string]: unknown;
}

export interface AiQueryResponse {
  success?: boolean;
  status?: string;
  message?: string | null;
  data?: Array<Record<string, unknown>>;
  meta?: AiMeta;
  error?: AiErrorBody | string | null;
  clarification?: {
    message?: string;
    suggestions?: AiSuggestion[];
    [key: string]: unknown;
  } | null;
  suggestions?: AiSuggestion[] | null;
  debug?: unknown;
}
```

## 6. Result modes

Use `meta.result_type` as the primary UI discriminator.

### `results`

- Render the dynamic rows in `data`.
- Use `meta.columns` as the display order, followed by any additional row keys not listed there.
- Drop fields whose value is `null`.
- Convert strings directly; stringify numbers/booleans; use `JSON.stringify` for arrays/objects.
- Hide `id` and every key ending in `_id` from the visible card.
- Still read `projects_id`, falling back to `id`, as the numeric project ID for navigation.
- If a usable project ID exists, the card can navigate to the project-details route.

### `clarification`

Treat clarification as an interactive assistant response, not an error and not an empty result.

- Message priority: `clarification.message`, then top-level `message`.
- Suggestions priority: `clarification.suggestions`, then top-level `suggestions`.
- A usable suggestion must contain a non-empty `question`.
- Display `label`, falling back to `question` if the label is empty.
- Clicking a suggestion sends its exact `question` as the next user turn with the same chat `conversation_id`.
- Disable suggestions while a request is in progress.

Example normalized shape:

```json
{
  "success": true,
  "status": "success",
  "data": [],
  "meta": {
    "result_type": "clarification"
  },
  "clarification": {
    "message": "Which project group do you mean?",
    "suggestions": [
      {
        "id": "active",
        "label": "Active projects",
        "question": "Show active projects"
      }
    ]
  }
}
```

### `empty`

- Render a no-results state, not an exception.
- The domain model can carry suggestions for empty results, but the current mobile UI only renders suggestion cards for `clarification`. Match that behavior for strict parity, or deliberately improve it in the web UX.

### Compatibility parsing

The mobile parser is intentionally tolerant. In addition to the canonical envelope, it accepts:

- a top-level list;
- lists under `data`, `items`, `projects`, or `results`;
- a single object containing `id` or `projects_id`.

Implementing this fallback is useful during backend transitions, but keep the canonical envelope strongly typed and observable so contract regressions are not hidden.

## 7. AI pagination

The assistant pagination is different from the normal Project Management list pagination.

### Inline chat

- Request `page: 1`, `page_size: 5`.
- Render at most five cards in the chat response.
- Show “View more” when `meta.pagination.has_more` is true.

### All-results screen

- Create a separate `pager_<uuid>` conversation ID.
- Repeat the original natural-language query.
- Refetch `page: 1`, `page_size: 100`; replace the initial five preview rows with this response.
- When close to the bottom, request the exact `next_page` returned by the server and append rows.
- Stop when `has_more` is false or `next_page` is null.
- Prevent overlapping page requests.
- If loading a later page fails, retain already loaded rows and expose a retry action for the failed page.
- Mobile triggers load-more when approximately 300 px remain below the viewport.
- Mobile's search box filters only the rows loaded so far, case-insensitively across every stringified field value. It does not send a server search parameter.

Do not infer the next page only from the number of returned rows. Prefer the explicit `has_more` and `next_page` fields.

## 8. Errors and retry behavior

The server may return either a non-2xx response or an HTTP 200 failure envelope. Always inspect both the HTTP status and the JSON body.

A JSON envelope is a failure when:

- `success` exists and is `false`; or
- `status` exists and is not `success` (case-insensitive).

Known mappings:

| HTTP/body signal | Client meaning | UI behavior |
|---|---|---|
| HTTP `401` | Unauthorized | Clear session and go to login. |
| HTTP `429`, `status: llm_rate_limited`, or `error.code: LLM_RATE_LIMITED` | AI provider rate limited | Show a busy/rate-limit message. Read `Retry-After` when present. |
| HTTP `422`, `status: context_required`, or `error.code: CONVERSATION_CONTEXT_REQUIRED` | Follow-up has no stored conversation context | Ask the user to start with a clear standalone question. |
| `status: context_conflict` or `error.code: CONVERSATION_CONTEXT_CONFLICT` | Stored context conflicts with the request | Show a generic safe error; optionally offer new chat/reset context. |
| `error.code: PROJECT_AI_PIPELINE_ERROR` | Project AI pipeline failure | Generic safe error; log a short diagnostic. |
| `error.code: LLM_PROVIDER_ERROR` | Provider failure | Generic safe error; do not expose raw provider details. |
| Timeout/network failure | Host unavailable or request timed out | Preserve chat and offer retry. |

`Retry-After` support in mobile only parses integer delta-seconds. Supporting the HTTP-date form on web would be a safe improvement.

Do not blindly auto-retry natural-language POST requests. If retry is offered, reuse the same request payload and conversation ID and ensure the UI cannot submit duplicates concurrently.

The backend deep-health response currently reports a request timeout of 120 seconds. Mobile sets only a 40-second **connection** timeout and has no shorter receive timeout. A front end should allow roughly 125–130 seconds for the response, while still allowing user cancellation through `AbortController` or the framework equivalent.

## 9. Adjacent Project Management endpoints

These are useful for login, navigating from an AI result, and matching the mobile project flow.

| Purpose | Method and path |
|---|---|
| Login | `POST {PROJECT_API_BASE_URL}Auth/Login` |
| Filtered project list | `POST {PROJECT_API_BASE_URL}Project/GetFilteredProjects` |
| Project details | `GET {PROJECT_API_BASE_URL}Project/{id}` |
| Project progress summary | `GET {PROJECT_API_BASE_URL}Project/{id}/progress-summary?type=monthly|yearly` |
| Project timeline | `GET {PROJECT_API_BASE_URL}ProjectTimeLine/GetAllActivitiesByProjectId/{id}` |
| Project report | `GET {PROJECT_API_BASE_URL}Project/mobile-report/{id}` |

Normal project-list pagination uses query parameters on the POST request:

```text
pageIndex=1&pageSize=10&searchKeyword=...
```

Its response pagination lives under the normal API's `data` object and uses fields such as:

```text
data.items
data.currentPage
data.pageSize
data.totalPages
data.totalCount
data.isLastPage
```

The API is 1-based. Mobile stores a 0-based page internally and converts before requests; a web front end can stay 1-based end-to-end to reduce complexity.

Important implementation caveat: although mobile defines several subsystem base URLs and passes a `systemTypeEnum`, the shared network layer currently does not use that enum to select a base URL. Requests without an explicit base URL go to `https://194.163.168.5:447/api/`. The AI repository is correct because it passes its AI base URL explicitly. Do not copy the unused enum behavior into the front end.

## 10. Field labels and localization

Mobile supports English and Arabic and sends the active language in `Lang`.

Dynamic result fields are translated using this key convention:

```text
ai_query_field_<raw_backend_key>
```

Examples:

| Backend key | English | Arabic |
|---|---|---|
| `projects_name` | Project name | اسم المشروع |
| `projects_budget` | Budget | الميزانية |
| `projects_progress` | Progress | نسبة الإنجاز |
| `projects_startdate` | Start date | تاريخ البدء |
| `projects_enddate` | End date | تاريخ الانتهاء |
| `projects_outputcount` | Outputs count | عدد المخرجات |
| `risklevels_name` | Risk level | درجة الخطورة |
| `meetings_title` | Meeting title | عنوان الاجتماع |
| `meetings_description` | Meeting description | وصف الاجتماع |
| `aspnetusers_fullname` | Full name | الاسم الكامل |
| `implementordepartments_name` | Implementing department | الجهة المنفّذة |
| `projectcategories_name` | Project category | تصنيف المشروع |
| `projectoutputmodels_title` | Output title | عنوان المخرج |
| `count_value` | Count | العدد |
| `sum_value` | Sum | المجموع |
| `avg_value` | Average | المتوسط |
| `min_value` | Minimum | القيمة الدنيا |
| `max_value` | Maximum | القيمة القصوى |

For an unknown key, split on `_`, title-case the segments, and join with spaces. The complete current mapping is in the mobile translation files referenced at the end of this document.

The UI must support RTL layout for Arabic. Use logical `start`/`end` alignment rather than fixed left/right positioning.

## 11. Front-end state model

A practical state shape:

```ts
type ChatEntry =
  | { type: 'user'; text: string }
  | { type: 'thinking' }
  | {
      type: 'results';
      query: string;
      rows: Array<Record<string, unknown>>;
      columns: string[];
      hasMore: boolean;
    }
  | {
      type: 'clarification';
      message: string;
      suggestions: AiSuggestion[];
    }
  | { type: 'empty'; message?: string };

interface AssistantSessionState {
  conversationId: string;
  entries: ChatEntry[];
  isSending: boolean;
  resetContextOnNextMessage: boolean;
}
```

Mobile keeps chat entries only in widget memory. It does not restore chat history after leaving/restarting the screen. Persisting front-end chat is a product decision, not required for parity. If persisted, do not assume the backend conversation context survives longer than its TTL.

## 12. Security and observability

- Keep `debug: false` in production.
- Never log bearer tokens, full authorization headers, credentials, or complete production AI responses.
- AI rows can contain project, employee, phone, and email data; treat responses as sensitive.
- Mask the authorization value if request logging is enabled.
- Truncate structured response logs in development.
- Show safe localized messages to users; retain only short backend diagnostics for internal logging.
- Do not expose a raw provider error or stack trace.
- Do not reproduce the mobile certificate bypass.
- The AI endpoint currently accepted an unauthenticated request; this should be reviewed server-side before public deployment. A browser client cannot enforce backend authorization.

## 13. Health endpoint

Diagnostics only:

```http
GET {PROJECT_AI_BASE_URL}health/deep
```

Do not call it in the normal message flow. Both the production AI URL and the temporary tunnel returned HTTP 200 with top-level `success: true` and `status: healthy` on 2026-07-13. Some nested diagnostic checks can still report errors even when the top-level health is 200, so preserve the full structured health response for an admin/diagnostic view instead of reducing it to the status code.

## 14. Recommended implementation order

1. Add environment-specific Project API and Project AI base URLs.
2. Resolve the Project API trusted-certificate/proxy requirement before browser integration.
3. Reuse the existing front-end auth session and add the common bearer/language headers.
4. Implement a dedicated AI API client with a 1-based pager and typed failure mapper.
5. Implement chat-session conversation IDs, new chat, and one-shot reset context.
6. Render results, clarification suggestions, empty state, and safe errors as distinct states.
7. Add the all-results pager using the original query and a separate pager conversation ID.
8. Add project-card navigation by `projects_id`/`id`.
9. Add English/Arabic labels and RTL behavior.
10. Test response-envelope failures, 401, 422, 429 plus `Retry-After`, timeouts, pagination retry, and dynamic columns.

## 15. Acceptance checklist

- [ ] No API base URL is hardcoded in components.
- [ ] Production uses the stable AI URL or an approved replacement, never the quick tunnel.
- [ ] Project API browser TLS is fixed or proxied without disabling verification.
- [ ] Every message in a chat reuses the same conversation ID.
- [ ] New chat creates a new ID.
- [ ] Reset context is sent exactly once on the next turn.
- [ ] Suggestion clicks send `suggestion.question`, not the display label.
- [ ] API page numbering starts at 1.
- [ ] Inline chat requests five results.
- [ ] All-results uses `has_more` and `next_page` and blocks overlapping requests.
- [ ] Dynamic columns follow `meta.columns`.
- [ ] ID fields are hidden but still used for project navigation.
- [ ] Clarification, empty, and error are separate UI states.
- [ ] HTTP 200 failure envelopes are not treated as success.
- [ ] `429` and integer `Retry-After` are handled.
- [ ] `422` context-required is handled.
- [ ] `401` clears the whole session.
- [ ] Production sends `debug: false` and does not log sensitive responses.
- [ ] English, Arabic, and RTL layouts work.

## 16. Copy-paste task for the front-end agent

```text
Implement the Project Management AI Assistant in this front-end using the attached integration handoff as the source of truth.

First inspect the existing front-end architecture, authentication/session handling, API client, environment conventions, router, localization, state-management approach, and component library. Reuse those patterns rather than introducing a parallel framework.

Create a dedicated Project AI client for POST /projects/query. Keep the normal Project Management API and Project AI API as separate environment-configured origins. Reuse the logged-in bearer token and active en/ar language header. Do not hardcode the temporary trycloudflare URL and do not disable TLS verification; if direct browser calls to the Project API are required, use the project's server/BFF proxy until the upstream has a trusted certificate.

Match the mobile behavior: one UUID-v4 conversation ID per chat, same ID for follow-ups and clarification suggestions, a new ID for New chat, one-shot reset_context on the next message, page 1/page_size 5 inline, dynamic result cards ordered by meta.columns, hidden id/*_id display fields, project navigation from projects_id or id, distinct clarification/empty/error states, and a separate all-results pager that refetches the original query with page_size 100 and follows has_more/next_page.

Handle both non-2xx errors and HTTP-200 failure envelopes. Map 401, 422/CONVERSATION_CONTEXT_REQUIRED, 429/LLM_RATE_LIMITED with Retry-After, context conflict, pipeline/provider errors, timeout, and network errors to safe localized UI. Keep debug false and avoid logging tokens or full sensitive response data in production.

Add focused tests for request payloads, conversation lifecycle, one-shot reset, dynamic result normalization, clarification suggestion behavior, pagination append/retry/end, 200 failure envelopes, 401, 422, 429, and RTL rendering. Run the repository's formatter, type-checker/linter, and relevant tests. Report changed files, assumptions, and any remaining blocker—especially TLS/proxy or missing route details.
```

## 17. Mobile source references

- `systems/project_management/lib/features/ai_assistant/data/repositories/ai_assistant_repo_impl.dart`
- `systems/project_management/lib/features/ai_assistant/domain/repositories/ai_assistant_repo.dart`
- `systems/project_management/lib/features/ai_assistant/model/ai_assistant_models.dart`
- `systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_body.dart`
- `systems/project_management/lib/features/ai_assistant/view/ai_assistant_all_results_view.dart`
- `systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_project_result_card.dart`
- `systems/project_management/lib/features/ai_assistant/util/ai_assistant_query_error_mapper.dart`
- `systems/core_system/lib/core/network/network_layer.dart`
- `systems/core_system/lib/core/network/error/api_error_handler.dart`
- `systems/core_system/lib/core/config/api_names.dart`
- `systems/core_system/lib/core/config/app_config.dart`
- `lib/features/auth/login/repo/login_repo.dart`
- `lib/features/auth/login/bloc/login_bloc.dart`
- `assets/langs/en.json`
- `assets/langs/ar.json`

