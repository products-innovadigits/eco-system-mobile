import 'dart:math' as math;

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';

class AiAssistantBody extends StatefulWidget {
  const AiAssistantBody({super.key});

  @override
  AiAssistantBodyState createState() => AiAssistantBodyState();
}

class AiAssistantBodyState extends State<AiAssistantBody> {
  /// Max result cards shown inline in a chat bubble; more → a "View more" button
  /// that opens the full list on [AiAssistantAllResultsView].
  static const int _maxChatResults = 5;

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
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
    _textController.clear();
    await _submitText(text);
  }

  /// Sends [rawText] as a user turn. Reused by the input field and by tapping a
  /// clarification suggestion chip (which re-sends its `question`).
  Future<void> _submitText(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _entries.add(_ChatEntry.user(text));
      _isSending = true;
    });
    _focusNode.unfocus();
    _scrollToBottom();

    setState(() {
      _entries.add(_ChatEntry.thinking());
    });
    _scrollToBottom();

    final resetOnce = _pendingResetContext;

    try {
      final result = await projectManagementSl<AiAssistantRepo>().queryProjects(
        text,
        conversationId: _conversationId,
        resetContext: resetOnce,
        page: 1,
        pageSize: _maxChatResults,
      );
      if (!mounted) return;
      setState(() {
        if (_entries.isNotEmpty && _entries.last.isThinking) {
          _entries.removeLast();
        }
        // Clarification is a distinct, interactive state — not results, not a
        // failure. Empty results still fall through to the projects entry.
        if (result.isClarification) {
          _entries.add(
            _ChatEntry.clarification(
              message: result.message,
              suggestions: result.suggestions,
            ),
          );
        } else {
          _entries.add(
            _ChatEntry.projects(
              result.items,
              query: text,
              hasMore: result.hasMore,
            ),
          );
        }
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

      /// If the API server is unreachable (down/restarting/network), Dio surfaces
      /// that as connectionError / unknown, i.e. "No internet connection", which misleads users.
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

  void _onSuggestionTap(AiAssistantSuggestion suggestion) {
    if (_isSending) return;
    _submitText(suggestion.question);
  }

  /// Assistant-aligned clarification bubble: a message + a 2-column grid of
  /// clickable suggestion cards. Tapping a card re-sends its question.
  Widget _buildClarificationEntry(BuildContext context, _ChatEntry entry) {
    final suggestions = entry.suggestions ?? const <AiAssistantSuggestion>[];
    final message = (entry.clarificationMessage?.trim().isNotEmpty ?? false)
        ? entry.clarificationMessage!.trim()
        : allTranslations.text(LocaleKeys.ai_assistant_empty_hint);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 20.sp,
                        color: context.color.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          message,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.color.onSurface,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (suggestions.isNotEmpty) ...[
                SizedBox(height: 10.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    mainAxisExtent: 64.h,
                  ),
                  itemBuilder: (context, index) {
                    return AiAssistantSuggestionCard(
                      suggestion: suggestions[index],
                      enabled: !_isSending,
                      onTap: _onSuggestionTap,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
                        return _buildEntry(context, _entries[index]);
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
          child: Material(
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
        ),
      ],
    );
  }

  /// Strips trailing `.`, `…`, and ellipsis so animated dots replace them.
  String get _thinkingLabelWithoutTrailingDots {
    final t = allTranslations.text(LocaleKeys.ai_assistant_thinking);
    return t.replaceAll(RegExp(r'(\.\.\.|…|\.)\s*$'), '').trim();
  }

  Widget _buildEntry(BuildContext context, _ChatEntry entry) {
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
                  // Logo loading (rotating app icon) — disabled in favor of shimmer + dots.
                  // _ThinkingRotatingAppIcon(size: 22.w),
                  // SizedBox(width: 10.w),
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

    if (entry.isClarification) {
      return _buildClarificationEntry(context, entry);
    }

    final projects = entry.projects ?? [];
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
              else ...[
                ...projects
                    .take(_maxChatResults)
                    .map((p) => AiAssistantProjectResultCard(item: p)),
                if (entry.hasMore || projects.length > _maxChatResults)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => CustomNavigator.push(
                              Routes.AI_ASSISTANT_ALL_RESULTS,
                              arguments: AiAssistantAllResultsArgs(
                                items: projects,
                                query: entry.query!,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  allTranslations.text(
                                    LocaleKeys.ai_assistant_view_more,
                                  ),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.color.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20.sp,
                                  color: context.color.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatEntry {
  final String? userText;
  final bool isThinking;
  final List<AiAssistantQueryItem>? projects;

  /// Clarification turn: a message asking the user to clarify, plus clickable
  /// suggestion chips. Distinct from an empty-results or failure entry.
  final bool isClarification;
  final String? clarificationMessage;
  final List<AiAssistantSuggestion>? suggestions;

  /// Original question for this results entry — forwarded to the "All results"
  /// screen (its title) when the user taps "View more".
  final String? query;

  /// Whether the server reports another page for this result turn.
  final bool hasMore;

  _ChatEntry._({
    this.userText,
    this.isThinking = false,
    this.projects,
    this.isClarification = false,
    this.clarificationMessage,
    this.suggestions,
    this.query,
    this.hasMore = false,
  });

  factory _ChatEntry.user(String text) => _ChatEntry._(userText: text);

  factory _ChatEntry.thinking() => _ChatEntry._(isThinking: true);

  factory _ChatEntry.projects(
    List<AiAssistantQueryItem> list, {
    required String query,
    required bool hasMore,
  }) => _ChatEntry._(projects: list, query: query, hasMore: hasMore);

  factory _ChatEntry.clarification({
    String? message,
    required List<AiAssistantSuggestion> suggestions,
  }) => _ChatEntry._(
    isClarification: true,
    clarificationMessage: message,
    suggestions: suggestions,
  );
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

// App logo spinning while the assistant request is in flight (optional; currently unused).
// class _ThinkingRotatingAppIcon extends StatefulWidget {
//   const _ThinkingRotatingAppIcon({required this.size});
//
//   final double size;
//
//   @override
//   State<_ThinkingRotatingAppIcon> createState() =>
//       _ThinkingRotatingAppIconState();
// }
//
// class _ThinkingRotatingAppIconState extends State<_ThinkingRotatingAppIcon>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _rotation;
//
//   @override
//   void initState() {
//     super.initState();
//     _rotation = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _rotation.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.size,
//       height: widget.size,
//       child: RotationTransition(
//         turns: _rotation,
//         child: Assets.appIconPng.image(
//           width: widget.size,
//           height: widget.size,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }
