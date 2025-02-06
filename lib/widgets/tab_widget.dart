import 'package:flutter/material.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:eco_system/helpers/styles.dart';

class TabWidget extends StatelessWidget {
  const TabWidget(this.data, this.isSelected, this.onClick,
      {super.key, this.iconPath});
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (iconPath != null)
                  Images(
                    image: iconPath!,
                    color: isSelected
                        ? const Color(0xff5C7AEA)
                        : const Color(0xffA7A7A7),
                  ),
                if (iconPath != null) const SizedBox(width: 4),
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
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: isSelected ? Styles.PRIMARY_COLOR : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
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
