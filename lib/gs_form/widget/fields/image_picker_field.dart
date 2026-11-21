import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/image_picker_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';
import 'package:gsform_plus/gs_form/values/colors.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class GSImagePickerField extends StatefulWidget implements GSFieldCallBack {
  final GSImagePickerModel model;
  final GSFormStyle formStyle;

  GSImagePickerField(this.model, this.formStyle, {super.key});
  String? _croppedFilePath;

  @override
  State<GSImagePickerField> createState() => _GSImagePickerFieldState();

  @override
  getValue() {
    return _croppedFilePath;
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return _croppedFilePath != null;
    }
  }
}

class _GSImagePickerFieldState extends State<GSImagePickerField> {
  @override
  void initState() {
    super.initState();
    if (widget.model.value != null) {
      widget._croppedFilePath = widget.model.value;
    } else {
      widget._croppedFilePath = null;
    }
  }

  @override
  void didUpdateWidget(covariant GSImagePickerField oldWidget) {
    widget._croppedFilePath = widget.model.value != oldWidget.model.value
        ? widget.model.value
        : oldWidget._croppedFilePath;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onTap: () {
          if (widget.model.imageSource == GSImageSource.both) {
            GSFormUtils.showImagePickerBottomSheet(
              cameraName: widget.model.cameraPopupTitle,
              galleryName: widget.model.galleryPopupTitle,
              cameraIcon: widget.model.cameraPopupIcon,
              galleryIcon: widget.model.galleryPopupIcon,
              context,
              (image) async {
                _fillImagePath(image);
              },
            );
          } else if (widget.model.imageSource == GSImageSource.camera) {
            GSFormUtils.pickImage(ImageSource.camera).then((imageFile) {
              if (imageFile != null) {
                _fillImagePath(imageFile);
              }
            });
          } else {
            GSFormUtils.pickImage(ImageSource.gallery).then((imageFile) {
              if (imageFile != null) {
                _fillImagePath(imageFile);
              }
            });
          }
        },
        child: widget._croppedFilePath == null
            ? NormalView(model: widget.model, formStyle: widget.formStyle)
            : ImagePickedView(
                croppedFilePath: widget._croppedFilePath!,
                model: widget.model,
                formStyle: widget.formStyle,
                onDeleteImage: () {
                  widget._croppedFilePath = null;
                  setState(() {});
                },
              ),
      ),
    );
  }

  void _fillImagePath(File image) {
    final maxKB = widget.model.maximumSizePerImageInKB;
    if (maxKB != null && image.lengthSync() / 1000 >= maxKB) {
      widget.model.onErrorSizeItem?.call();
      return;
    }
    setState(() => widget._croppedFilePath = image.path);
  }
}

class NormalView extends StatelessWidget {
  const NormalView({required this.model, required this.formStyle, super.key});
  final GSImagePickerModel model;
  final GSFormStyle formStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          model.iconWidget,
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: model.required ?? false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, left: 4),
                  child: Text(formStyle.requiredText, style: const TextStyle(color: GSFormColors.red, fontSize: 10)),
                ),
              ),
              Text(model.title ?? '', style: formStyle.titleTextStyle),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(model.hint ?? '', style: formStyle.fieldHintStyle),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImagePickedView extends StatelessWidget {
  String croppedFilePath;
  final GSImagePickerModel model;
  final GSFormStyle formStyle;
  final VoidCallback onDeleteImage;

  ImagePickedView({
    required this.croppedFilePath,
    super.key,
    required this.model,
    required this.formStyle,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.file(File(croppedFilePath), fit: BoxFit.contain)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(11.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      Text(model.title ?? '', style: formStyle.titleTextStyle.copyWith(color: Colors.white)),
                      const Spacer(),
                      SizedBox(
                        height: 20.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            onDeleteImage.call();
                          },
                          child: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
