import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/bsc/widgets/objectives_bottom_sheet.dart';
import 'package:strategy_system/shared/bloc/bsc_objectives_bloc.dart';

import 'perspective_widget.dart';

class PerspectivesSection extends StatelessWidget {
  final List<ManzorModel> perspectives;

  const PerspectivesSection({super.key, required this.perspectives});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BscObjectivesBloc(),
      child: Column(
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
            itemCount: perspectives.length,
            itemBuilder: (context, index) {
              return PerspectiveWidget(
                title: perspectives[index].title ?? '',
                onTap: () {
                  context.read<BscObjectivesBloc>().resetObjectivesExpansion();
                  CustomBottomSheet.show(
                    height: context.h * 0.95,
                    widget: BlocProvider.value(
                      value: context.read<BscObjectivesBloc>(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            BottomSheetHeader(
                              title: perspectives[index].title ?? '',
                            ),
                            24.sh,
                            ObjectivesBottomSheet(
                              objectivesList:
                                  perspectives[index].objectives ?? [],
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
      ),
    );
  }
}
