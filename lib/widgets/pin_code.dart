import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatelessWidget {
  const PinCode({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 5,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 56.h,
        fieldWidth: 56.h,
        inactiveFillColor: context.theme.primaryColorLight,
        activeFillColor: Colors.white,
        activeColor: context.theme.primaryColor,
        selectedFillColor: context.theme.primaryColor,
        selectedColor: context.theme.primaryColor,
        inactiveColor: context.theme.primaryColorLight,
      ),
      animationDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(fontSize: 20),
      onChanged: (value) {},
      onCompleted: (value) {},
    );
  }
}
