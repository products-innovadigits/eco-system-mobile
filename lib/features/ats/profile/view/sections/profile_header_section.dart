import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
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
        if (state is Done) {
          CandidateModel candidateModel = state.model as CandidateModel;
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.sh,
                          ProfileCustomAppbarWidget(
                              title: candidateModel.jobTitle ?? ''),
                          16.sh,
                          if (candidateModel.resume?.url != null)
                            ProfileUserDataWidget(
                              cvUrl: candidateModel.resume?.url ?? '',
                            ),
                          10.sh,
                          Row(
                            spacing: 8.w,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (candidateModel.lastChance?.stageName != null)
                                ProfileDataContainerWidget(
                                  title: candidateModel.lastChance!.stageName!,
                                  icon: Assets.svgs.layers.path,
                                ),
                              if (candidateModel.phone != null)
                                ProfileDataContainerWidget(
                                  title: candidateModel.phone!,
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
        }
        if (state is Loading) {
          return Column(
            children: [
              CustomShimmerContainer(
                height: 130.h,
                width: context.w,
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
