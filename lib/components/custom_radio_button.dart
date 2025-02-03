import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final Widget checkedWidget, unCheckedWidget;
  final void Function(bool)? onChange;
  CustomRadioButton(this.check,this.checkedWidget, this.unCheckedWidget, {this.onChange});
  final bool check;
  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if(widget.onChange != null) widget.onChange!(widget.check);
        },
        child: widget.check ? widget.checkedWidget : widget.unCheckedWidget);
  }
}
