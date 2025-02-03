import 'dart:io';

import 'package:dio/dio.dart';
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

  const UploadImage(
      {Key? key,
      required this.updatedImage,
      this.label,
      this.selectedImage,
      this.updateFile})
      : super(key: key);

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
                          'assets/images/${image != null ? "uploaded_image" : "upload_image"}.png')
                      .image,
                  fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ImagePickerHelper.showOption(onGet: (file) async {
                      setState(() => image = file);
                      var multipartImage =
                          await MultipartFile.fromFile(image!.path);
                      widget.updatedImage!(multipartImage);
                      if (widget.updateFile != null) widget.updateFile!(image);
                    });
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
                SizedBox(
                  height: 6,
                ),
                Text(
                  image != null
                      ? "${allTranslations.text("Uploaded")}!"
                      : widget.label != null
                          ? widget.label!
                          : allTranslations.text("Upload Image"),
                  style: TextStyle(
                      color: Styles.HEADER,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    text: TextSpan(
                        text: image != null
                            ? basename(image!.path)
                            : allTranslations.text('must be less than'),
                        style: TextStyle(
                            color: Styles.SUB_HEADER,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: image != null ? "" : ' 6MB',
                              style: TextStyle(
                                  color: Styles.HEADER,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600))
                        ]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Visibility(
                  visible: image != null,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomBtn(
                            text: allTranslations.text("Change"),
                            btnHeight: 31,
                            btnWidth: 84,
                            txtFontSize: 12,
                            onTap: () {
                              ImagePickerHelper.showOption(onGet: (file) async{
                                setState(() => image = file);
                                var multipartImage =
                                    await MultipartFile.fromFile(image!.path);
                                widget.updatedImage!(multipartImage);
                                if (widget.updateFile != null) widget.updateFile!(image);
                              });
                            },
                            color: Styles.PRIMARY_COLOR,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          CustomBtn(
                            btnWidth: 84,
                            text: allTranslations.text("Remove"),
                            btnHeight: 31,
                            txtFontSize: 12,
                            onTap: () {
                              setState(() => image = null);
                              widget.updatedImage!(null);
                              if (widget.updateFile != null)
                                widget.updateFile!(null);
                            },
                            color: Styles.IN_ACTIVE.withOpacity(.1),
                            txtColor: Styles.IN_ACTIVE,
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
