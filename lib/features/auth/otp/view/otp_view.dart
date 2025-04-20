import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/pin_code.dart';
import 'package:flutter/material.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: ListAnimator(
                  verticalOffset: 50.0,
                  horizontalOffset: 0.0,
                  data: [
                    SizedBox(height: 24.h),
                    Hero(
                      tag: "logo",
                      child: Material(
                        child: Center(
                          child: Text(
                            "LOGO",
                            style: TextStyle(
                              color: context.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 47.h),
                    const Text(
                      "رمز التحقق",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "قم بإدخال رمز التحقق لتأكيد الحساب",
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.primaryColorDark,
                      ),
                    ),
                    SizedBox(height: 84.h),
                    const Text(
                      "رمز التحقق",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const PinCode(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "إعادة إرسال الرمز بعد",
                          style: TextStyle(
                            color: context.theme.primaryColorDark,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          "02 : 04",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
              Hero(
                tag: "btn",
                child: CustomBtn(
                  text: "تأكيد",
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
