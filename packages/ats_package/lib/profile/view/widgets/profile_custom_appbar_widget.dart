import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
                image: Assets.svgs.arrowBack.path, color: Styles.WHITE_COLOR)),
        8.sw,
        isLoading == true
            ? CustomShimmerContainer(width: 120.w, height: 30, borderRadius: 4)
            : Text(title,
                style: AppTextStyles.w700.copyWith(color: Styles.WHITE_COLOR)),
        const Spacer(),
        GestureDetector(
            onTap: () => context.read<ProfileBloc>().add(ShowDialog()),
            child: Images(
                image: Assets.svgs.profileMore.path,
                color: Styles.WHITE_COLOR)),
      ],
    );
  }
}
