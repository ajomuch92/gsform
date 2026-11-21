import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

import '../data_model/date_data_model.dart';

class GSDatePickerModel extends GSFieldModel {
  String? hint;
  GSDateFormatType? dateFormatType;
  bool? isPastAvailable;
  GSDate? initialDate;
  GSDate? availableFrom;
  GSDate? availableTo;

  GSDatePickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.prefixWidget,
    super.postfixWidget,
    super.required,
    super.status,
    super.value,
    super.weight,
    super.showTitle,
    this.hint,
    this.dateFormatType,
    this.isPastAvailable,
    this.availableFrom,
    this.availableTo,
    this.initialDate,
  });
}
