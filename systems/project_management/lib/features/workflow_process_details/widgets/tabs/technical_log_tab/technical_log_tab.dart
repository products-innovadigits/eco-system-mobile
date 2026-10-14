import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class TechnicalLogTab extends StatelessWidget {
  final int processId;
  final int projectId;

  const TechnicalLogTab({
    super.key,
    required this.processId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HistoryTabBloc(repo: projectManagementSl())
            ..add(LoadHistoryData(processId: processId, projectId: projectId)),
      child: BlocBuilder<HistoryTabBloc, HistoryTabState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            HistoryTabLoading() || HistoryTabInitial() =>
              const ShimmerCardsList(itemCount: 3, cardHeight: 200),

            // ── Loaded ──────────────────────────
            HistoryTabLoaded(:final historyData) => _HistoryList(
              items: historyData.data ?? const [],
            ),

            // ── Empty ───────────────────────────
            HistoryTabEmpty() => const EmptyContainer(),

            // ── Error / fallback ────────────────
            _ => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.something_went_wrong),
              img: Assets.svgs.error.path,
              onRetry: () => context.read<HistoryTabBloc>().add(
                LoadHistoryData(processId: processId, projectId: projectId),
              ),
            ),
          };
        },
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<HistoryItemModel> items;

  const _HistoryList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (_, index) => TechnicalLogTimelineCard(item: items[index]),
      separatorBuilder: (_, _) => const _TimelineDivider(),
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  const _TimelineDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 14, bottom: 14, start: 42),
      height: 1,
      color: context.color.outline,
    );
  }
}
