import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';


class MultipleSelectBtnWidget extends StatelessWidget {
  const MultipleSelectBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        return bloc.activeSelection
            ? Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      bloc.add(SelectTalent(arguments: {"selectAll": true}));
                    },
                    child: Text(
                      allTranslations.text(LocaleKeys.select_all),
                      style: context.textTheme.bodySmall?.copyWith(color: context.color.secondary),
                    ),
                  ),
                  8.sw,
                  GestureDetector(
                    onTap: () => bloc.add(Select(arguments: false)),
                    child: Text(
                      allTranslations.text(LocaleKeys.cancel),
                      style: context.textTheme.bodySmall?.copyWith(color: context.color.outline, fontSize: FontSizes.f10),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => bloc.add(Select(arguments: true)),
                child: Text(
                  allTranslations.text(LocaleKeys.select),
                  style: context.textTheme.bodySmall?.copyWith(color: context.color.secondary),
                ),
              );
      },
    );
  }
}
