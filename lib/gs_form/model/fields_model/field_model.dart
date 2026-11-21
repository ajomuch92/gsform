import 'package:flutter/cupertino.dart';

import '../../enums/field_status.dart';
import '../../enums/filed_type.dart';

abstract class GSFieldModel {
  GSFieldTypeEnum? type;
  String? title;
  String tag;
  String? errorMessage;
  String? helpMessage;
  Widget? prefixWidget;
  Widget? postfixWidget;
  bool? required;
  bool? showTitle;
  GSFieldStatusEnum status;
  RegExp? validateRegEx;
  int? weight;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  dynamic value;
  bool? enableReadOnly;
  VoidCallback? onTap;

  /// Extra validation run after `required`/`validateRegEx` pass. Return an error message, or `null` if valid.
  String? Function(dynamic value)? validator;

  /// Called when the user changes the value.
  ValueChanged<dynamic>? onChanged;

  /// Server-side style check (e.g. "username taken"), run by `isValidAsync()` after the sync checks pass.
  Future<String?> Function(dynamic value)? asyncValidator;

  /// When set, the field is only part of the form while this returns true for the current values (by tag).
  /// Hidden fields are not validated or submitted, and start from their initial value when shown again.
  bool Function(Map<String, dynamic> values)? visibleWhen;

  /// Weight used when the section is narrower than `GSFormStyle.compactBreakpoint` (e.g. 12 on phones).
  int? compactWeight;

  /// True while [asyncValidator] runs.
  bool validating = false;

  /// Message returned by [validator] on the last validation.
  String? validatorMessage;

  /// Internal: set by `GSField` to hear value changes.
  ValueChanged<dynamic>? changeListener;

  void notifyChanged(dynamic value) {
    onChanged?.call(value);
    changeListener?.call(value);
  }

  GSFieldModel({
    this.type,
    required this.tag,
    this.showTitle,
    this.title,
    this.errorMessage,
    this.helpMessage,
    this.prefixWidget,
    this.postfixWidget,
    this.required,
    this.value,
    this.validateRegEx,
    this.weight,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    GSFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : status = status ?? GSFieldStatusEnum.normal,
       enableReadOnly = enableReadOnly ?? false;
}
