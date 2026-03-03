import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';

class CyclesAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final CyclesBloc bloc;
  final TextEditingController searchController;
  final bool isPortrait;

  const CyclesAppBarWidget({
    super.key,
    required this.bloc,
    required this.searchController,
    this.isPortrait = true,
  });

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    isPortrait ? 122.h : 200.h,
  );

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: allTranslations.text(LocaleKeys.cycles),
      withSearch: true,
      withCancelBtn: true,
      onSearching: (value) => bloc.add(SearchChanged(value)),
      onCanceling: () => bloc.add(const SearchChanged('')),
      searchController: searchController,
      searchHintText: allTranslations.text(LocaleKeys.search_hint),
    );
  }
}
