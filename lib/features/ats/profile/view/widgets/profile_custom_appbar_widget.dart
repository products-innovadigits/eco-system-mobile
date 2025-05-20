import 'package:eco_system/utility/export.dart';

class ProfileCustomAppbarWidget extends StatelessWidget {
  final String title;

  const ProfileCustomAppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(
                image: Assets.svgs.arrowBack.path, color: Styles.WHITE_COLOR)),
        8.sw,
        Text(title,
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
