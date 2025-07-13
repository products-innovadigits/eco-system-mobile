import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
                          10.sh,
                          ProfileCustomAppbarWidget(
                            title: candidateModel?.jobTitle ?? '',
                          ),
                          16.sh,
                          ProfileUserDataWidget(
                            cvUrl: candidateModel?.resume?.url ?? '',
                            showAvatarPercentage: !isTalent,
                            name: candidateModel?.name ?? '',
                            email: candidateModel?.email ?? '',
                          ),
                          12.sh,
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
          return Column(
            children: [CustomShimmerContainer(height: 320.h, width: context.w)],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
