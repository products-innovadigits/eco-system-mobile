import 'package:pms_system/workflow_process_details/bloc/stage_docs_bloc.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/stage_docs_tab/view_comments_bottom_sheet.dart';

import '../../../../shared/pms_exports.dart';

class StageDocsTab extends StatelessWidget {
  const StageDocsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StageDocsBloc(),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: context.color.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.color.outline),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'عملية ادارة طرح المشروع والتعميد',
                        style: context.textTheme.labelSmall,
                      ),
                    ),
                    _DocActionCardWidget(
                      icon: Assets.svgs.copy.path,
                      onTap: () {},
                    ),
                    SizedBox(width: 4),
                    _DocActionCardWidget(
                      icon: Assets.svgs.eye.path,
                      onTap: () {
                        PopUpHelper.showBottomSheet(
                          child: ViewCommentsBottomSheet(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.color.secondary.withValues(alpha: 0.1),
                      ),
                      child: Images(
                        image: Assets.svgs.setting.path,
                        color: context.color.secondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allTranslations.text(LocaleKeys.operation_name),
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: FontSizes.f10,
                            color: context.color.outlineVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'الادارة / مركز',
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: FontSizes.f10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<StageDocsBloc, AppState>(
                  builder: (context, state) {
                    final bloc = context.read<StageDocsBloc>();
                    return CustomTextField(
                      verticalPadding: 0,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      controller: bloc.commentCtrl,
                      suffixWidget: InkWell(
                        onTap: () {
                          bloc.add(Click());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Images(
                            image: Assets.svgs.send.path,
                            color: context.color.secondary,
                          ),
                        ),
                      ),
                      textStyle: context.textTheme.labelSmall,
                      hint:
                          '${allTranslations.text(LocaleKeys.add_comment)}...',
                    );
                  },
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: CustomTextField(
                //         verticalPadding: 0,
                //         contentPadding: EdgeInsets.symmetric(
                //           horizontal: 16.w,
                //           vertical: 6.h,
                //         ),
                //         textStyle: context.textTheme.labelSmall,
                //         hint:
                //             '${allTranslations.text(LocaleKeys.add_comment)}...',
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     CustomBtn(
                //       text: allTranslations.text(LocaleKeys.save),
                //       height: 30,
                //       width: 60,
                //       fontSize: 12,
                //       borderRadius: 8,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DocActionCardWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _DocActionCardWidget({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.color.outline),
        ),
        child: Images(image: icon, color: context.color.primary, width: 14),
      ),
    );
  }
}
