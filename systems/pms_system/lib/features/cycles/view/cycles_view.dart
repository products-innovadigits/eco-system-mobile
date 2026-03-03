import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/widgets/cycles_app_bar_widget.dart';
import 'package:pms_system/features/cycles/widgets/cycles_body_mobile_landscape_view.dart';
import 'package:pms_system/features/cycles/widgets/cycles_body_mobile_portrait_view.dart';

class CyclesView extends StatefulWidget {
  const CyclesView({super.key});

  @override
  State<CyclesView> createState() => _CyclesViewState();
}

class _CyclesViewState extends State<CyclesView> {
  late CyclesBloc _cyclesBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cyclesBloc = CyclesBloc(repo: pmsSl())
      ..add(LoadCycles(searchEngine: SearchEngine()));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cyclesBloc.add(const LoadMoreCycles());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _cyclesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CyclesBloc>.value(
      value: _cyclesBloc,
      child: Builder(
        builder: (context) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return Scaffold(
            appBar: CyclesAppBarWidget(
              bloc: _cyclesBloc,
              searchController: _searchController,
              isPortrait: isPortrait,
            ),
            body: CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => CyclesBodyMobilePortraitView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
              mobileLandscape: (ctx) => CyclesBodyMobileLandscapeView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
            ),
          );
        },
      ),
    );
  }
}
