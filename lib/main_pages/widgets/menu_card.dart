import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/main_pages/models/menu_model.dart';
import 'package:eco_system/helpers/styles.dart';
class MenuCard extends StatelessWidget {
  final MenuModel? model ;
  const MenuCard({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: model!.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0 , vertical: 8.0),
        child: Container(
          height: 98,
          decoration: BoxDecoration(
            color: model!.isLogout!? Styles.CARD_BORDER.withOpacity(.1) :Styles.CARD_BORDER,
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: customImageIconSVG(
                    imageName: model!.imageName
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(model!.title!,
                  style: const TextStyle(
                      color: Styles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
