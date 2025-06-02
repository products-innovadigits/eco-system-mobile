import 'package:eco_system/features/ats/candidates/view/sections/picked_choices_list.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/add_skill_field_widget.dart';
import 'package:eco_system/utility/export.dart';

class Skills extends StatelessWidget {
  final List<DropListModel> selectedSkills;

  const Skills({super.key, required this.selectedSkills});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<FiltrationBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(allTranslations.text(LocaleKeys.skills),
                style: AppTextStyles.w400.copyWith(fontSize: 12)),
            8.sh,
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Styles.BORDER),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                runSpacing: 8.h,
                children: [
                  if (selectedSkills.isNotEmpty) ...[
                    PickedChoicesList(
                        list: selectedSkills,
                        onRemove: (item) =>
                            bloc.add(RemoveSkill(arguments: item))),
                    8.sw,
                  ],
                  AddSkillFieldWidget()
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 8.h),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Styles.BORDER),
            //   ),
            //   child: Stack(
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 16.w),
            //         child: Wrap(
            //           children: [
            //             TextField(
            //               controller: bloc.skillController,
            //               maxLines: 1,
            //               style: AppTextStyles.w400.copyWith(fontSize: 12),
            //               decoration: InputDecoration(
            //                   hintText:
            //                       allTranslations.text(LocaleKeys.add_skill),
            //                   hintStyle: AppTextStyles.w400
            //                       .copyWith(fontSize: 12, color: Styles.HINT),
            //                   border: InputBorder.none,
            //                   focusedBorder: InputBorder.none,
            //                   enabledBorder: InputBorder.none,
            //                   errorBorder: InputBorder.none,
            //                   contentPadding:
            //                       EdgeInsets.symmetric(vertical: 8.h)),
            //             ),
            //             if (selectedSkills.isNotEmpty) ...[
            //               PickedChoicesList(
            //                   list: selectedSkills,
            //                   onRemove: (item) =>
            //                       bloc.add(RemoveSkill(arguments: item))),
            //               16.sw,
            //             ],
            //           ],
            //         ),
            //       ),
            //       Positioned.directional(
            //         textDirection: TextDirection.ltr,
            //         start: 0,
            //         bottom: 0,
            //         child: InkWell(
            //           onTap: () {
            //             bloc.add(PickSkill(
            //                 arguments: DropListModel(
            //                     name: bloc.skillController.text)));
            //           },
            //           child: Padding(
            //             padding:
            //                 EdgeInsetsDirectional.symmetric(horizontal: 8.w),
            //             child: Icon(Icons.add,
            //                 color: Styles.PRIMARY_COLOR, size: 20),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
