import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/enums/field_status.dart';
import 'package:gsform_plus/gs_form/enums/filed_type.dart';
import 'package:gsform_plus/gs_form/model/data_model/check_data_model.dart';
import 'package:gsform_plus/gs_form/model/data_model/date_data_model.dart';
import 'package:gsform_plus/gs_form/model/data_model/radio_data_model.dart';
import 'package:gsform_plus/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/bank_card_filed_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/checkbox_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/date_picker_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/date_range_picker_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/email_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/image_picker_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/mobile_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/multi_image_picker_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/number_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/price_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/qr_scanner_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/radio_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/spinner_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/text_filed_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/text_password_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/text_plain_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/time_picker_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';
import 'package:gsform_plus/gs_form/values/colors.dart';
import 'package:gsform_plus/gs_form/values/theme.dart';
import 'package:gsform_plus/gs_form/widget/fields/bank_card_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/check_list_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/date_picker_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/date_range_picker_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/email_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/image_picker_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/mobile_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/number_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/password_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/price_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/qr_scanner_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/radio_group_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/spinner_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_plain_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/time_picker_field.dart';

import '../enums/required_check_list_enum.dart';
import 'fields/multi_image_picker_field.dart';

// ignore: must_be_immutable
class GSField extends StatefulWidget {
  GSFieldModel? model;
  Widget? child;
  GSFormStyle? formStyle;

  VoidCallback? onUpdate;

  void update() {
    onUpdate?.call();
  }

  //<editor-fold desc="Component Constructors">

  GSField.qrScanner({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    String? hint,
    Widget? iconWidget,
    Color? iconColor,
    bool? enableReadOnly,
  }) {
    model = GSQRScannerModel(
      type: GSFieldTypeEnum.qrScanner,
      tag: tag,
      showTitle: showTitle ?? false,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      enableReadOnly: enableReadOnly,
    );
  }

  GSField.imagePicker({
    super.key,
    required String tag,
    required Widget iconWidget,
    String? defaultImagePathValue,
    String? title,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    String? hint,
    String? cameraPopupTitle,
    String? galleryPopupTitle,
    Widget? cameraPopupIcon,
    Widget? galleryPopupIcon,
    GSImageSource? imageSource,
    Color? iconColor,
    double? maximumSizePerImageInKB,
    VoidCallback? onErrorSizeItem,
  }) {
    model = GSImagePickerModel(
      type: GSFieldTypeEnum.imagePicker,
      tag: tag,
      imageSource: imageSource ?? GSImageSource.both,
      showTitle: showTitle ?? false,
      title: title,
      cameraPopupTitle: cameraPopupTitle,
      galleryPopupTitle: galleryPopupTitle,
      cameraPopupIcon: cameraPopupIcon,
      galleryPopupIcon: galleryPopupIcon,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      value: defaultImagePathValue,
      maximumSizePerImageInKB: maximumSizePerImageInKB,
      onErrorSizeItem: onErrorSizeItem,
    );
  }

  GSField.multiImagePicker({
    super.key,
    required String tag,
    required Widget iconWidget,
    List<String>? defaultImagePathValues,
    String? title,
    String? errorMessage,
    String? helpMessage,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    String? hint,
    String? cameraPopupTitle,
    String? galleryPopupTitle,
    Widget? cameraPopupIcon,
    Widget? galleryPopupIcon,
    GSImageSource? imageSource,
    Color? iconColor,
    double? maximumSizePerImageInKB,
    double? maximumImageCount,
    VoidCallback? onErrorSizeItem,
  }) {
    model = GSMultiImagePickerModel(
      type: GSFieldTypeEnum.multiImagePicker,
      tag: tag,
      imageSource: imageSource ?? GSImageSource.both,
      showTitle: showTitle ?? false,
      title: title,
      cameraPopupTitle: cameraPopupTitle,
      galleryPopupTitle: galleryPopupTitle,
      cameraPopupIcon: cameraPopupIcon,
      galleryPopupIcon: galleryPopupIcon,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      iconWidget: iconWidget,
      defaultImagePath: defaultImagePathValues,
      maximumImageCount: maximumImageCount,
      maximumSizePerImageInKB: maximumSizePerImageInKB,
      onErrorSizeItem: onErrorSizeItem,
    );
  }

