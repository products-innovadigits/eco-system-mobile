import 'package:flutter/material.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/grid_list_animator.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/main_blocs/main_app_bloc.dart';
import 'package:eco_system/main_pages/models/menu_model.dart';
class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<String>(
      stream: mainAppBloc.langStream,
      builder: (context, lang) {
        final List<Widget> _cards = MenuModel.generateMenuCards();
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10  , left: 15 , right: 15 , bottom: 20.0),
                  child: GridListAnimator(
                    data: _cards,
                    aspectRatio: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
