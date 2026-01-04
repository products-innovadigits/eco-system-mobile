import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class ApplicationDate extends StatelessWidget {
  const ApplicationDate({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<AtsFiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.application_date),
          style: AppTextStyles.w400.copyWith(fontSize: 12),
        ),
        CustomTextField(
          hint: allTranslations.text(LocaleKeys.enter_application_date),
          controller: filtrationBloc.applicationDateController,
          isReadOnly: true,
          borderColor: context.color.outline,
          onTap: () async {
            DatePickerHelper.showDatePickerDialog(
              context,
              initialDate:
                  filtrationBloc.applicationDateController.text.isNotEmpty
                  ? DateTime.parse(
                      filtrationBloc.applicationDateController.text,
                    )
                  : null,
              (onDateSelected) {
                filtrationBloc.applicationDateController.text = onDateSelected
                    .toString();
              },
            );
          },
          suffixWidget: Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: Images(
              image: Assets.svgs.calendar.path,
              color: Styles.iconDarkColor,
              width: 19.h,
              height: 19.h,
            ),
          ),
        ),
      ],
    );
  }
}
