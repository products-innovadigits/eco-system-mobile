import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/core/app_core.dart';
import 'package:eco_system/core/app_notification.dart';
import 'package:eco_system/components/confirm_bottom_sheet.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/bloc/main_app_bloc.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/utility.dart';
import 'package:intl/intl.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';

import '../helpers/text_styles.dart';

class SelectDate extends StatelessWidget {
  final Stream<DateTime?>? dateStream;
  final DateTime? startDate;
  final Function? updateDateStart;
  final Function? updateDateEnd;
  final Function? updateSearch;
  final bool? isStart;

  const SelectDate({
    super.key,
    this.dateStream,
    this.updateDateStart,
    this.updateDateEnd,
    this.updateSearch,
    this.isStart = false,
    this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime?>(
      stream: dateStream,
      builder: (context, snapshot) {
        String date0 = "";
        if (snapshot.hasData) {
          date0 = DateFormat(Constants.DATE_FORMAT).format(snapshot.data!);
        } else {
          date0 = isStart!
              ? allTranslations.text('start_date')
              : allTranslations.text('end_date');
        }
        return InkWell(
          onTap: () async {
            try {
              DateTime? date = snapshot.data ?? DateTime.now();
              if (isStart! || startDate != null) {
                CustomBottomSheet.show(
                  label: 'Select Date',
                  height: 360,
                  onConfirm: () {
                    if (date != null) {
                      if (isStart!) {
                        updateDateStart?.call(date);
                      } else {
                        log('Select End Date');
                        updateDateEnd!(date);
                      }
                      updateSearch!(true);
                      CustomNavigator.pop();
                    }
                  },
                  widget: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      date = value;
                    },
                    initialDateTime: snapshot.data ?? DateTime.now(),
                    minimumDate: startDate ?? DateTime(2010),
                    maximumDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  ),
                );
              } else {
                AppCore.showSnackBar(
                  notification: AppNotification(
                    message: 'Please enter start date first',
                  ),
                );
              }
            } catch (e) {
              cprint(e);
              updateDateEnd!(startDate);
              AppCore.showSnackBar(
                notification: AppNotification(
                  message:
                      "It is not failed chosen values must end data greater than or equal to minimumDate",
                ),
              );
            }
          },
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Styles.FILL_COLOR,
              border: Border.all(color: Styles.LIGHT_GREY_BORDER, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                child: Text(
                  date0,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Styles.TITLE,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomSelectDate extends StatefulWidget {
  final String? initialString;
  final bool? isNotEmptyValue;
  final bool? showOnly;
  final DateTime? startDateTime;
  final ValueChanged<DateTime>? valueChanged;

  const CustomSelectDate({
    super.key,
    this.initialString,
    required this.valueChanged,
    this.isNotEmptyValue = false,
    this.showOnly = false,
    this.startDateTime,
  });

  @override
  State<CustomSelectDate> createState() => _CustomSelectDateState();
}

class _CustomSelectDateState extends State<CustomSelectDate> {
  String _date = "";
  DateTime? date;

  @override
  void initState() {
    _date = widget.initialString ?? allTranslations.text("select_date");
    cprint(widget.initialString!);
    if (widget.isNotEmptyValue!) {
      date = DateTime.parse(widget.initialString!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!widget.showOnly!) {
          cprint(date);
          CustomBottomSheet.show(
              label: allTranslations.text('select_date'),
              height: 360,
              onConfirm: () {
                if (date != null) {
                  setState(() =>
                      _date = DateFormat(Constants.DATE_FORMAT).format(date!));
                  widget.valueChanged!(date!);
                  CustomNavigator.pop();
                } else {
                  setState(() => _date =
                      DateFormat(Constants.DATE_FORMAT).format(DateTime.now()));
                  widget.valueChanged!(DateTime.now());
                  CustomNavigator.pop();
                }
              },
              widget: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (value) {
                  date = value;
                },
                initialDateTime: date ?? widget.startDateTime ?? DateTime.now(),
                minimumDate: widget.startDateTime != null
                    ? DateTime(widget.startDateTime!.year,
                        widget.startDateTime!.month, widget.startDateTime!.day)
                    : DateTime(1900),
                maximumDate: DateTime(2100),
              ));
        }
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: MediaQueryHelper.width,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: Styles.FIELD_BORDER,
            border: Border.all(color: Styles.FIELD_BORDER),
            // border: Border.all(
            //     color:
            //         date != null ? Styles.PRIMARY_COLOR : Styles.FIELD_BORDER),
            borderRadius: BorderRadius.circular(10.0)),
        height: widget.isNotEmptyValue!
            ? 69
            : date != null
                ? 69
                : 58,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _date,
                    style: TextStyle(
                        fontSize: widget.isNotEmptyValue!
                            ? 10
                            : date != null
                                ? 10
                                : 12,
                        fontFamily: widget.isNotEmptyValue!
                            ? "text"
                            : date != null
                                ? "text"
                                : mainAppBloc.lang.valueOrNull,
                        fontWeight: widget.isNotEmptyValue!
                            ? FontWeight.w600
                            : date != null
                                ? FontWeight.w600
                                : FontWeight.w600,
                        color: widget.isNotEmptyValue!
                            ? Styles.HEADER
                            : date != null
                                ? Styles.HEADER
                                : Styles.HINT),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                customImageIconSVG(imageName: 'calendar')
              ],
            )),
      ),
    );
  }
}

class DashboardSelectDate extends StatefulWidget {
  final String? initialString;
  final ValueChanged<DateTime>? valueChanged;

  const DashboardSelectDate({
    super.key,
    this.initialString,
    this.valueChanged,
  });

  @override
  State<DashboardSelectDate> createState() => _DashboardSelectDateState();
}

class _DashboardSelectDateState extends State<DashboardSelectDate> {
  String _date = "";
  DateTime? date;

  @override
  void initState() {
    _date = widget.initialString ?? allTranslations.text("select_date");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        date = DateTime.now();
        CustomBottomSheet.show(
            label: allTranslations.text('select_date'),
            height: 360,
            onConfirm: () {
              if (date != null) {
                setState(() => _date = DateFormat(
                        DateFormat.YEAR_MONTH, mainAppBloc.lang.valueOrNull)
                    .format(date!));
                widget.valueChanged!(date!);
                CustomNavigator.pop();
              }
            },
            widget: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                date = value;
              },
              initialDateTime: date ?? DateTime.now(),
              minimumDate: DateTime(2010),
              maximumDate: DateTime(2100),
            ));
      },
      child: Row(
        children: [
          Text(_date,
              style: AppTextStyles.SCREEN_TITLE
                  .copyWith(color: Styles.LIGHT_BLUE, fontSize: 12)),
          const SizedBox(
            width: 4,
          ),
          const Icon(Icons.arrow_drop_down, color: Styles.WHITE_COLOR)
        ],
      ),
    );
  }
}
