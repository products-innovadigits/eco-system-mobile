import 'package:eco_system/utility/export.dart';

class CareerObjSection extends StatelessWidget {
  const CareerObjSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        return Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                    Text(allTranslations.text(LocaleKeys.career_objective),
                        style: AppTextStyles.w500),
                    Icon(
                        profileBloc.isCareerObjExpanded == false
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: profileBloc.isCareerObjExpanded == false
                            ? Styles.ICON_GREY_COLOR
                            : Styles.PRIMARY_COLOR),
                  ],
                ),
              ),
              if (profileBloc.isCareerObjExpanded == true) ...[
                12.sh,
                Text(
                    '''لقد قمت بالعمل في مشاريع متعددة في مجال [أذكر بعض المجالات أو الصناعات التي عملت بها]، حيث قمت بتصميم حلول مبتكرة تلبي احتياجات المستخدمين وتعزز من تفاعلهم مع المنتجات. أتمتع بقدرة على العمل ضمن فرق متعددة التخصصات، وأستخدم الأدوات والتقنيات الحديثة مثل [أذكر الأدوات مثل Sketch, Figma, Adobe XD، إلخ] لتحقيق أفضل تجربة للمستخدم.''',
                    style: AppTextStyles.w400.copyWith(
                        fontSize: 11, color: Styles.SUB_TEXT_DARK_COLOR))
              ]
            ],
          ),
        );
      },
    );
  }
}
