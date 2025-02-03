import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eco_system/core/app_core.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/features/login/model/user_model.dart';
import 'package:eco_system/main_blocs/user_bloc.dart';
import 'package:eco_system/main_models/search_engine.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';

class FabFloatingActionButton extends StatefulWidget {
  final UserModel model ;
  const FabFloatingActionButton({Key? key, required this.model}) : super(key: key);
  @override
  State<FabFloatingActionButton> createState() =>
      _FabFloatingActionButtonState();
}

class _FabFloatingActionButtonState extends State<FabFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 275),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Alignment alignment1 = Alignment(0.0, 0.0);
  Alignment alignment2 = Alignment(0.0, 0.0);
  Alignment alignment3 = Alignment(0.0, 0.0);
  double size1 = 0;
  double size2 = 0;
  double size3 = 0;
  bool toggle = true;

  Future<void> _cancel() async {
    toggle = !toggle;
    _controller.reverse();
    alignment1 = Alignment(0.0, 0.0);
    alignment2 = Alignment(0.0, 0.0);
    alignment3 = Alignment(0.0, 0.0);
    size1 = size2 = size3 = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: toggle ? 100 : MediaQueryHelper.width,
      height: toggle ? 230 : MediaQueryHelper.height,
      color: toggle ? Colors.transparent : Colors.white.withOpacity(.85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(
                () {
                  if (!toggle) {
                    toggle = !toggle;
                    _controller.reverse();
                    alignment1 = Alignment(0.0, 0.0);
                    alignment2 = Alignment(0.0, 0.0);
                    alignment3 = Alignment(0.0, 0.0);
                    size1 = size2 = size3 = 0;
                  }
                },
              ),
              child: Container(
                  width: toggle ? 100 : MediaQueryHelper.width,
                  height: toggle ? 230 : MediaQueryHelper.height,
                  color: Colors.transparent),
            ),
          ),
          SizedBox(
            height: 220.0,
            width: toggle ? 100.0 : 270,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _cancel().then(
                      (value) => Future.delayed(
                        Duration(milliseconds: 200),
                        () async {}
                      ),
                    );
                  },
                  child: AnimatedAlign(
                    curve: toggle ? Curves.easeIn : Curves.elasticOut,
                    duration: toggle
                        ? Duration(milliseconds: 275)
                        : Duration(milliseconds: 875),
                    alignment: alignment1,
                    child: AnimatedContainer(
                      curve: toggle ? Curves.easeIn : Curves.easeOut,
                      duration: Duration(milliseconds: 275),
                      height: size1,
                      width: size1,
                      decoration: BoxDecoration(
                        color: Styles.GREEN,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Center(
                        child: Text(
                          allTranslations.text("property"),
                          style: AppTextStyles.w800.copyWith(
                            fontSize: toggle ? 5 : 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  curve: toggle ? Curves.easeIn : Curves.elasticOut,
                  duration: toggle
                      ? Duration(milliseconds: 275)
                      : Duration(milliseconds: 875),
                  alignment: alignment2,
                  child: GestureDetector(
                    onTap: (){},
                    child: AnimatedContainer(
                      curve: toggle ? Curves.easeIn : Curves.easeOut,
                      duration: Duration(milliseconds: 275),
                      height: size2,
                      width: size2,
                      decoration: BoxDecoration(
                        color: Styles.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Center(
                        child: Text(
                          allTranslations.text("Tenant"),
                          style: AppTextStyles.w800.copyWith(
                              fontSize: toggle ? 5 : 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  curve: toggle ? Curves.easeIn : Curves.elasticOut,
                  duration: toggle
                      ? Duration(milliseconds: 275)
                      : Duration(milliseconds: 875),
                  alignment: alignment3,
                  child: AnimatedContainer(
                    curve: toggle ? Curves.easeIn : Curves.easeOut,
                    duration: Duration(milliseconds: 275),
                    height: size3,
                    width: size3,
                    decoration: BoxDecoration(
                      color: Styles.ORANGE1,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: InkWell(
                      onTap: (){},
                      child: Center(
                          child: Text(allTranslations.text("leases"),
                              style: AppTextStyles.w800.copyWith(
                                  fontSize: toggle ? 5 : 12,
                                  color: Colors.white))),
                    ),
                  ),
                ),
                Align(
                  alignment: toggle ? Alignment.bottomCenter : Alignment(0, .3),
                  child: Transform.rotate(
                    angle: _animation.value * pi * (3 / 4),
                    child: Container(
                      height: 65.0,
                      width: 65.0,
                      padding: EdgeInsets.only(bottom: 10),
                      // decoration: BoxDecoration(
                      //   color: Colors.yellow[600],
                      //   borderRadius: BorderRadius.circular(60.0),
                      // ),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              if (toggle) {
                                toggle = !toggle;
                                _controller.forward();
                                Future.delayed(Duration(milliseconds: 10), () {
                                  alignment1 = Alignment(-0.9, -0.4);
                                  size1 = 70.0;
                                });
                                Future.delayed(Duration(milliseconds: 100), () {
                                  alignment2 = Alignment(0.0, -0.8);
                                  size2 = 70.0;
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  alignment3 = Alignment(0.9, -0.4);
                                  size3 = 70.0;
                                });
                              } else {
                                _cancel();
                              }
                            });
                          },
                          icon: SvgPicture.asset(
                            "assets/svgs/add-circle.svg",
                            color: toggle ? Color(0xffA7A7A7) : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
