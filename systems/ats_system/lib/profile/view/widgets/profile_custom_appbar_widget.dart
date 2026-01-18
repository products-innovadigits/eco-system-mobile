import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class ProfileCustomAppbarWidget extends StatelessWidget {
  final String title;
  final bool? isLoading;

  const ProfileCustomAppbarWidget(
      {super.key, required this.title, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(
                image: Assets.svgs.arrowBack.path, color: context.color.surfaceContainer)),
        SizedBox(width: 8.w),
        isLoading == true
            ? CustomShimmerContainer(width: 120.w, height: 30, borderRadius: 4)
            : Text(title,
                style: context.textTheme.titleSmall?.copyWith(color: context.color.surfaceContainer , fontWeight: FontWeight.w700)),
        const Spacer(),
        GestureDetector(
            onTap: () => context.read<ProfileBloc>().add(ShowDialog()),
            child: Images(
                image: Assets.svgs.profileMore.path,
                color: context.color.surfaceContainer)),
      ],
    );
  }
}
