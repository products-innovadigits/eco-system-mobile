import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CompatibilityRate extends StatelessWidget {
  const CompatibilityRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.compatibility_rate),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        CustomTextField(
          hint: allTranslations.text(LocaleKeys.enter_compatibility_rate),
          controller:
              context.read<FiltrationBloc>().compatibilityRateController,
          type: TextInputType.number,
          suffixWidget: Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: Icon(Icons.percent_outlined),
          ),
        ),
      ],
    );
  }
}
