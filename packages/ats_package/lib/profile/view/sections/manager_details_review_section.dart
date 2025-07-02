import 'package:ats_package/profile/view/widgets/manager_review_card_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ManagersReviewsListSection extends StatelessWidget {
  const ManagersReviewsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ManagerReviewCardWidget(
              isExpanded: context.read<ProfileBloc>().reviewExpandedIndex == index,
              onExpand: () => context.read<ProfileBloc>().add(ToggleExpand(arguments: index)),
            ),
        separatorBuilder: (context, index) => 16.sh,
        itemCount: 4);
  }
}
