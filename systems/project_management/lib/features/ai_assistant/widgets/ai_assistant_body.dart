import 'dart:math' as math;

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/m0_probe/ai_assistant_dev_config.dart';

class AiAssistantBody extends StatefulWidget {
  const AiAssistantBody({
    super.key,
    this.useLocalSlm = false,
    this.inferenceController,
  });

  /// When true, sends use [AiInferenceController] instead of the online
  /// project-query repository. M6-A enables this from Model Selection only.
  final bool useLocalSlm;

  /// Test/development seam; production resolves the controller from DI.
  final AiInferenceController? inferenceController;

  @override
  AiAssistantBodyState createState() => AiAssistantBodyState();
}

class AiAssistantBodyState extends State<AiAssistantBody> {
  static const double _scrollLoadMoreThreshold = 120;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<_ChatEntry> _entries = [];
  bool _isSending = false;

  /// One id per chat session; regenerated on explicit "new chat".
  late String _conversationId;

  /// When true, the next outgoing message sends `reset_context: true` once.
  bool _pendingResetContext = false;

  @override
  void initState() {
    super.initState();
    _conversationId = _newConversationId();
    _scrollController.addListener(_onChatScroll);
  }

  /// Visible for [AiAssistantView] app bar actions.
  void startNewChat() {
    setState(() {
      _entries.clear();
      _conversationId = _newConversationId();
      _pendingResetContext = false;
      _textController.clear();
      _isSending = false;
    });
  }

