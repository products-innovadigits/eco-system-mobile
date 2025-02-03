import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eco_system/features/login/widget/error_widget.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';

class CustomTextField extends StatefulWidget {
  final IconData? icon;
  final Color? iconColor;
  final TextInputType? type;
  final String? hint;
  final String? label;
  final onChange;
  final onSubmit;
  final focusNode;
  final FormFieldValidator<String>? validate;
  final int? maxLines;
  final controller;
  final bool keyboardPadding;
  final bool withLabel;
  final bool readOnly;
  final maxLength;
  final bool? autoFocus;
  final bool? alignLabel;
  final errorText;
  final String? initialValue;
  final bool isEnabled;
  final bool? alignLabelWithHint;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool? obscureText;
  final bool withWidth;
  final bool? customError;
  final GestureTapCallback? onTap;

  final Color? onlyBorderColor;

  final List<TextInputFormatter>? formattedType;
  final Alignment? align;

  const CustomTextField({
    Key? key,
    this.icon,
    this.align,
    this.type,
    this.hint,
    this.alignLabelWithHint,
    this.onChange,
    this.validate,
    this.withWidth = false,
    this.readOnly = false,
    this.maxLines,
    this.isEnabled = true,
    this.alignLabel = false,
    this.controller,
    this.errorText = "",
    this.maxLength,
    this.formattedType,
    this.focusNode,
    this.iconColor,
    this.keyboardPadding = false,
    this.autoFocus,
    this.initialValue,
    this.onSubmit,
    this.prefixIcon,
    this.obscureText = false,
    this.onlyBorderColor,
    this.suffixIcon,
    this.customError = false,
    this.withLabel = false,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.withWidth
              ? MediaQueryHelper.width * .8
              : MediaQueryHelper.width,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              color: Styles.FIELD_BORDER,
              border: Border.all(
                  color: widget.alignLabel!
                      ? Styles.PRIMARY_COLOR
                      : Styles.FIELD_BORDER),
              borderRadius: BorderRadius.circular(10.0)),
          height: widget.alignLabelWithHint == null ? 69 : null,
          child: Center(
            child: TextFormField(
              focusNode: widget.focusNode,
              initialValue: widget.initialValue,
              textAlignVertical: TextAlignVertical.top,
              onTap: widget.onTap,
              autofocus: widget.autoFocus ?? false,
              maxLength: widget.maxLength,
              onFieldSubmitted: (v) {
                if (widget.onSubmit != null) {
                  widget.onSubmit!(v);
                }
              },
              readOnly: widget.readOnly,
              obscureText: widget.obscureText!,
              controller: widget.controller,
              maxLines: widget.maxLines,
              validator: widget.validate,
              keyboardType: widget.type,
              onChanged: (String? txt) {
                if (widget.onChange != null) {
                  widget.onChange(txt);
                }
              },
              inputFormatters: widget.formattedType ?? [],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Styles.HEADER,
                fontFamily: widget.type == TextInputType.number ? "text":null
              ),
              scrollPhysics: const BouncingScrollPhysics(),
              scrollPadding: EdgeInsets.only(
                  bottom: widget.keyboardPadding
                      ? MediaQueryHelper.appMediaQueryViewInsets.bottom
                      : 0.0),
              decoration: InputDecoration(
                enabled: widget.isEnabled,
                labelText:
                    widget.withLabel ? widget.label ?? widget.hint : null,
                hintText: widget.hint ?? '',
                alignLabelWithHint:
                    widget.alignLabelWithHint ?? widget.alignLabel!,
                disabledBorder: InputBorder.none,

                labelStyle: TextStyle(
                    color: Styles.HINT,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,

                //    errorText: errorText,
                errorMaxLines: 2,

                floatingLabelStyle: TextStyle(
                    color: widget.alignLabel!
                        ? Styles.PRIMARY_COLOR
                        : Styles.PLACE_HOLDER,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                hintStyle: const TextStyle(
                  color: Styles.PLACE_HOLDER,
                  fontSize: 12.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: widget.icon != null
                    ? Icon(
                        widget.icon,
                        size: 18,
                        color: widget.iconColor ?? Colors.grey[400],
                      )
                    : widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
            ),
          ),
        ),
        widget.customError!
            ? CustomErrorWidget(error: widget.errorText)
            : Container()
      ],
    );
  }
}
