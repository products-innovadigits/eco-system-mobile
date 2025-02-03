import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eco_system/helpers/styles.dart';

class TabWidget extends StatelessWidget {
  const TabWidget(this.data, this.isSelected, this.onClick,
      {Key? key, this.iconPath})
      : super(key: key);
  final String data;
  final bool isSelected;
  final Function() onClick;
  final String? iconPath;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 12),
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       width: isSelected ? 2 : 1,
        //       color: isSelected
        //           ? const Color(0xff5C7AEA)
        //           : const Color(0xffEEEEEE),
        //     ),
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (iconPath != null)
                  SvgPicture.asset(
                    iconPath!,
                    color: isSelected
                        ? const Color(0xff5C7AEA)
                        : const Color(0xffA7A7A7),
                  ),
                if (iconPath != null) SizedBox(width: 4),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xff5C7AEA)
                        : const Color(0xffA7A7A7),
                  ),
                ),
              ],
            ),
              Container(
                width: 28 + (data.length * 8),
                height: 5,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: isSelected? Styles.PRIMARY_COLOR:Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
