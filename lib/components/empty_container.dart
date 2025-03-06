import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';

class EmptyContainer extends StatelessWidget {
  final String? img;
  final String? txt;
  final String? subText;
  final double? remain;
  final TextStyle? subStyle;

  const EmptyContainer(
      {super.key,
      this.img,
      this.txt,
      this.remain = 200.0,
      this.subText,
      this.subStyle});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQueryHelper.height - remain!,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                img ?? 'assets/images/empty_image.png',
                width: MediaQueryHelper.width * .8,
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  txt ?? "No Data Yet !",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subText ?? "",
                textAlign: TextAlign.center,
                style: subStyle ?? Styles.SUB_HEADER_STYLE,
              )
            ],
          ),
        ),
      ),
    );
  }
}
