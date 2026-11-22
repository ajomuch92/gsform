import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/model/fields_model/autocomplete_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/custom_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/masked_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/pin_code_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/slider_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/toggle_model.dart';
import 'package:gsform_plus/gs_form/widget/fields/autocomplete_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/custom_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/masked_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/pin_code_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/slider_field.dart';
import 'package:gsform_plus/gs_form/widget/fields/toggle_field.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_controller.dart';
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
  _GSFieldState? _state;

  /// Internal: set by `GSForm` so the field keeps its state when the layout moves it to another row.
  GlobalKey? layoutKey;

  void update() {
    onUpdate?.call();
  }

  /// Whether the field is currently built (false before the first build and while hidden by `visibleWhen`).
  bool get isActive => _state?.mounted ?? false;

  /// Runs `required`/`validateRegEx`/[GSFieldModel.validator] and shows the result.
  /// Disabled and inactive fields are valid.
  bool validate() => isActive ? _state!.validate() : true;

  /// [validate], then [GSFieldModel.asyncValidator] if the sync checks passed.
  Future<bool> validateAsync() => isActive ? _state!.validateAsync() : Future.value(true);

  /// Scrolls the field into view and focuses it when possible.
  void reveal() => isActive ? _state!.reveal() : null;

  dynamic get value => isActive ? _state!.value : null;

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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
  }) {
    model = GSDateRangePickerModel(
      type: GSFieldTypeEnum.dateRage,
      tag: tag,
      title: title,
      errorMessage: errorMessage,
      helpMessage: helpMessage,
      from: from,
      to: to,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
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
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
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
    model!
      ..validator = validator
      ..onChanged = onChanged
      ..asyncValidator = asyncValidator
      ..visibleWhen = visibleWhen
      ..compactWeight = compactWeight;
  }

  /// One box per digit. The value is the entered `String`; `required` needs all [length] digits.
  GSField.pinCode({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    int length = 6,
    bool obscure = false,
    String? value,
  }) {
    model =
        GSPinCodeModel(
            type: GSFieldTypeEnum.pinCode,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            length: length,
            obscure: obscure,
            value: value,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  /// Text with an input mask: `#` digit, `A` letter, `*` either; e.g. `(###) ###-####`. The value keeps the literals.
  GSField.masked({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    required String mask,
    String? hint,
    String? value,
    TextInputType? keyboardType,
    RegExp? validateRegEx,
  }) {
    model =
        GSMaskedModel(
            type: GSFieldTypeEnum.masked,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            mask: mask,
            hint: hint,
            value: value,
            keyboardType: keyboardType,
            validateRegEx: validateRegEx,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  /// A switch with a [hint] label. The value is a `bool`; `required` means it must be on.
  GSField.toggle({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    String? hint,
    bool value = false,
  }) {
    model =
        GSToggleModel(
            type: GSFieldTypeEnum.toggle,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            hint: hint,
            value: value,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  /// A slider. The value is a `double`, or `RangeValues` when [isRange] is true.
  GSField.slider({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    required double min,
    required double max,
    int? divisions,
    bool isRange = false,
    dynamic value,
  }) {
    model =
        GSSliderModel(
            type: GSFieldTypeEnum.slider,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            min: min,
            max: max,
            divisions: divisions,
            isRange: isRange,
            value: value,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  /// A text field with suggestions from [items]. The value is the picked `SpinnerDataModel`.
  GSField.autocomplete({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    required List<SpinnerDataModel> items,
    String? hint,
    SpinnerDataModel? value,
  }) {
    model =
        GSAutocompleteModel(
            type: GSFieldTypeEnum.autocomplete,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            items: items,
            hint: hint,
            value: value,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  /// Any input you build. [builder] gets the current value and an `onChanged` to report new ones.
  GSField.custom({
    super.key,
    required String tag,
    String? title,
    bool? showTitle,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    GSFieldStatusEnum? status,
    int? weight,
    bool? readOnly,
    String? Function(dynamic value)? validator,
    ValueChanged<dynamic>? onChanged,
    Future<String?> Function(dynamic value)? asyncValidator,
    bool Function(Map<String, dynamic> values)? visibleWhen,
    int? compactWeight,
    required GSCustomFieldBuilder builder,
    dynamic value,
  }) {
    model =
        GSCustomModel(
            type: GSFieldTypeEnum.custom,
            tag: tag,
            title: title,
            showTitle: showTitle ?? true,
            errorMessage: errorMessage,
            helpMessage: helpMessage,
            prefixWidget: prefixWidget,
            postfixWidget: postfixWidget,
            required: required,
            status: status,
            weight: weight,
            enableReadOnly: readOnly,
            builder: builder,
            value: value,
          )
          ..validator = validator
          ..onChanged = onChanged
          ..asyncValidator = asyncValidator
          ..visibleWhen = visibleWhen
          ..compactWeight = compactWeight;
  }

  //</editor-fold>

  @override
  State<GSField> createState() => _GSFieldState();
}

class _GSFieldState extends State<GSField> implements GSFieldHandle {
  GSFormController? _controller;

  /// Set by [setValue]/[reset]: build a fresh child (which inherits the new state) on the next build.
  /// Deferred so several calls before a frame all hit the same mounted child.
  bool _refreshChild = false;

  GSFieldCallBack get _callback => widget.child as GSFieldCallBack;

  @override
  String get tag => widget.model!.tag;

  @override
  dynamic get value => _callback.getValue();

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(covariant GSField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _attach();
  }

  void _attach() {
    widget._state = this;
    widget.model?.changeListener = _onUserChange;
    _fillChild();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = GSFormScope.of(context)?.controller;
    if (controller == _controller) return;
    _controller?.unregister(this);
    _controller = controller;
    if (controller == null || widget.model == null) return;
    controller.register(this);
    // The child is not built yet, so setting it directly is enough.
    if (controller.initialValues.containsKey(tag)) _callback.setValue(controller.initialValues[tag]);
  }

  @override
  void dispose() {
    _controller?.unregister(this);
    super.dispose();
  }

  void _onUserChange(dynamic value) {
    final scope = GSFormScope.read(context);
    if ((scope?.autovalidateMode ?? AutovalidateMode.disabled) != AutovalidateMode.disabled ||
        widget.model?.status == GSFieldStatusEnum.error) {
      validate();
    }
    scope?.onChanged?.call(tag, value);
    _controller?.fieldChanged();
  }

  @override
  bool validate() {
    final model = widget.model;
    if (model == null || model.status == GSFieldStatusEnum.disabled) return true;
    var ok = _callback.isValid();
    String? message;
    if (ok && model.validator != null) {
      message = model.validator!(_callback.getValue());
      ok = message == null;
    }
    model.validatorMessage = message;
    model.status = ok ? GSFieldStatusEnum.success : GSFieldStatusEnum.error;
    if (mounted) setState(() {});
    return ok;
  }

  @override
  Future<bool> validateAsync() async {
    final model = widget.model;
    final ok = validate();
    if (!ok || model?.asyncValidator == null || model!.status == GSFieldStatusEnum.disabled) return ok;
    setState(() => model.validating = true);
    final message = await model.asyncValidator!(_callback.getValue());
    model
      ..validating = false
      ..validatorMessage = message
      ..status = message == null ? GSFieldStatusEnum.success : GSFieldStatusEnum.error;
    if (mounted) setState(() {});
    return message == null;
  }

  @override
  void reveal() {
    if (!mounted) return;
    Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 300), alignment: 0.2);
    widget.model?.focusNode?.requestFocus();
  }

  @override
  void setValue(dynamic value) {
    _callback.setValue(value);
    if (mounted) setState(() => _refreshChild = true);
  }

  @override
  void reset() {
    _callback.reset();
    widget.model?.status = GSFieldStatusEnum.normal;
    if (mounted) setState(() => _refreshChild = true);
  }

  @override
  void setEnabled(bool enabled) {
    if (mounted) {
      setState(() => widget.model?.status = enabled ? GSFieldStatusEnum.normal : GSFieldStatusEnum.disabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_refreshChild) {
      _refreshChild = false;
      _fillChild();
    }
    final style = widget.formStyle ??= GSFormStyle();
    final model = widget.model;
    widget.onUpdate = () {
      if (mounted && model?.status != GSFieldStatusEnum.disabled) setState(() {});
    };
    final isError = model?.status == GSFieldStatusEnum.error;
    final errorText = model?.validatorMessage ?? model?.errorMessage;
    final message = isError ? errorText : model?.helpMessage;

    return AbsorbPointer(
      absorbing: model?.status == GSFieldStatusEnum.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (model?.showTitle ?? false) ...[
            Row(
              children: [
                Flexible(child: Text(model?.title ?? '', style: style.titleTextStyle)),
                if (model?.required ?? false) ...[
                  const SizedBox(width: 4.0),
                  ExcludeSemantics(
                    child: Text(style.requiredText, style: style.titleTextStyle.copyWith(color: style.errorColor)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6.0),
          ],
          Semantics(
            container: true,
            label: model?.title,
            child: Container(
              decoration: GSFormUtils.getFieldDecoration(style, model?.status),
              child: Row(
                children: [
                  if (model?.prefixWidget != null) ...[
                    const SizedBox(width: 8.0),
                    model!.prefixWidget!,
                    const SizedBox(width: 8.0),
                    Container(height: 30.0, color: GSFormColors.dividerColor, width: 1.0),
                  ],
                  Expanded(child: widget.child!),
                  if (model?.postfixWidget != null) ...[
                    const SizedBox(width: 10.0),
                    model!.postfixWidget!,
                    const SizedBox(width: 10.0),
                  ],
                  if (model?.validating ?? false)
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 10.0),
                      child: SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          // Keeps its height when empty so the layout doesn't jump on validation.
          Opacity(
            opacity: message == null ? 0 : 1,
            child: Semantics(
              liveRegion: isError,
              child: Row(
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.info_outline,
                    size: (isError ? style.errorTextStyle : style.helpTextStyle).fontSize ?? 12,
                    color: isError ? style.errorColor : style.helpTextStyle.color,
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(child: Text(message ?? '', style: isError ? style.errorTextStyle : style.helpTextStyle)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5.0),
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

      case GSFieldTypeEnum.pinCode:
        widget.child = GSPinCodeField(widget.model as GSPinCodeModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.masked:
        widget.child = GSMaskedField(widget.model as GSMaskedModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.toggle:
        widget.child = GSToggleField(widget.model as GSToggleModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.slider:
        widget.child = GSSliderField(widget.model as GSSliderModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.autocomplete:
        widget.child = GSAutocompleteField(widget.model as GSAutocompleteModel, widget.formStyle!);
        break;
      case GSFieldTypeEnum.custom:
        widget.child = GSCustomField(widget.model as GSCustomModel, widget.formStyle!);
        break;
      default:
        widget.child = Container();
    }
  }
}
