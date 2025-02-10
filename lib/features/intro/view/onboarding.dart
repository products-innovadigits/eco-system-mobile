import 'package:flutter/material.dart';
import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحساب"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListAnimator(
          verticalOffset: 50.0,
          horizontalOffset: 0.0,
          data: [
            SizedBox(height: 96.h),
            Center(
              child: Hero(
                tag: "logo",
                child: Material(
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Styles.PRIMARY_COLOR.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          "LOGO",
                          style: TextStyle(
                            color: Styles.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 26.h),
            const Center(
              child: Text(
                "قم بتسجيل الدخول",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "قم بتسجيل الدخول لكي تتمكن من \nالإستفادة من كامل المميزات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Styles.PRIMARY_COLOR.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Hero(
              tag: "btn",
              child: CustomBtn(
                text: "تسجيل الدخول",
                onPressed: () {
                  CustomNavigator.push(Routes.LOGIN);
                },
              ),
            ),
            SizedBox(height: 24.h),
            CustomBtn(
              text: "إنشاء حساب",
              color: context.color.secondary,
              borderColor: context.theme.primaryColor,
              textColor: context.theme.primaryColor,
              onPressed: () {
                CustomNavigator.push(Routes.SIGNUP);
              },
            ),
          ],
        ),
      ),
    );
  }
}