  GSField.spinner({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    SpinnerDataModel? value,
    ValueChanged<SpinnerDataModel?>? onChange,
    required List<SpinnerDataModel> items,
    String? hint,
  }) {
    model = GSSpinnerModel(
      type: GSFieldTypeEnum.spinner,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      required: required,
      status: status,
      weight: weight,
      items: items,
      hint: hint,
      onChange: onChange,
      value: value,
    );
  }

  GSField.radioGroup({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    String? hint,
    Axis? scrollDirection,
    Widget? selectedIcon,
    Widget? unSelectedIcon,
    bool? scrollable,
    double? height,
    bool? showScrollBar,
    Color? scrollBarColor,
    required bool searchable,
    String? searchHint,
    Icon? searchIcon,
    BoxDecoration? searchBoxDecoration,
    required List<RadioDataModel> items,
    required ValueChanged<RadioDataModel> callBack,
  }) {
    model = GSRadioModel(
      type: GSFieldTypeEnum.radioGroup,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: required,
      status: status,
      weight: weight,
      showScrollBar: showScrollBar,
      scrollBarColor: scrollBarColor,
      hint: hint,
      items: items,
      callBack: callBack,
      scrollDirection: scrollDirection,
      unSelectedIcon: unSelectedIcon,
      selectedIcon: selectedIcon,
      scrollable: scrollable ?? false,
      height: height,
      searchable: searchable,
      searchHint: searchHint,
      searchIcon: searchIcon,
      searchBoxDecoration: searchBoxDecoration,
    );
  }

  GSField.checkList({
    super.key,
    required String tag,
    required bool searchable,
    required List<CheckDataModel> items,
    required ValueChanged<CheckDataModel> callBack,
    RequiredCheckListEnum? requiredCheckListEnum,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateRegEx,
    String? hint,
    Axis? scrollDirection,
    Widget? selectedIcon,
    Widget? unSelectedIcon,
    bool? scrollable,
    double? height,
    bool? showScrollBar,
    Color? scrollBarColor,
    String? searchHint,
    Icon? searchIcon,
    BoxDecoration? searchBoxDecoration,
  }) {
    bool isRequired = false;
    if (requiredCheckListEnum != null && requiredCheckListEnum != RequiredCheckListEnum.none) {
      isRequired = true;
    }
    model = GSCheckBoxModel(
      type: GSFieldTypeEnum.checkList,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      required: isRequired,
      status: status,
      weight: weight,
      showScrollBar: showScrollBar,
      scrollBarColor: scrollBarColor,
      hint: hint,
      items: items,
      callBack: callBack,
      scrollDirection: scrollDirection,
      unSelectedIcon: unSelectedIcon,
      selectedIcon: selectedIcon,
      scrollable: scrollable ?? false,
      height: height,
      searchable: searchable,
      searchHint: searchHint,
      searchIcon: searchIcon,
      searchBoxDecoration: searchBoxDecoration,
      requiredCheckListEnum: requiredCheckListEnum,
    );
  }

