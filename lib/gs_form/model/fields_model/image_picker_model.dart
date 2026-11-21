import 'package:flutter/material.dart';

import 'field_model.dart';

class GSImagePickerModel extends GSFieldModel {
  String? hint;
  Widget iconWidget;
  String? cameraPopupTitle;
  String? galleryPopupTitle;
  Widget? cameraPopupIcon;
  Widget? galleryPopupIcon;
  GSImageSource? imageSource;
  double? maximumSizePerImageInKB;
  VoidCallback? onErrorSizeItem;

  GSImagePickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.status,
    super.weight,
    super.showTitle,
    super.value,
    required this.iconWidget,
    this.cameraPopupIcon,
    this.galleryPopupIcon,
    this.cameraPopupTitle,
    this.galleryPopupTitle,
    this.imageSource,
    this.hint,
    this.maximumSizePerImageInKB,
    this.onErrorSizeItem,
  });
}

enum GSImageSource { camera, gallery, both }
