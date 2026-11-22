import 'package:gsform_plus/gs_form/model/data_model/spinner_data_model.dart';

import 'field_model.dart';

class GSAutocompleteModel extends GSFieldModel {
  final List<SpinnerDataModel> items;
  final String? hint;

  GSAutocompleteModel({
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
    super.enableReadOnly,
    required this.items,
    this.hint,
  });
}
