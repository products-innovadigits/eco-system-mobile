import 'package:eco_system/features/ats/profile/view/widgets/profile_tab/certificate_card_widget.dart';
import 'package:eco_system/utility/export.dart';

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
            ? CustomShimmerContainer(
                height: 60,
                borderRadius: 8,
              )
            : certificatesList.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: context.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                        color: Styles.WHITE_COLOR,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Styles.BORDER)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => profileBloc.add(Expand(arguments: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  allTranslations.text(LocaleKeys.certificates),
                                  style: AppTextStyles.w500),
                              Icon(
                                  profileBloc.isCertificatesExpanded == false
                                      ? Icons.keyboard_arrow_down_rounded
                                      : Icons.keyboard_arrow_up_rounded,
                                  color: profileBloc.isCertificatesExpanded ==
                                          false
                                      ? Styles.ICON_GREY_COLOR
                                      : Styles.PRIMARY_COLOR),
                            ],
                          ),
                        ),
                        if (profileBloc.isCertificatesExpanded == true) ...[
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  CertificateCardWidget(
                                      certificate: certificatesList[index]),
                              separatorBuilder: (context, index) => 24.sh,
                              itemCount: certificatesList.length),
                        ]
                      ],
                    ),
                  );
      },
    );
  }
}
