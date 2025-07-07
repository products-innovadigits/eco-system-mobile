import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ApplicationDate extends StatelessWidget {
  const ApplicationDate({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.application_date),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        CustomTextField(
          hint: allTranslations.text(LocaleKeys.enter_application_date),
          controller: filtrationBloc.applicationDateController,
          isReadOnly: true,
          borderColor: Styles.BORDER_COLOR,
          onTap: () async {
            DatePickerHelper.showDatePickerDialog(
              context,
              initialDate:
                  filtrationBloc.applicationDateController.text.isNotEmpty
                      ? DateTime.parse(
                          filtrationBloc.applicationDateController.text)
                      : null,
              (onDateSelected) {
                filtrationBloc.applicationDateController.text =
                    onDateSelected.toString();
              },
            );
          },
          suffixWidget: Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: Images(
                image: Assets.svgs.calendar.path,
                color: Styles.ICON_DARK_COLOR,
                width: 19.h,
                height: 19.h),
          ),
        ),
      ],
    );
  }
}
