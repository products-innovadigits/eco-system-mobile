import 'dart:math' as math;

import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

/// Navigation payload for [AiAssistantAllResultsView].
///
/// [items] renders immediately while the pager refetches page one. [query] is
/// the original user question and is repeated for every isolated pager request.
class AiAssistantAllResultsArgs {
  const AiAssistantAllResultsArgs({required this.items, required this.query});

  final List<AiAssistantQueryItem> items;
  final String query;
}

/// Paginated results for one AI Assistant answer, with local filtering over all
/// rows loaded so far.
class AiAssistantAllResultsView extends StatefulWidget {
  const AiAssistantAllResultsView({super.key, required this.args});

  final AiAssistantAllResultsArgs args;

  @override
  State<AiAssistantAllResultsView> createState() =>
      _AiAssistantAllResultsViewState();
}

class _AiAssistantAllResultsViewState extends State<AiAssistantAllResultsView> {
  static const int _pageSize = 100;
  static const double _loadMoreThreshold = 300;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _conversationId;
  late List<AiAssistantQueryItem> _items;

  String _searchText = '';
  bool _isLoading = false;
  bool _hasMore = true;
  int? _nextPage = 1;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _conversationId = _newPagerConversationId();
    _items = List<AiAssistantQueryItem>.of(widget.args.items);
    _scrollController.addListener(_onScroll);
    _fetchPage(page: 1, replace: true);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  static String _newPagerConversationId() {
    final random = math.Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return 'pager_${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  void _onSearchChanged(String? value) {
    setState(() => _searchText = (value ?? '').trim().toLowerCase());
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter <= _loadMoreThreshold) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    final page = _nextPage;
    if (_isLoading || _hasLoadError || !_hasMore || page == null) return;
    _fetchPage(page: page);
  }

  Future<void> _fetchPage({required int page, bool replace = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });

    try {
      final result = await projectManagementSl<AiAssistantRepo>().queryProjects(
        widget.args.query,
        conversationId: _conversationId,
        page: page,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        if (replace) {
          _items = List<AiAssistantQueryItem>.of(result.items);
        } else {
          _items.addAll(result.items);
        }
        _hasMore = result.hasMore;
        _nextPage = result.nextPage;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  void _retry() {
    _fetchPage(page: _nextPage ?? 1, replace: _nextPage == 1);
  }

  /// Case-insensitive match over every stringified field value of a row.
  bool _matches(AiAssistantQueryItem item) {
    if (_searchText.isEmpty) return true;
    return item.fields.values.any(
      (value) => value.toLowerCase().contains(_searchText),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: const Center(
          child: SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (_hasLoadError) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Center(
          child: TextButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(allTranslations.text(LocaleKeys.try_again)),
          ),
        ),
      );
    }

    return const SizedBox(height: 16);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.color.primary;
    final onPrimary = context.color.onPrimary;
    final filtered = _items.where(_matches).toList(growable: false);
    final showEmpty = filtered.isEmpty && !_isLoading;

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: primary,
        foregroundColor: onPrimary,
        iconTheme: IconThemeData(color: onPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Text(
          widget.args.query.trim().isNotEmpty
              ? widget.args.query.trim()
              : allTranslations.text(LocaleKeys.ai_assistant_all_results),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomTextField(
                hint: allTranslations.text(
                  LocaleKeys.ai_assistant_search_results_hint,
                ),
                controller: _searchController,
                prefixSvg: 'search',
                addBorder: true,
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: filtered.length + (showEmpty ? 1 : 0) + 1,
                itemBuilder: (context, index) {
                  if (showEmpty && index == 0) {
                    return EmptyContainer(
                      txt: allTranslations.text(
                        _searchText.isEmpty
                            ? LocaleKeys.no_projects_match
                            : LocaleKeys.ai_assistant_no_matching_results,
                      ),
                    );
                  }

                  final itemIndex = index - (showEmpty ? 1 : 0);
                  if (itemIndex < filtered.length) {
                    return AiAssistantProjectResultCard(
                      item: filtered[itemIndex],
                    );
                  }
                  return _buildFooter(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
