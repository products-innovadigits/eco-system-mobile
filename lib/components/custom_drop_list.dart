import 'package:flutter/material.dart';
import 'package:eco_system/helpers/styles.dart';

class CustomDropList extends StatefulWidget {
  final Function? onChanged;

  final List<DropListModel>? list;
  final DropListModel? initialValue;

  const CustomDropList({
    super.key,
    this.onChanged,
    this.list,
    this.initialValue,
  });

  @override
  State<CustomDropList> createState() => _CustomDropListState();
}

/// This is the private State class that goes with CustomDropList.
class _CustomDropListState extends State<CustomDropList> {
  late DropListModel dropdownValue = DropListModel(id: 0, name: "Select One");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Styles.FILL_COLOR,
          border: Border.all(color: Styles.FILL_COLOR)),
      child: DropdownButton<DropListModel>(
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.arrow_drop_down,
            color: Styles.HINT,
          ),
        ),
        iconSize: 24,
        elevation: 16,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                dropdownValue.name!,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: dropdownValue.id != 0 ? Styles.HEADER : Styles.HINT),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
                Text(
                  value.name ?? "",
                  style: const TextStyle(fontSize: 15.0),
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
