import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class AddSkillFieldWidget extends StatelessWidget {
  const AddSkillFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FiltrationBloc>();
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: context.color.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.w,
            child: TextField(
              controller: bloc.skillController,
              maxLines: 1,
              style: context.textTheme.bodySmall,
              onChanged: (v) => bloc.add(Update()),
              onSubmitted: (v) {
                if (v.isNotEmpty) {
                  bloc.add(AddSkill(
                      arguments:
                          DropListModel(name: bloc.skillController.text)));
                }
              },
              decoration: InputDecoration(
                  hintText: allTranslations.text(LocaleKeys.add_skill),
                  hintStyle: context.textTheme.bodySmall
                      ?.copyWith(color: context.color.outlineVariant),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6.h)),
            ),
          ),
          4.sw,
          GestureDetector(
            onTap: () {
              if (bloc.skillController.text.isNotEmpty) {
                bloc.add(AddSkill(
                    arguments: DropListModel(name: bloc.skillController.text)));
              }
            },
            child: bloc.skillController.text.isNotEmpty
                ? Images(
                    image: Assets.svgs.send.path,
                    color: context.color.secondary,
                    height: 20)
                : Icon(
                    Icons.add,
                    color: context.color.secondary,
                    size: 16,
                  ),
          ),
        ],
      ),
    );
  }
}
