import 'dart:io';
import 'package:eco_system/bloc/main_app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../components/custom_images.dart';
import '../components/custom_network_image.dart';
import '../core/app_state.dart';
import '../helpers/image_picker_helper.dart';
import '../helpers/styles.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget(
      {this.withEdit = false,
      this.radius = 35,
      super.key,
      this.onGet,
      this.onTap,
      this.imageFile,
      this.image});

  final bool withEdit;
  final Function(File)? onGet;
  final File? imageFile;
  final double radius;
  final String? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap?.call();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        imageFile!,
                        height: radius * 2,
                        width: radius * 2,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                            child: Container(
                                height: radius * 2,
                                width: radius * 2,
                                color: Colors.grey,
                                child: const Center(
                                    child: Icon(Icons.replay,
                                        color: Colors.green)))),
                      ),
                    )
                  : image != null
                      ? CustomNetworkImage.circleNewWorkImage(
                          color: Styles.HINT, image: image, radius: radius)
                      : customCircleSvgIcon(
                          radius: radius,
                          imageName: "user",
                          color: Styles.PRIMARY_COLOR),
              if (withEdit)
                Positioned(
                  bottom: 0,
                  left: mainAppBloc.lang.valueOrNull == "en" ? null : 0,
                  right: mainAppBloc.lang.valueOrNull == "ar" ? 0 : null,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (withEdit) {
                        ImagePickerHelper.showOption(onGet: onGet);
                      }
                    },
                    child: Container(
                        height: 24,
                        width: 24,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: Styles.WHITE_COLOR,
                            borderRadius: BorderRadius.circular(100)),
                        child: customImageIconSVG(
                          imageName: "camera",
                          color: Styles.PRIMARY_COLOR,
                        )),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
