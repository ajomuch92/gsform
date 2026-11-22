import 'package:flutter/widgets.dart';

/// What [GSFormController] needs from a mounted field. Implemented by `GSField`'s state.
abstract class GSFieldHandle {
  String get tag;

  dynamic get value;

  bool validate();

  /// [validate], then the async validator if the sync checks passed.
  Future<bool> validateAsync();

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

  /// Like [isValid], but also runs every field's `asyncValidator` (in parallel) once its sync checks pass.
  Future<bool> isValidAsync({bool revealError = true}) async {
    final fields = _fields.values.toList();
    final results = await Future.wait(fields.map((f) => f.validateAsync()));
    final firstInvalid = [
      for (var i = 0; i < fields.length; i++)
        if (!results[i]) fields[i],
    ].firstOrNull;
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

  final Map<String, GlobalKey> _keys = {};
  final Map<String, FocusNode> _focusNodes = {};

  /// Internal: a focus node per layout slot that survives rebuilds; a new node each rebuild would drop focus.
  FocusNode focusNode(String slot) => _focusNodes.putIfAbsent(slot, FocusNode.new);

  /// Internal: a stable key per layout slot (tag + occurrence), so a field keeps its state when the layout moves it
  /// to another row.
  GlobalKey fieldKey(String slot) => _keys.putIfAbsent(slot, GlobalKey.new);

  /// Internal: called by fields.
  void register(GSFieldHandle field) {
    final existing = _fields[field.tag];
    if (existing != null && !identical(existing, field)) {
      // Kept working like 1.0 (the last field wins), but it is almost always a mistake.
      debugPrint('gsform_plus: more than one field uses the tag "${field.tag}"; only the last one is kept in values.');
    }
    _fields[field.tag] = field;
    _notifyAfterFrame();
  }

  /// Internal: called by fields.
  void unregister(GSFieldHandle field) {
    if (identical(_fields[field.tag], field)) {
      _fields.remove(field.tag);
      _notifyAfterFrame();
    }
  }

  bool _notifyScheduled = false;
  bool _disposed = false;

  /// Fields come and go during build (e.g. `visibleWhen`), where notifying is not allowed.
  void _notifyAfterFrame() {
    if (_notifyScheduled) return;
    _notifyScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyScheduled = false;
      if (!_disposed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
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