  GSField.text({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? readOnly,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    model = GSTextModel(
      type: GSFieldTypeEnum.text,
      tag: tag,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      validateRegEx: validateRegEx,
    );
  }

  GSField.password({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    int? minLine,
    int? maxLine,
    bool? isEnable,
    String? hint,
    bool? readOnly,
  }) {
    model = GSPasswordModel(
      type: GSFieldTypeEnum.password,
      showTitle: showTitle ?? true,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      hint: hint,
      maxLength: maxLength,
      enableReadOnly: readOnly,
      validateReg: validateReg,
    );
  }

  GSField.textPlain({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    int? minLine,
    int? maxLine,
    String? hint,
    bool? showCounter,
    bool? readOnly,
  }) {
    model = GSTextPlainModel(
      type: GSFieldTypeEnum.textPlain,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      hint: hint,
      maxLine: maxLine,
      minLine: minLine,
      maxLength: maxLength,
      showCounter: showCounter,
      enableReadOnly: readOnly,
      validateRegEx: validateRegEx,
    );
  }

  GSField.mobile({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
  }) {
    model = GSMobileModel(
      type: GSFieldTypeEnum.mobile,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      showTitle: showTitle ?? true,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      validateReg: validateRegEx,
    );
  }

  GSField.number({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    bool? showTitle,
    bool? showCounter,
    String? hint,
    bool? readOnly,
  }) {
    model = GSNumberModel(
      type: GSFieldTypeEnum.number,
      showTitle: showTitle ?? true,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      showCounter: showCounter,
      enableReadOnly: readOnly,
      validateRegEx: validateRegEx,
    );
  }

  GSField.datePicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    GSDateFormatType? displayDateType,
    bool? isPastAvailable,
    GSDate? initialDate,
    GSDate? availableFrom,
    GSDate? availableTo,
  }) {
    model = GSDatePickerModel(
      type: GSFieldTypeEnum.date,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      showTitle: showTitle ?? true,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      isPastAvailable: isPastAvailable,
      dateFormatType: displayDateType,
      initialDate: initialDate,
      availableFrom: availableFrom,
      availableTo: availableTo,
    );
  }

  GSField.dateRangePicker({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    String? from,
    String? to,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    GSDateFormatType? displayDateType,
    bool? isPastAvailable,
    GSDate? initialStartDate,
    GSDate? initialEndDate,
    GSDate? availableFrom,
    GSDate? availableTo,
  }) {
    model = GSDateRangePickerModel(
      type: GSFieldTypeEnum.dateRage,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      from: from ?? 'From',
      to: to ?? 'To',
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      showTitle: showTitle ?? true,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      isPastAvailable: isPastAvailable,
      dateFormatType: displayDateType,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      availableFrom: availableFrom,
      availableTo: availableTo,
    );
  }

  GSField.time({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? showTitle,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    RegExp? validateReg,
    int? maxLength,
    String? hint,
    TimeOfDay? initialTime,
  }) {
    model = GSTimePickerModel(
      type: GSFieldTypeEnum.time,
      tag: tag,
      showTitle: showTitle ?? true,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      weight: weight,
      hint: hint,
      initialTime: initialTime,
    );
  }

  GSField.email({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
  }) {
    model = GSEmailModel(
      type: GSFieldTypeEnum.email,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      validateRegEx: validateRegEx,
    );
  }

  GSField.price({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    String? currencyName,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? maxLength,
    String? hint,
    bool? readOnly,
  }) {
    model = GSPriceModel(
      type: GSFieldTypeEnum.price,
      tag: tag,
      title: title,
      showTitle: showTitle ?? true,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: Text(currencyName ?? '', style: GSFormTheme.textThemeStyle.displaySmall),
      required: required,
      status: status,
      value: value,
      weight: weight,
      maxLength: maxLength,
      hint: hint,
      enableReadOnly: readOnly,
      validateRegEx: validateRegEx,
    );
  }

  GSField.bankCard({
    super.key,
    required String tag,
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    GSFieldStatusEnum? status,
    String? value,
    int? weight,
    RegExp? validateRegEx,
    int? minLine,
    int? maxLine,
    String? hint,
  }) {
    model = GSBankCardModel(
      type: GSFieldTypeEnum.bankCard,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      prefixWidget: prefixWidget,
      postfixWidget: postfixWidget,
      required: required,
      status: status,
      showTitle: showTitle ?? true,
      value: value,
      weight: weight,
      hint: hint,
      validateRegEx: validateRegEx,
    );
  }

  //</editor-fold>

  @override
  State<GSField> createState() => _GSFieldState();
}

