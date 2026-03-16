import 'package:core_system/core/components/custom_filters_drop_list.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_bloc.dart';

class CyclesFilterBottomSheetBody extends StatelessWidget {
  const CyclesFilterBottomSheetBody({super.key});

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
            options: bloc.statusList,
            initial: bloc.selectedStatus,
            onSelect: (s) {
              bloc.selectedStatus = s;
            },
          ),
        ],
      ),
    );
  }
}
