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
                    decoration: BoxDecoration(
                        color: Styles.WHITE_COLOR,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Styles.BORDER)),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                      title: Text(allTranslations.text(LocaleKeys.certificates),
                          style: AppTextStyles.w500
                              .copyWith(color: Styles.HEADER, fontSize: 14)),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      iconColor: Styles.PRIMARY_COLOR,
                      collapsedIconColor: Styles.ICON_GREY_COLOR,
                      collapsedTextColor: Styles.HEADER,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w)
                                .copyWith(bottom: 16.h),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    CertificateCardWidget(
                                        certificate: certificatesList[index]),
                                separatorBuilder: (context, index) => 24.sh,
                                itemCount: certificatesList.length)),
                      ],
                    ),
                  );
      },
    );
  }
}
