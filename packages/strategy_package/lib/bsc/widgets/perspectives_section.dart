import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/bottom_sheet_header.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';
import 'package:strategy_package/bsc/widgets/objectives_bottom_sheet.dart';

import 'perspective_widget.dart';

class PerspectivesSection extends StatelessWidget {
  const PerspectivesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BscBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.perspectives),
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: bloc.perspectives.length,
          itemBuilder: (context, index) {
            return PerspectiveWidget(
              title: bloc.perspectives[index].title ?? '',
              onTap: () {
                bloc.resetObjectivesExpansion();
                CustomBottomSheet.show(
                  height: context.h * 0.95,
                  widget: BlocProvider.value(
                    value: bloc,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          BottomSheetHeader(
                            title: bloc.perspectives[index].title ?? '',
                          ),
                          24.sh,
                          ObjectivesBottomSheet(
                            objectivesList: bloc.perspectives[index].objectives ?? [],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
