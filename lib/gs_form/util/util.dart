import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../core/form_style.dart';
import '../enums/field_status.dart';
import '../model/data_model/date_data_model.dart';
import '../values/colors.dart';

class GSFormUtils {
  static bool checkIfDarkModeEnabled(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.brightness == Brightness.dark;
  }

  static Decoration getFieldDecoration(GSFormStyle style, GSFieldStatusEnum? status, {double? borderWidth = 1.0}) {
    Color backgroundColor;
    Color borderColor;

    switch (status) {
      case GSFieldStatusEnum.error:
        backgroundColor = style.errorColor.withValues(alpha: 0.1);
        borderColor = style.errorColor;
        break;
      case GSFieldStatusEnum.success:
        backgroundColor = style.successColor.withValues(alpha: 0.1);
        borderColor = style.successColor;
        break;
      case GSFieldStatusEnum.normal:
        backgroundColor = style.backgroundFieldColor;
        borderColor = style.fieldBorderColor;
        break;
      case GSFieldStatusEnum.disabled:
        backgroundColor = style.backgroundFieldColorDisable;
        borderColor = style.fieldBorderColor;
        break;
      default:
        backgroundColor = GSFormColors.white;
        borderColor = GSFormColors.white;
    }
    return ShapeDecoration(
      color: backgroundColor,
      shape: RoundedSuperellipseBorder(
        side: BorderSide(color: borderColor, width: borderWidth ?? 1.0),
        borderRadius: BorderRadius.circular(style.fieldRadius),
      ),
    );
  }

  static void showImagePickerBottomSheet(
    BuildContext context,
    void Function(XFile image) callback, {
    String? galleryName,
    String? cameraName,
    GSFormStyle? style,
    Widget? cameraIcon,
    Widget? galleryIcon,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: [
              SizedBox(
                height: 130.0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            pickImage(ImageSource.camera).then((imageFile) {
                              if (imageFile != null) {
                                callback(imageFile);
                              }
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              cameraIcon ?? const Icon(Icons.camera, size: 40.0, color: Colors.blue),
                              const SizedBox(height: 10.0),
                              Text(
                                cameraName ?? (style ?? GSFormStyle()).labels.camera,
                                style: (style ?? GSFormStyle()).titleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            pickImage(ImageSource.gallery).then((imageFile) {
                              if (imageFile != null) {
                                callback(imageFile);
                              }
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              galleryIcon ?? const Icon(Icons.photo_library, size: 40.0, color: Colors.blue),
                              const SizedBox(height: 10.0),
                              Text(
                                galleryName ?? (style ?? GSFormStyle()).labels.gallery,
                                style: (style ?? GSFormStyle()).titleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<XFile?> pickImage(ImageSource imageSource) =>
      ImagePicker().pickImage(source: imageSource, maxWidth: 400, maxHeight: 400);

  /// True when [image] is within [maxKB] (or there is no limit).
  static Future<bool> fitsSize(XFile image, double? maxKB) async =>
      maxKB == null || await image.length() / 1000 < maxKB;

  static bool isDirectionRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  static String formatDate(BuildContext context, DateTime date, GSDateFormatType? type) {
    final l = MaterialLocalizations.of(context);
    return switch (type) {
      GSDateFormatType.fullText => l.formatFullDate(date),
      GSDateFormatType.mediumText => l.formatMediumDate(date),
      GSDateFormatType.shortText => l.formatShortDate(date),
      _ => l.formatCompactDate(date),
    };
  }

  /// First/last selectable day. Explicit bounds win; otherwise past days are blocked unless [isPastAvailable].
  static DateTimeRange pickerBounds(bool? isPastAvailable, GSDate? from, GSDate? to) {
    final first =
        from?.toDateTime() ?? ((isPastAvailable ?? false) ? DateTime(1900) : DateUtils.dateOnly(DateTime.now()));
    return DateTimeRange(start: first, end: to?.toDateTime() ?? DateTime(2100));
  }

  static DateTime clampDate(DateTime d, DateTimeRange bounds) =>
      d.isBefore(bounds.start) ? bounds.start : (d.isAfter(bounds.end) ? bounds.end : d);

  /// Formats the digits of [s] with thousands separators: '1234567' -> '1,234,567'.
  /// Non-digit characters are dropped, so the result is always parseable after removing ','.
  static String formatThousands(String s) {
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '').replaceFirst(RegExp(r'^0+(?=\d)'), '');
    return digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  }
}

/// Formats input against a mask: `#` digit, `A` letter, `*` letter or digit; anything else is a literal.
///
/// shortcut: literals must not be digits/letters (e.g. no `+1` prefix), since they are stripped from the input
/// before re-masking; use a prefixWidget for such prefixes.
class GSMaskFormatter extends TextInputFormatter {
  GSMaskFormatter(this.mask);

  final String mask;

  static final _slots = <String, bool Function(String)>{
    '#': (c) => RegExp(r'[0-9]').hasMatch(c),
    'A': (c) => RegExp(r'[a-zA-Z]').hasMatch(c),
    '*': (c) => RegExp(r'[a-zA-Z0-9]').hasMatch(c),
  };

  /// True when every slot of the mask is filled.
  bool isComplete(String text) => text.length == mask.length;

  /// Applies the mask to [input]. Literals are only added once the next slot gets a character.
  String apply(String input) {
    final literals = mask.split('').where((c) => !_slots.containsKey(c)).toSet();
    final raw = input.split('').where((c) => !literals.contains(c)).toList();
    final out = StringBuffer();
    final pending = StringBuffer();
    var i = 0;
    for (final m in mask.split('')) {
      final test = _slots[m];
      if (test == null) {
        pending.write(m);
        continue;
      }
      while (i < raw.length && !test(raw[i])) {
        i++;
      }
      if (i >= raw.length) break;
      out
        ..write(pending)
        ..write(raw[i++]);
      pending.clear();
    }
    return out.toString();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Leave deletions alone so the user can backspace over literals.
    if (newValue.text.length < oldValue.text.length) return newValue;
    final text = apply(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
