import 'package:flutter/widgets.dart';

/// What [GSFormController] needs from a mounted field. Implemented by `GSField`'s state.
abstract class GSFieldHandle {
  String get tag;

  dynamic get value;

  bool validate();

  void reveal();

  void setValue(dynamic value);

  void reset();

  void setEnabled(bool enabled);
}

/// Reads and writes the values of a [GSForm] from outside its widget tree.
///
/// Pass it to `GSForm.singleSection(controller: ...)` / `GSForm.multiSection(controller: ...)`.
/// Listeners are notified whenever a field value changes.
class GSFormController extends ChangeNotifier {
  GSFormController({Map<String, dynamic>? initialValues}) : initialValues = Map.unmodifiable(initialValues ?? {});

  /// Applied to each field (by tag) when it is first built, and again by [reset].
  final Map<String, dynamic> initialValues;

  final Map<String, GSFieldHandle> _fields = {};

  /// Current value of every mounted field, keyed by tag.
  Map<String, dynamic> get values => {for (final e in _fields.entries) e.key: e.value.value};

  Iterable<String> get tags => _fields.keys;

  dynamic getValue(String tag) => _field(tag).value;

  void setValue(String tag, dynamic value) {
    _field(tag).setValue(value);
    notifyListeners();
  }

  void setValues(Map<String, dynamic> values) {
    values.forEach((tag, value) => _field(tag).setValue(value));
    notifyListeners();
  }

  /// Validates every field, marks them as success/error and, if [revealError], scrolls to the first invalid one.
  bool isValid({bool revealError = true}) {
    GSFieldHandle? firstInvalid;
    for (final field in _fields.values) {
      if (!field.validate()) firstInvalid ??= field;
    }
    if (revealError) firstInvalid?.reveal();
    return firstInvalid == null;
  }

  /// Restores [initialValues], or each field's own initial value when it has none.
  void reset() {
    _fields.forEach((tag, field) {
      field.reset(); // also clears error/success marks
      if (initialValues.containsKey(tag)) field.setValue(initialValues[tag]);
    });
    notifyListeners();
  }

  void setEnabled(String tag, bool enabled) => _field(tag).setEnabled(enabled);

  GSFieldHandle _field(String tag) =>
      _fields[tag] ?? (throw ArgumentError.value(tag, 'tag', 'No field with this tag is mounted in the form'));

  /// Internal: called by fields.
  void register(GSFieldHandle field) {
    assert(_fields[field.tag] == null || identical(_fields[field.tag], field), 'Duplicate field tag "${field.tag}"');
    _fields[field.tag] = field;
  }

  /// Internal: called by fields.
  void unregister(GSFieldHandle field) {
    if (identical(_fields[field.tag], field)) _fields.remove(field.tag);
  }

  /// Internal: called by fields when the user changes a value.
  void fieldChanged() => notifyListeners();
}

/// Passes form-wide settings down to its fields. Created by `GSForm`.
class GSFormScope extends InheritedWidget {
  const GSFormScope({
    super.key,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    required super.child,
  });

  final GSFormController? controller;
  final AutovalidateMode autovalidateMode;
  final void Function(String tag, dynamic value)? onChanged;

  /// Registers a dependency, so the caller rebuilds when [controller] changes.
  static GSFormScope? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<GSFormScope>();

  /// Reads without a dependency.
  static GSFormScope? read(BuildContext context) => context.getInheritedWidgetOfExactType<GSFormScope>();

  @override
  bool updateShouldNotify(GSFormScope oldWidget) => controller != oldWidget.controller;
}
