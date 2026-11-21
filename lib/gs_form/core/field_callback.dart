abstract class GSFieldCallBack {
  bool isValid();

  dynamic getValue();

  /// Sets the value programmatically; `null` clears the field. Safe to call before the field is built.
  void setValue(dynamic value);

  /// Restores the value the field was created with.
  void reset();
}
