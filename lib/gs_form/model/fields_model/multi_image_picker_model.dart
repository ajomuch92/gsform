import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/model/fields_model/image_picker_model.dart';

import 'field_model.dart';

class GSMultiImagePickerModel extends GSFieldModel {
  String? hint;
  Widget iconWidget;
  String? cameraPopupTitle;
  String? galleryPopupTitle;
  Widget? cameraPopupIcon;
  Widget? galleryPopupIcon;
  GSImageSource? imageSource;
  List<String>? defaultImagePath;
  double? maximumSizePerImageInKB;
  double? maximumImageCount;
  VoidCallback? onErrorSizeItem;

  GSMultiImagePickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.status,
    super.weight,
    super.showTitle,
    required this.iconWidget,
    this.maximumImageCount,
    this.onErrorSizeItem,
    this.maximumSizePerImageInKB,
    this.defaultImagePath,
    this.cameraPopupIcon,
    this.galleryPopupIcon,
    this.cameraPopupTitle,
    this.galleryPopupTitle,
    this.imageSource,
    this.hint,
  });
}
