import 'package:project_management/core/utility/project_management_exports.dart';

/// Navigation payload for [AiAssistantAllResultsView].
///
/// [items] is the full result set already loaded in the chat (the "View more"
/// button forwards every row, not just the 5 shown in the bubble). [query] is
/// the original user question, used only for the screen title.
class AiAssistantAllResultsArgs {
  const AiAssistantAllResultsArgs({required this.items, this.query});

  final List<AiAssistantQueryItem> items;
  final String? query;
}

/// Full-results screen for a single AI Assistant answer: shows every matching
/// project and filters the already-loaded rows locally (no extra network call).
class AiAssistantAllResultsView extends StatefulWidget {
  const AiAssistantAllResultsView({super.key, required this.args});

  final AiAssistantAllResultsArgs args;

  @override
  State<AiAssistantAllResultsView> createState() =>
      _AiAssistantAllResultsViewState();
}

class _AiAssistantAllResultsViewState extends State<AiAssistantAllResultsView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String _searchText = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String? value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _searchText = (value ?? '').trim().toLowerCase());
    });
  }

  /// Case-insensitive match over every stringified field value of a row.
  bool _matches(AiAssistantQueryItem item) {
    if (_searchText.isEmpty) return true;
    for (final value in item.fields.values) {
      if (value.toLowerCase().contains(_searchText)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.color.primary;
    final onPrimary = context.color.onPrimary;

    final filtered = widget.args.items.where(_matches).toList(growable: false);

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
          widget.args.query?.trim().isNotEmpty == true
              ? widget.args.query!.trim()
              : allTranslations.text(LocaleKeys.ai_assistant_all_results),
          maxLines: 1,
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
                prefixSvg: "search",
                addBorder: true,
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyContainer(
                      txt: allTranslations.text(
                        LocaleKeys.ai_assistant_no_matching_results,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          AiAssistantProjectResultCard(item: filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
