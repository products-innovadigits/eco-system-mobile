import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/login/model/user_model.dart';
import 'package:eco_system/main_models/search_engine.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/main_blocs/main_app_bloc.dart';
import 'package:eco_system/main_blocs/user_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/main_pages/widgets/fab_floating_action_button.dart';

class MainPage extends StatefulWidget {
  final int? index;

  const MainPage({Key? key, this.index}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _index = 0;
  late List<Widget> _screens = [];

  Color _selectedColor(int index) =>
      _index == index ? Styles.PRIMARY_COLOR : Colors.grey;
  SharedHelper sharedHelper = SharedHelper();

  @override
  void initState() {
    UserBloc.instance.add(Click());
    if (widget.index != null) {
      _index = widget.index!;
    }
    _screens = [

      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, AppState>(
      listener: (context, state) {
        if (state is Done) {
        }
      },
      builder: (context, state) {
        if(state is Done){
          UserModel model = state.model as UserModel ;
          return StreamBuilder<String>(
              stream: mainAppBloc.langStream,
              builder: (context, lang) {
                return Scaffold(
                  backgroundColor: Styles.WHITE_COLOR,
                  floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FabFloatingActionButton(model : model),
                  bottomNavigationBar: BottomNavigationBar(
                    iconSize: 35,
                    onTap: (i) {
                      setState(() => _index = i);
                    },
                    backgroundColor: Colors.white,
                    elevation: 10,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _index,
                    selectedLabelStyle: const TextStyle(
                        color: Styles.PRIMARY_COLOR,
                        fontSize: 11,
                        fontWeight: FontWeight.w800),
                    unselectedLabelStyle: const TextStyle(
                        color: Styles.SUB_HEADER,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                    selectedItemColor: Styles.PRIMARY_COLOR,
                    items: [
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/svgs/cube.svg',
                              color: _selectedColor(0)),
                          label: allTranslations.text('dashboard')),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/svgs/invoices.svg',
                              color: _selectedColor(1)),
                          label: allTranslations.text('invoices')),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/svgs/add-circle.svg',
                              color: Colors.transparent),
                          label: allTranslations.text('add')),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/svgs/buildings.svg',
                              color: _selectedColor(3)),
                          label: allTranslations.text('properties')),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/svgs/more-circle.svg',
                            color: _selectedColor(4)),
                        label: allTranslations.text('more'),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      _screens[_index],
                    ],
                  ),
                );
              });
        }
        return Container();

      },
    );
  }
}
