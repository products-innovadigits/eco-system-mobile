
import 'package:eco_system/utility/export.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.location),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        8.sh,
        CustomDropList(
          list: filtrationBloc.locations,
          hint: allTranslations.text(LocaleKeys.select_your_location),
          onChanged: (value) {},
        ),
        // CustomTextField(
        //   hint: allTranslations.text(LocaleKeys.enter_your_location),
        //   controller:
        //   context.read<CandidatesBloc>().locationController,
        //  isReadOnly: true,
        //  onTap: (){
        //
        //  },
        // ),
      ],
    );
  }
}
