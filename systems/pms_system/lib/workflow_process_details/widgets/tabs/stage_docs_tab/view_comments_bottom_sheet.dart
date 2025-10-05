import 'package:pms_system/shared/pms_exports.dart';

class ViewCommentsBottomSheet extends StatelessWidget {
  const ViewCommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: allTranslations.text(LocaleKeys.view_comments),
        ),
        const SizedBox(height: 24),
        Stack(
          children: [
            ListAnimator(
              separatorPadding: 12,
              data: List.generate(
                4,
                (index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.color.outline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'عملية ادارة طرح المشروع للترسية والتعميد',
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Images(image: Assets.svgs.trash.path),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {},
                        child: Images(image: Assets.svgs.editSquare.path),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () => CustomNavigator.pop()))
          ],
        ),
      ],
    );
  }
}
