import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/custom_sort_tile_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortingBottomSheet extends StatelessWidget {
  const SortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.sort),
                24.sh,
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => CustomSortTileWidget(
                        title: bloc.sortingList[index].name ?? '',
                        isSelected: bloc.selectedSorting?.id == index + 1,
                        onSelect: () =>
                            bloc.add(Sort(arguments: bloc.sortingList[index]))),
                    separatorBuilder: (context, index) => 16.sh,
                    itemCount: 6),
                80.sh,
              ],
            ),
            Positioned(
              bottom: 0,
              child: CustomBtn(
                  width: context.w * 0.9,
                  text: allTranslations.text(LocaleKeys.show_all_results),
                  onPressed: () => CustomNavigator.pop()),
            )
          ],
        );
      },
    );
  }
}