class _GSFieldState extends State<GSField> {
  @override
  void didUpdateWidget(covariant GSField oldWidget) {
    _fillChild();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _fillChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.formStyle = widget.formStyle ?? GSFormStyle();
    widget.onUpdate = () {
      if (mounted) {
        if (widget.model?.status != GSFieldStatusEnum.disabled) {
          setState(() {});
        }
      }
    };

    return AbsorbPointer(
      absorbing: widget.model?.status == GSFieldStatusEnum.disabled,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: widget.model?.showTitle ?? false,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(widget.model?.title ?? "", style: widget.formStyle!.titleTextStyle),
                          const SizedBox(width: 4.0),
                          Opacity(
                            opacity: widget.model?.required ?? false ? 1 : 0,
                            child: Text(
                              widget.formStyle!.requiredText,
                              style: const TextStyle(color: GSFormColors.red, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                    ],
                  ),
                ),
                Container(
                  decoration: GSFormUtils.getFieldDecoration(widget.formStyle!, widget.model?.status),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.model?.prefixWidget == null ? false : true,
                        child: Row(
                          children: [
                            const SizedBox(width: 8.0),
                            widget.model?.prefixWidget ?? const SizedBox(width: 0),
                            const SizedBox(width: 8.0),
                            Container(height: 30.0, color: GSFormColors.dividerColor, width: 1.0),
                          ],
                        ),
                      ),
                      Expanded(child: widget.child!),
                      Visibility(
                        visible: widget.model?.postfixWidget == null ? false : true,
                        child: Row(
                          children: [
                            const SizedBox(width: 10.0),
                            widget.model?.postfixWidget ?? const SizedBox(width: 0),
                            const SizedBox(width: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Opacity(
                  opacity:
                      (widget.model?.status == GSFieldStatusEnum.error && widget.model?.errorMessage != null) ||
                          widget.model?.helpMessage != null
                      ? 1
                      : 0,
                  child: Row(
                    children: [
                      Icon(
                        widget.model?.status == GSFieldStatusEnum.error ? Icons.error_outline : Icons.info_outline,
                        size: 9.0,
                        color: widget.model?.status == GSFieldStatusEnum.error
                            ? widget.formStyle!.errorTextStyle.color
                            : widget.formStyle!.helpTextStyle.color,
                      ),
                      const SizedBox(width: 1.0),
                      Text(
                        widget.model?.status == GSFieldStatusEnum.error
                            ? widget.model?.errorMessage ?? ''
                            : widget.model?.helpMessage ?? '',
                        style: widget.model?.status == GSFieldStatusEnum.error
                            ? widget.formStyle!.errorTextStyle
                            : widget.formStyle!.helpTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _fillChild() {
    widget.formStyle ??= GSFormStyle();
    switch (widget.model?.type) {
      case GSFieldTypeEnum.text:
        widget.child = GSTextField(widget.model as GSTextModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.number:
        widget.child = GSNumberField(widget.model as GSNumberModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.textPlain:
        widget.child = GSTextPlainField(widget.model as GSTextPlainModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.mobile:
        widget.child = GSMobileField(widget.model as GSMobileModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.password:
        widget.child = GSPasswordField(widget.model as GSPasswordModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.date:
        widget.child = GSDatePickerField(widget.model as GSDatePickerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.dateRage:
        widget.child = GSDateRangePickerField(widget.model as GSDateRangePickerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.time:
        widget.child = GSTimePickerField(widget.model as GSTimePickerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.email:
        widget.child = GSEmailField(widget.model as GSEmailModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.price:
        widget.child = GSPriceField(widget.model as GSPriceModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.bankCard:
        widget.child = GSBankCardField(widget.model as GSBankCardModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.spinner:
        widget.child = GSSpinnerField(widget.model as GSSpinnerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.radioGroup:
        widget.child = GSRadioGroupField(widget.model as GSRadioModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.checkList:
        widget.child = GSCheckListField(widget.model as GSCheckBoxModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.imagePicker:
        widget.child = GSImagePickerField(widget.model as GSImagePickerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.qrScanner:
        widget.child = GSQRScannerField(widget.model as GSQRScannerModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.multiImagePicker:
        widget.child = GSMultiImagePickerField(widget.model as GSMultiImagePickerModel, widget.formStyle!);
        break;

      default:
        widget.child = Container();
    }
  }
}
