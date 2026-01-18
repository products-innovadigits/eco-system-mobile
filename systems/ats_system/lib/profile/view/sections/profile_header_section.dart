import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class ProfileHeaderSection extends StatelessWidget {
  final bool isTalent;

  const ProfileHeaderSection({super.key, required this.isTalent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      buildWhen: (previous, current) => current is! Exporting,
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        if (state is Done) {
          CandidateModel? candidateModel = profileBloc.candidateModel;
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
                  // color: context.color.primary,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.images.newHomeHeaderBg.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          ProfileCustomAppbarWidget(
                            title: candidateModel?.jobTitle ?? '',
                          ),
                          SizedBox(height: 16.h),
                          ProfileUserDataWidget(
                            cvUrl: candidateModel?.resume?.url ?? '',
                            showAvatarPercentage: !isTalent,
                            name: candidateModel?.name ?? '',
                            email: candidateModel?.email ?? '',
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            spacing: 8.w,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (candidateModel?.lastChance?.stageName != null)
                                ProfileDataContainerWidget(
                                  title: candidateModel!.lastChance!.stageName!,
                                  icon: Assets.svgs.layers.path,
                                  onTap: () {},
                                ),
                              if (candidateModel?.phone != null)
                                ProfileDataContainerWidget(
                                  title: candidateModel!.phone!,
                                  icon: Assets.svgs.call.path,
                                  onTap: () => LauncherHelper.makePhoneCall(
                                    candidateModel.phone ?? '',
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (profileBloc.showMoreDialog || _controller.isAnimating)
                Positioned(
                  left: 0,
                  top: 0,
                  child: AnimatedCrossFade(
                    firstChild: SizedBox.shrink(),
                    secondChild: isTalent
                        ? CandidateMoreDialog(
                            candidateId: profileBloc.candidateModel?.id ?? 0,
                          )
                        : ApplicantMoreDialog(
                            email: candidateModel?.email ?? '',
                          ),
                    crossFadeState: profileBloc.showMoreDialog
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
                // Positioned(
                //   left: 0.w,
                //   top: 0.h,
                //   child: ScaleTransition(
                //     scale: _scale,
                //     alignment: Alignment.topLeft,
                //     child: widget.isTalent
                //         ? CandidateMoreDialog(
                //         candidateId: profileBloc.candidateModel?.id ?? 0)
                //         : ApplicantMoreDialog(
                //         email: candidateModel?.email ?? ''),
                //   ),
                // )
              ],
            ),
          );
        }
        if (state is Loading) {
          return CustomShimmerContainer(height: 320.h);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
