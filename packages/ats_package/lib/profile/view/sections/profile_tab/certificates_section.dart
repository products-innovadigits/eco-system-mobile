import 'package:ats_package/profile/view/widgets/profile_tab/certificate_card_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        final List<CertificateModel> certificatesList =
            profileBloc.candidateModel?.profile?.certificates ?? [];
        return state is Loading
            ? CustomShimmerContainer(height: 60, borderRadius: 8)
            : certificatesList.isEmpty
            ? const SizedBox.shrink()
            : Container(
                width: context.w,
                decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.color.outline),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                  expansionAnimationStyle: AnimationStyle(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  title: Text(
                    allTranslations.text(LocaleKeys.certificates),
                    style: context.textTheme.titleMedium,
                  ),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  iconColor: context.color.secondary,
                  collapsedIconColor: context.color.outlineVariant,
                  collapsedTextColor: context.color.onSurface,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ).copyWith(bottom: 16.h),
                      child: ListAnimator(
                        separatorPadding: 24.h,
                        data: List.generate(
                          certificatesList.length,
                          (index) => CertificateCardWidget(
                            certificate: certificatesList[index],
                          ),
                        ),
                      ),
                      // child: ListView.separated(
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemBuilder: (context, index) =>
                      //         CertificateCardWidget(
                      //             certificate: certificatesList[index]),
                      //     separatorBuilder: (context, index) => 24.sh,
                      //     itemCount: certificatesList.length)
                    ),
                  ],
                ),
              );
      },
    );
  }
}
