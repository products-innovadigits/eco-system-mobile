import 'package:ats_package/shared/ats_exports.dart';
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
                      style: AppTextStyles.w400
                          .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
                    ),
                  ),
                  8.sw,
                  GestureDetector(
                    onTap: () => bloc.add(Select(arguments: false)),
                    child: Text(
                      allTranslations.text(LocaleKeys.cancel),
                      style: AppTextStyles.w400.copyWith(
                          fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => bloc.add(Select(arguments: true)),
                child: Text(
                  allTranslations.text(LocaleKeys.select),
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
                ),
              );
      },
    );
  }
}
