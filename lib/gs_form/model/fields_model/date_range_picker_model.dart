import 'package:gsform_plus/gs_form/model/data_model/date_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

class GSDateRangePickerModel extends GSFieldModel {
  String? hint;
  GSDateFormatType? dateFormatType;
  bool? isPastAvailable;
  GSDate? initialStartDate;
  GSDate? initialEndDate;
  GSDate? availableFrom;
  GSDate? availableTo;
  String? from;
  String? to;

  GSDateRangePickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.showTitle,
    super.prefixWidget,
    super.postfixWidget,
    super.required,
    super.status,
    super.value,
    RegExp? validateReg,
    super.weight,
    this.hint,
    this.dateFormatType,
    this.isPastAvailable,
    this.availableFrom,
    this.availableTo,
    this.initialStartDate,
    this.initialEndDate,
    this.from,
    this.to,
  }) : super(validateRegEx: validateReg);
}
