import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/image_picker_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/fields_model/multi_image_picker_model.dart';

// ignore: must_be_immutable
class GSMultiImagePickerField extends StatefulWidget implements GSFieldCallBack {
  final GSMultiImagePickerModel model;
  final GSFormStyle formStyle;

  GSMultiImagePickerField(this.model, this.formStyle, {super.key});
  List<String> _croppedFilePaths = [];

  @override
  State<GSMultiImagePickerField> createState() => _GSMultiImagePickerFieldState();

  @override
  getValue() {
    return _croppedFilePaths;
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return (_croppedFilePaths).isNotEmpty;
    }
  }
}

class _GSMultiImagePickerFieldState extends State<GSMultiImagePickerField> {
  @override
  void initState() {
    super.initState();
    if ((widget.model.defaultImagePath ?? []).isNotEmpty) {
      widget._croppedFilePaths.addAll(widget.model.defaultImagePath ?? []);
    } else {
      widget._croppedFilePaths = [];
    }
  }

  @override
  void didUpdateWidget(covariant GSMultiImagePickerField oldWidget) {
    widget._croppedFilePaths = oldWidget._croppedFilePaths;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: widget._croppedFilePaths.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? SelectItem(
                  model: widget.model,
                  style: widget.formStyle,
                  isEnable: _enableSelectImageButton(),
                  callBack: (imagePath) {
                    widget._croppedFilePaths.add(imagePath);
                    setState(() {});
                  },
                )
              : ImageBox(
                  imagePath: widget._croppedFilePaths[index - 1],
                  onDelete: (value) {
                    widget._croppedFilePaths.removeWhere((element) => element == value);
                    setState(() {});
                  },
                );
        },
      ),
    );
  }

  bool _enableSelectImageButton() {
    if (widget.model.maximumImageCount != null) {
      if (widget._croppedFilePaths.length >= widget.model.maximumImageCount!) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}

class SelectItem extends StatelessWidget {
  const SelectItem({
    required this.model,
    required this.style,
    required this.callBack,
    required this.isEnable,
    super.key,
  });

  final GSMultiImagePickerModel model;
  final GSFormStyle style;
  final ValueChanged<String> callBack;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AbsorbPointer(
        absorbing: !isEnable,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black45, width: 1),
          ),
          height: 90,
          width: 90,
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onTap: () {
              if (model.imageSource == GSImageSource.both) {
                GSFormUtils.showImagePickerBottomSheet(
                  cameraName: model.cameraPopupTitle,
                  galleryName: model.galleryPopupTitle,
                  cameraIcon: model.cameraPopupIcon,
                  galleryIcon: model.galleryPopupIcon,
                  context,
                  (image) async {
                    _fillImagePath(image);
                  },
                );
              } else if (model.imageSource == GSImageSource.camera) {
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
            child: Container(color: isEnable ? Colors.transparent : Colors.black45, child: model.iconWidget),
          ),
        ),
      ),
    );
  }

  void _fillImagePath(File image) {
    final maxKB = model.maximumSizePerImageInKB;
    if (maxKB != null && image.lengthSync() / 1000 >= maxKB) {
      model.onErrorSizeItem?.call();
      return;
    }
    callBack.call(image.path);
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({super.key, required this.imagePath, required this.onDelete});
  final String imagePath;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            clipBehavior: Clip.hardEdge,
            child: imagePath.startsWith('http')
                ? Image.network(imagePath, width: 90, height: 90, fit: BoxFit.fill)
                : Image.file(File(imagePath), width: 90, height: 90, fit: BoxFit.fill),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            child: InkWell(
              onTap: () {
                onDelete.call(imagePath);
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4.0)),
                child: const Icon(Icons.delete_outline, size: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
