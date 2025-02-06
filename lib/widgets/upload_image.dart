import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/helpers/image_picker_helper.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:path/path.dart';
import '../helpers/translation/all_translation.dart';

class UploadImage extends StatefulWidget {
  final ValueChanged? updatedImage;

  final ValueChanged? updateFile;

  final String? label;

  final File? selectedImage;

  const UploadImage({
    super.key,
    required this.updatedImage,
    this.label,
    this.selectedImage,
    this.updateFile,
  });

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image;

  @override
  void initState() {
    if (widget.selectedImage != null) image = widget.selectedImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: image != null ? 192 : 140,
            width: MediaQueryHelper.width,
            decoration: BoxDecoration(
              color: Styles.PRIMARY_COLOR.withOpacity(.1),
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: Image.asset(
                  'assets/images/${image != null ? "uploaded_image" : "upload_image"}.png',
                ).image,
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ImagePickerHelper.showOption(
                      onGet: (file) async {
                        setState(() => image = file);
                        var multipartImage =
                            await MultipartFile.fromFile(image!.path);
                        widget.updatedImage!(multipartImage);
                        widget.updateFile?.call(image);
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.fill,
                            )
                          : customImageIconSVG(imageName: 'blue_gallery'),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  image != null
                      ? "${allTranslations.text("Uploaded")}!"
                      : widget.label != null
                          ? widget.label!
                          : allTranslations.text("Upload Image"),
                  style: const TextStyle(
                    color: Styles.HEADER,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    text: TextSpan(
                      text: image != null
                          ? basename(image!.path)
                          : allTranslations.text('must be less than'),
                      style: AppTextStyles.w400.copyWith(
                        color: Styles.TITLE,
                        fontSize: 11,
                      ),
                      children: [
                        TextSpan(
                          text: image != null ? "" : ' 6MB',
                          style: AppTextStyles.w600.copyWith(
                            color: Styles.TITLE,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Visibility(
                  visible: image != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomBtn(
                            text: allTranslations.text("Change"),
                            onPressed: () {
                              ImagePickerHelper.showOption(onGet: (file) async {
                                setState(() => image = file);
                                var multipartImage =
                                    await MultipartFile.fromFile(image!.path);
                                widget.updatedImage?.call(multipartImage);
                                widget.updateFile?.call(image);
                              });
                            },
                            color: Styles.PRIMARY_COLOR,
                          ),
                          const SizedBox(width: 8.0),
                          CustomBtn(
                            width: 84,
                            text: allTranslations.text("Remove"),
                            height: 31,
                            fontSize: 12,
                            onPressed: () {
                              setState(() => image = null);
                              widget.updatedImage?.call(null);
                              widget.updateFile?.call(null);
                            },
                            color: Styles.IN_ACTIVE.withOpacity(.1),
                            textColor: Styles.IN_ACTIVE,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
