import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/bloc/filtration_bloc.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/helpers/date_picker_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    ;
  }
}
