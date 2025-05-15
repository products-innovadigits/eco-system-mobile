
import 'package:eco_system/utility/export.dart';

class ProfileHeaderSection extends StatefulWidget {
  final bool isCandidate;

  const ProfileHeaderSection({super.key, required this.isCandidate});

  @override
  State<ProfileHeaderSection> createState() => _ProfileHeaderSectionState();
}

class _ProfileHeaderSectionState extends State<ProfileHeaderSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAnimation(bool show) {
    if (show) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        _handleAnimation(profileBloc.showMoreDialog);
        return GestureDetector(
          onTap: () {
            if (profileBloc.showMoreDialog) {
              profileBloc.add(ShowDialog(arguments: false));
            }
          },
          child: Stack(
            children: [
              Container(
                width: context.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.images.prfileHeaderBg.path),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.sh,
                        ProfileCustomAppbarWidget(
                            title: 'قائد فريق تصميم المنتجات'),
                        16.sh,
                        ProfileUserDataWidget(),
                        10.sh,
                        Row(
                          spacing: 8.w,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileDataContainerWidget(
                              title: 'مرحلة المقابلة الهاتفية',
                              icon: Assets.svgs.layers.path,
                            ),
                            ProfileDataContainerWidget(
                              title: '010908888',
                              icon: Assets.svgs.call.path,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (profileBloc.showMoreDialog || _controller.isAnimating)
                Positioned(
                  left: 0.w,
                  top: 0.h,
                  child: ScaleTransition(
                    scale: _scale,
                    alignment: Alignment.topLeft,
                    child: widget.isCandidate
                        ? CandidateMoreDialog()
                        : ApplicantMoreDialog(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
