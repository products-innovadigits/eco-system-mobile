import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/pms_layout.dart';

class PmsModule implements SystemModule {
  PmsModule() {
    setupPmsLocator();
  }

  @override
  String get id => 'pms_system';

  @override
  String get name => 'PMS System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.pms;

  @override
  List<BlocProvider> get providers => [];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.PMS_LAYOUT: (settings) {
      final args =
          settings.arguments as PmsLayoutArgs? ??
          const PmsLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) =>
            PmsLayout(index: args.index, showSwitcher: args.showSwitcher),
      );
    },
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'pms',
      order: 21,
      builder: (context) => MainCardWidget(
        height: 260.h,
        title: 'PMS',
        onViewMoreTap: () {
          UserBloc.currentActiveSystem = ActiveSystemEnum.pms;

          CustomNavigator.push(
            Routes.SYSTEM_SWITCHER,
            arguments: ActiveSystemEnum.pms,
          );
        },
        child: SizedBox.shrink(),
      ),
    ),
  ];
}
