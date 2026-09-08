import 'package:project_management/core/utility/project_management_exports.dart';

class FollowProcessTab extends StatelessWidget {
  final List<GroupStepsData> processList;
  final bool hasError;
  final String? errorMessage;
  final bool isReloading;
  final VoidCallback? onRetry;

  const FollowProcessTab({
    super.key,
    required this.processList,
    this.hasError = false,
    this.errorMessage,
    this.isReloading = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Retrying reloads the group steps only, so the shimmer stays in this tab.
    if (isReloading) {
      return const ShimmerCardsList(
        itemCount: 4,
        cardHeight: 80,
        listPadding: 0,
      );
    }

    // The group steps call only feeds this tab, so its failure is shown here
    // instead of taking over the whole screen, with the message the API sent
    // when there is one.
    if (hasError) {
      return EmptyContainer(
        txt:
            errorMessage ??
            allTranslations.text(LocaleKeys.something_went_wrong),
        img: Assets.svgs.error.path,
        onRetry: onRetry,
      );
    }

    if (processList.isEmpty) {
      return const EmptyContainer();
    }

    return ListView.separated(
      itemCount: processList.length,
      itemBuilder: (context, index) =>
          ProcessExpansionCardWidget(processList: processList, index: index),
      separatorBuilder: (context, index) => SizedBox(height: 12.0.h),
    );
  }
}