  /// Next user message will send `reset_context: true` with the current [conversationId].
  void queueResetContextForNextMessage() {
    setState(() => _pendingResetContext = true);
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          allTranslations.text(LocaleKeys.ai_assistant_clear_context_queued),
        ),
      ),
    );
  }

  static String _newConversationId() {
    final r = math.Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return 'chat_${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  String _userVisibleAiError(AiAssistantQueryException e) {
    switch (e.code) {
      case AiAssistantQueryErrorCode.llmRateLimited:
        final secs = e.retryAfterSeconds;
        if (secs != null) {
          return allTranslations
              .text(LocaleKeys.ai_assistant_rate_limited_retry_after)
              .replaceAll('{seconds}', '$secs');
        }
        return allTranslations.text(LocaleKeys.ai_assistant_rate_limited);
      case AiAssistantQueryErrorCode.conversationContextRequired:
        final backend = e.rawSafeMessage?.trim();
        if (backend != null && backend.isNotEmpty) return backend;
        return allTranslations.text(LocaleKeys.ai_assistant_context_required);
      case AiAssistantQueryErrorCode.conversationContextConflict:
      case AiAssistantQueryErrorCode.projectAiPipelineError:
      case AiAssistantQueryErrorCode.llmProviderError:
      case AiAssistantQueryErrorCode.requestTimeout:
      case AiAssistantQueryErrorCode.unknown:
        return allTranslations.text(LocaleKeys.something_went_wrong);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onChatScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChatScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - _scrollLoadMoreThreshold) return;
    _tryLoadMoreForLastResult();
  }

  int? _lastResultEntryIndex() {
    for (var i = _entries.length - 1; i >= 0; i--) {
      if (_entries[i].resultState != null) return i;
    }
    return null;
  }

  Future<void> _tryLoadMoreForLastResult() async {
    final index = _lastResultEntryIndex();
    if (index == null) return;
    await _loadMoreForEntry(index);
  }

  Future<void> _loadMoreForEntry(int entryIndex) async {
    final entry = _entries[entryIndex];
    final state = entry.resultState;
    if (state == null) return;
    if (!state.hasMore || state.isLoadingMore) return;

    final pageToLoad = state.nextPage ?? (state.currentPage + 1);
    if (state.loadedPages.contains(pageToLoad)) return;

    setState(() {
      state.isLoadingMore = true;
      state.loadMoreError = null;
    });

    try {
      final result = await projectManagementSl<AiAssistantRepo>().queryProjects(
        state.originalQuery,
        conversationId: state.conversationId,
        page: pageToLoad,
        pageSize: state.pageSize,
      );
      if (!mounted) return;
      setState(() {
        state.items.addAll(result.items);
        state.currentPage = result.pagination.page;
        state.pageSize = result.pagination.pageSize;
        state.hasMore = result.pagination.hasMore;
        state.nextPage = result.pagination.nextPage;
        state.loadedPages.add(pageToLoad);
        state.isLoadingMore = false;
        state.loadMoreError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        state.isLoadingMore = false;
        state.loadMoreError = allTranslations.text(
          LocaleKeys.ai_assistant_load_more_retry,
        );
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _onSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _entries.add(_ChatEntry.user(text));
      _isSending = true;
      _textController.clear();
    });
    _focusNode.unfocus();
    _scrollToBottom();

    setState(() {
      _entries.add(_ChatEntry.thinking());
    });
    _scrollToBottom();

    final resetOnce = _pendingResetContext;

    if (widget.useLocalSlm) {
      await _sendLocal(text, resetOnce: resetOnce);
      return;
    }

    try {
      final result = await projectManagementSl<AiAssistantRepo>().queryProjects(
        text,
        conversationId: _conversationId,
        resetContext: resetOnce,
        page: 1,
        pageSize: 10,
      );
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _entries.add(
          _ChatEntry.results(
            _AssistantResultState(
              originalQuery: text,
              conversationId: _conversationId,
              result: result,
            ),
          ),
        );
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });
    } on AiAssistantQueryException catch (e) {
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });
      await AppCore.errorToastMessage(_userVisibleAiError(e));
    } on NetworkException catch (e) {
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });

      final msg = (e.isNoConnection || e.isTimeout)
          ? allTranslations.text(LocaleKeys.ai_assistant_host_unreachable)
          : (e.message.trim().isNotEmpty
                ? e.message
                : allTranslations.text(LocaleKeys.something_went_wrong));
      await AppCore.errorToastMessage(msg);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });
      await AppCore.errorToastMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
    }
    _scrollToBottom();
  }

  Future<void> _sendLocal(String text, {required bool resetOnce}) async {
    try {
      final result =
          await (widget.inferenceController ??
                  projectManagementSl<AiInferenceController>())
              .generate(
                text,
                // M0-only: code-level switch (no --dart-define). When
                // useIntentJsonProbe is false (default) this is the normal 001
                // free-text chat. Flip in AiAssistantDevConfig for M0 testing.
                useIntentJsonProbe: AiAssistantDevConfig.useIntentJsonProbe,
                intentProbeDepth: AiAssistantDevConfig.intentProbeDepth,
              );
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _entries.add(_ChatEntry.assistant(_localResultMessage(result)));
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        _entries.add(
          _ChatEntry.assistant(
            'Local AI is unavailable right now. Real offline inference remains pending until model/device setup is complete.',
          ),
        );
        _isSending = false;
        if (resetOnce) _pendingResetContext = false;
      });
    }
    _scrollToBottom();
  }

  String _localResultMessage(AiInferenceResult result) {
    return switch (result) {
      FreeTextResponse(:final text) => text,
      NoActiveModel() =>
        'No active local model is selected. Choose an installed model before offline chat.',
      ModelNotInstalled() =>
        'This model must be downloaded before offline chat can start. Download is not available yet because the model distribution URL/checksum is pending.',
      ModelCorrupt() =>
        'The selected local model looks corrupt or version-mismatched. Repair/redownload will be available after model distribution is ready.',
      ModelLoadFailed() =>
        'Local AI is not available yet. Real offline inference remains pending until model/device setup is complete.',
      GenerationFailed(:final message) =>
        'Local generation failed safely: $message',
      GenerationCancelled() => 'Local generation was cancelled.',
      GenerationTimeout() =>
        'Local generation timed out. Try a shorter question.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: context.color.primary,
              child: _entries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48.sp,
                              color: context.color.onPrimary.withValues(
                                alpha: 0.55,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              allTranslations.text(
                                LocaleKeys.ai_assistant_empty_hint,
                              ),
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.color.onPrimary.withValues(
                                  alpha: 0.88,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return _buildEntry(context, _entries[index], index);
                      },
                    ),
            ),
          ),
        ),
        Container(
          color: context.color.primary,
          padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 8.h,
            bottom: 8.h + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.useLocalSlm)
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Local phase-1 replies are generated text, not live database results.',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.color.onPrimary.withValues(alpha: 0.78),
                      ),
                    ),
                  ),
                ),
              Material(
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(16.r),
                color: context.color.surface,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          minLines: 1,
                          maxLines: 6,
                          textInputAction: TextInputAction.send,
                          enabled: !_isSending,
                          onSubmitted: (_) => _onSend(),
                          cursorColor: context.color.primary,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.color.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: allTranslations.text(
                              LocaleKeys.ai_assistant_input_hint,
                            ),
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                              color: context.color.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSending ? null : _onSend,
                        icon: Icon(
                          Icons.send_rounded,
                          color: _isSending
                              ? context.color.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                )
                              : context.color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Strips trailing `.`, `…`, and ellipsis so animated dots replace them.
  String get _thinkingLabelWithoutTrailingDots {
    final t = allTranslations.text(LocaleKeys.ai_assistant_thinking);
    return t.replaceAll(RegExp(r'(\.\.\.|…|\.)\s*$'), '').trim();
  }

  Widget _buildEntry(BuildContext context, _ChatEntry entry, int entryIndex) {
    if (entry.userText != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w * 0.82),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.r),
                  topEnd: Radius.circular(16.r),
                  bottomStart: Radius.circular(16.r),
                  bottomEnd: Radius.circular(4.r),
                ),
                border: Border.all(
                  color: context.color.onPrimary.withValues(alpha: 0.22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Text(
                  entry.userText!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.color.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (entry.isThinking) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.color.onPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(16.r),
                topEnd: Radius.circular(16.r),
                bottomEnd: Radius.circular(16.r),
                bottomStart: Radius.circular(4.r),
              ),
              border: Border.all(
                color: context.color.onPrimary.withValues(alpha: 0.28),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ThinkingShimmerLabel(
                    label: _thinkingLabelWithoutTrailingDots,
                  ),
                  SizedBox(width: 4.w),
                  _ThinkingDotsAnimated(
                    color: context.color.onPrimary.withValues(alpha: 0.92),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final state = entry.resultState;
    if (entry.assistantText != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w * 0.86),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.r),
                  topEnd: Radius.circular(16.r),
                  bottomEnd: Radius.circular(16.r),
                  bottomStart: Radius.circular(4.r),
                ),
                border: Border.all(
                  color: context.color.onPrimary.withValues(alpha: 0.22),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Text(
                  entry.assistantText!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.color.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (state == null) return const SizedBox.shrink();

    final projects = state.items;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (projects.isEmpty)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: context.color.onPrimary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      allTranslations.text(LocaleKeys.no_projects_match),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.color.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                ...projects.map((p) => AiAssistantProjectResultCard(item: p)),
              if (state.isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.color.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
              if (state.loadMoreError != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: TextButton(
                    onPressed: () => _loadMoreForEntry(entryIndex),
                    child: Text(
                      state.loadMoreError!,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.color.onPrimary.withValues(alpha: 0.92),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pagination + rows for one assistant result message (infinite scroll target).
class _AssistantResultState {
  _AssistantResultState({
    required this.originalQuery,
    required this.conversationId,
    required AiAssistantQueryProjectsResult result,
  }) {
    items.addAll(result.items);
    currentPage = result.pagination.page;
    pageSize = result.pagination.pageSize;
    hasMore = result.pagination.hasMore;
    nextPage = result.pagination.nextPage;
    loadedPages.add(currentPage);
  }

  final String originalQuery;
  final String conversationId;
  final List<AiAssistantQueryItem> items = [];
  int currentPage = 1;
  int pageSize = 10;
  bool hasMore = false;
  bool isLoadingMore = false;
  int? nextPage;
  final Set<int> loadedPages = {};
  String? loadMoreError;
}

class _ChatEntry {
  final String? userText;
  final String? assistantText;
  final bool isThinking;
  final _AssistantResultState? resultState;

  _ChatEntry._({
    this.userText,
    this.assistantText,
    this.isThinking = false,
    this.resultState,
  });

  factory _ChatEntry.user(String text) => _ChatEntry._(userText: text);

  factory _ChatEntry.thinking() => _ChatEntry._(isThinking: true);

  factory _ChatEntry.assistant(String text) =>
      _ChatEntry._(assistantText: text);

  factory _ChatEntry.results(_AssistantResultState state) =>
      _ChatEntry._(resultState: state);
}

/// Shimmer “Thinking” / localized label (without trailing dots; dots are animated separately).
class _ThinkingShimmerLabel extends StatelessWidget {
  const _ThinkingShimmerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey.shade100;
    return CustomShimmer(
      color: base,
      subColor: Colors.grey.shade400,
      child: Text(
        label,
        style: context.textTheme.bodyMedium?.copyWith(
          color: base,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// Three dots that scale up and down in a staggered wave.
class _ThinkingDotsAnimated extends StatefulWidget {
  const _ThinkingDotsAnimated({required this.color});

  final Color color;

  @override
  State<_ThinkingDotsAnimated> createState() => _ThinkingDotsAnimatedState();
}

class _ThinkingDotsAnimatedState extends State<_ThinkingDotsAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium?.copyWith(
      color: widget.color,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) {
            final wave =
                _controller.value * 2 * math.pi + (i * 2 * math.pi / 3);
            final scale = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(wave));
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 1.w),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Text('.', style: style),
              ),
            );
          }),
        );
      },
    );
  }
}
