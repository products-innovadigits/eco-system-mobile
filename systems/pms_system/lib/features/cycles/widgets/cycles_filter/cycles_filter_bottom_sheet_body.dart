import 'package:core_system/core/components/custom_filters_drop_list.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_bloc.dart';

class CyclesFilterBottomSheetBody extends StatelessWidget {
  const CyclesFilterBottomSheetBody({super.key});

  static List<DropListModel> _stateOptions() {
    return [
      DropListModel(
        name: allTranslations.text(LocaleKeys.cycle_state_not_started),
        key: 'not started',
      ),
      DropListModel(
        name: allTranslations.text(LocaleKeys.cycle_state_active),
        key: 'active',
      ),
      DropListModel(
        name: allTranslations.text(LocaleKeys.cycle_state_canceled),
        key: 'canceled',
      ),
      DropListModel(
        name: allTranslations.text(LocaleKeys.cycle_state_completed),
        key: 'completed',
      ),
      DropListModel(
        name: allTranslations.text(LocaleKeys.cycle_state_overdue),
        key: 'overdue',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CyclesFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.3,
      child: ListAnimator(
        separatorPadding: 16.h,
        data: [
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: _stateOptions(),
            selectedOptionKey: bloc.selectedStateKey,
            onSelect: (s) {
              bloc.selectedStateKey = s.key;
            },
          ),
        ],
      ),
    );
  }
}
