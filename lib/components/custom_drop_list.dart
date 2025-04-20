import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CustomDropList extends StatefulWidget {
  final Function(DropListModel)? onChanged;
  final String? hint;
  final List<DropListModel>? list;
  final DropListModel? initialValue;
  final List<DropListModel>? selectedList;

  const CustomDropList({
    super.key,
    this.onChanged,
    this.list,
    this.initialValue,
    this.hint,
    this.selectedList,
  });

  @override
  State<CustomDropList> createState() => _CustomDropListState();
}

/// This is the private State class that goes with CustomDropList.
class _CustomDropListState extends State<CustomDropList> {
  late DropListModel dropdownValue = DropListModel(
      id: 0, name: widget.hint ?? allTranslations.text(LocaleKeys.select));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Styles.BORDER)),
      child: DropdownButton<DropListModel>(
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Images(image: Assets.svgs.arrowDown.path),
        ),
        iconSize: 24,
        elevation: 16,
        hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dropdownValue.name!,
                    style: AppTextStyles.w400.copyWith(
                        fontSize: 12.0,
                        color:
                            dropdownValue.id != 0 ? Styles.HEADER : Styles.HINT),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )),
        isExpanded: true,
        onChanged: (DropListModel? newValue) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            dropdownValue = newValue!;
          });
          widget.onChanged!(dropdownValue);
        },
        underline: Container(),
        items: widget.list!.map((DropListModel value) {
          return DropdownMenuItem<DropListModel>(
            value: value,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.name ?? "",
                    style: AppTextStyles.w400.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DropListModel {
  final int? id;
  final String? name;
  final int? value;

  DropListModel({this.id, this.name, this.value});
}
