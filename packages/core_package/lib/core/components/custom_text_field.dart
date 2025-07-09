import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class CustomTextField extends StatefulWidget {
  final bool isEdit, isReadOnly, isVisibleText, addBorder;
  final String? label, fontFamily, suffixSvg, prefixSvg, hint, headLabel;
  final Size? size;
  final TextAlign? textAlign;
  final bool? isFilled;
  final bool? isPassword;
  final bool autoFocus;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final FocusNode? focus;
  final TextInputType? type;
  final TextInputAction keyboardAction;
  final VoidCallback? onTap, onChangeVisibility;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final AutovalidateMode autoValidateMode;
  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final double verticalPadding, horizontalPadding;
  final int? maxLines;
  final int? minLines;
  final double? borderWidth, prefixImageHeight, prefixImageWidth;
  final List<TextInputFormatter>? inputFormatters;
  final Color? color, hintColor, borderColor;
  final Widget? suffixWidget, prefixWidget;
  final String? init;
  final TextStyle? headStyle;
  final bool headStart;
  final double headSpace;
  final double? maxSuffixIconHeight;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.init,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.prefixSvg,
    this.type,
    this.controller,
    this.focus,
    this.isEdit = false,
    this.isReadOnly = false,
    this.isVisibleText = true,
    this.keyboardAction = TextInputAction.next,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.suffixSvg,
    this.validation,
    this.label,
    this.fontFamily,
    this.onChangeVisibility,
    this.size,
    this.verticalPadding = 8,
    this.horizontalPadding = 0,
    this.maxLines = 1,
    this.minLines,
    this.color,
    this.inputFormatters,
    this.isFilled,
    this.borderWidth,
    this.autoFocus = false,
    this.textAlign,
    this.isPassword,
    this.hintColor,
    this.headLabel,
    this.suffixIcon,
    this.suffixWidget,
    this.prefixWidget,
    this.addBorder = true,
    this.onSaved,
    this.prefixImageHeight,
    this.prefixImageWidth,
    this.headStyle,
    this.headStart = true,
    this.headSpace = 4,
    this.borderColor,
    this.contentPadding,
    this.maxSuffixIconHeight,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late InputBorder _borders;

  late InputBorder _enabledBorders;

  bool _isHidden = true;

  void _visibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    _borders = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: widget.borderColor ?? context.color.outline,
        width: 1,
      ),
    );

    _enabledBorders = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: widget.borderColor ?? context.color.outline,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: widget.verticalPadding,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: widget.headStart
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  widget.label ?? "",
                  style: widget.headStyle ?? context.textTheme.labelSmall,
                ),
              ),
            if (widget.headLabel != null) SizedBox(height: widget.headSpace),
            TextFormField(
              onFieldSubmitted: widget.onSaved,
              textAlign: widget.textAlign ?? TextAlign.start,
              validator: widget.validation,
              autovalidateMode: widget.autoValidateMode,
              controller: widget.controller,
              autofocus: widget.autoFocus,
              focusNode: widget.focus,
              initialValue: widget.init,
              readOnly: widget.onTap != null ? true : widget.isReadOnly,
              enabled: widget.onTap != null ? false : !widget.isReadOnly,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              obscureText: widget.isPassword == true ? _isHidden : false,
              keyboardType: widget.type,
              textInputAction: widget.keyboardAction,
              onChanged: (v) {
                widget.onChanged?.call(v);
              },
              onTapOutside: (v) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              inputFormatters: widget.type == TextInputType.phone
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(11),
                    ]
                  : widget.inputFormatters,
              style: context.textTheme.labelLarge,
              decoration: InputDecoration(
                fillColor: widget.color ?? context.color.surfaceContainer,
                errorStyle: TextStyle(color: context.color.error),
                contentPadding:
                    widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                prefixIconConstraints: BoxConstraints(maxHeight: 35),
                suffixIconConstraints: BoxConstraints(
                  maxHeight: widget.maxSuffixIconHeight ?? 35,
                ),
                hintText: widget.hint,
                // labelText: widget.label,
                alignLabelWithHint: true,
                prefixIcon:
                    widget.prefixWidget ??
                    (widget.prefixSvg != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: customImageIconSVG(
                              imageName: widget.prefixSvg ?? "",
                              height: widget.prefixImageHeight ?? 18,
                              width: widget.prefixImageHeight ?? 18,
                              color: widget.controller == null
                                  ? context.color.outlineVariant
                                  : (widget.controller!.text.isEmpty)
                                  ? context.color.outlineVariant
                                  : context.color.primary,
                            ),
                          )
                        : null),
                errorMaxLines: 2,
                icon: widget.prefixIcon != null
                    ? Icon(widget.isEdit ? Icons.edit : widget.prefixIcon)
                    : null,
                // labelStyle: TextStyle(
                //   fontSize: 14,
                //   color: widget.hintColor ?? Styles.HINT,
                //   fontWeight: FontWeight.w400,
                // ),
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: widget.hintColor ?? context.color.outlineVariant,
                ),
                suffixIcon:
                    widget.suffixWidget ??
                    (widget.suffixIcon != null
                        ? Icon(widget.suffixIcon, size: 18)
                        : widget.suffixSvg != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: customImageIconSVG(
                              imageName: widget.suffixSvg!,
                              height: 18,
                              width: 18,
                              color: widget.controller!.text.isEmpty
                                  ? context.color.primary.withValues(alpha: 0.5)
                                  : context.color.primary,
                            ),
                          )
                        : widget.isPassword == true
                        ? IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            onPressed: _visibility,
                            alignment: Alignment.center,
                            icon: _isHidden
                                ? customImageIconSVG(
                                    imageName: "hide",
                                    height: 18.0,
                                    width: 18.0,
                                    color: context.color.primary,
                                  )
                                : customImageIconSVG(
                                    imageName: "show",
                                    height: 18.0,
                                    width: 18.0,
                                    color: context.color.primary,
                                  ),
                          )
                        : null),
                filled: widget.isFilled ?? true,

                // fillColor: color,
                enabledBorder: !widget.addBorder
                    ? _enabledBorders.copyWith(
                        borderSide: BorderSide(color: context.color.surfaceContainer),
                      )
                    : _enabledBorders.copyWith(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? context.color.outline,
                          // (widget.controller?.text.isNotEmpty ?? false)
                          //     ? Styles.PRIMARY_COLOR
                          //     : Styles.HINT_COLOR,
                          width: 1,
                          style: widget.borderWidth == 0
                              ? BorderStyle.none
                              : BorderStyle.solid,
                        ),
                      ),
                disabledBorder: !widget.addBorder
                    ? null
                    : _borders.copyWith(
                        borderSide: BorderSide(
                          width: widget.borderWidth ?? 1,
                          color: widget.borderColor ?? context.color.outlineVariant,
                        ),
                      ),
                focusedBorder: _borders.copyWith(
                  borderSide: widget.addBorder
                      ? null
                      : BorderSide(width: 1, color: context.color.primary),
                ),
                errorBorder: !widget.addBorder
                    ? null
                    : _borders.copyWith(
                        borderSide: BorderSide(
                          width: widget.borderWidth ?? 1,
                          color: context.color.error,
                        ),
                      ),
                border: !widget.addBorder
                    ? null
                    : _borders.copyWith(
                        borderSide: BorderSide(width: widget.borderWidth ?? 1),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
