import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/values/colors.dart';
import 'package:gsform_plus/gs_form/values/theme.dart';

/// Built-in texts shown by the fields. Override per field where a parameter exists (e.g. `from`, `cameraPopupTitle`).
class GSFormLabels {
  const GSFormLabels({
    this.from = 'From',
    this.to = 'To',
    this.camera = 'Camera',
    this.gallery = 'Gallery',
    this.qrScannerTitle = 'QR scanner',
  });

  static const es = GSFormLabels(
    from: 'Desde',
    to: 'Hasta',
    camera: 'Cámara',
    gallery: 'Galería',
    qrScannerTitle: 'Escanear QR',
  );

  final String from;
  final String to;
  final String camera;
  final String gallery;
  final String qrScannerTitle;
}

/// Visual style of a form. Can also be registered app-wide with `ThemeData(extensions: [GSFormStyle(...)])`.
class GSFormStyle extends ThemeExtension<GSFormStyle> {
  TextStyle titleTextStyle;
  TextStyle fieldHintStyle;
  TextStyle fieldTextStyle;
  TextStyle errorTextStyle;
  TextStyle helpTextStyle;
  TextStyle sectionTitleStyle;
  Color backgroundFieldColor;
  Color backgroundFieldColorDisable;
  Color backgroundSectionColor;
  Color fieldBorderColor;

  double fieldRadius;
  double sectionRadius;
  double sectionCardElevation;
  double sectionCardPadding;
  String requiredText;
  Color errorColor;
  Color successColor;
  GSFormLabels labels;

  GSFormStyle({
    TextStyle? titleStyle,
    Color? backgroundFieldColor,
    Color? backgroundSectionColor,
    Color? fieldBorderColor,
    Color? backgroundFieldColorDisable,
    double? fieldRadius,
    double? sectionRadius,
    double? sectionCardElevation,
    double? sectionCardPadding,
    TextStyle? fieldHintStyle,
    TextStyle? fieldTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? helpTextStyle,
    String? requiredText,
    TextStyle? sectionTitleStyle,
    Color? errorColor,
    Color? successColor,
    GSFormLabels? labels,
  }) : errorColor = errorColor ?? GSFormColors.red,
       successColor = successColor ?? GSFormColors.green,
       labels = labels ?? const GSFormLabels(),
       backgroundSectionColor = backgroundSectionColor ?? GSFormColors.white,
       backgroundFieldColor = backgroundFieldColor ?? GSFormColors.colorBackground,
       backgroundFieldColorDisable = backgroundFieldColorDisable ?? GSFormColors.colorBackgroundDisable,
       titleTextStyle = titleStyle ?? GSFormTheme.textThemeStyle.displayMedium!,
       fieldRadius = fieldRadius ?? 10.0,
       sectionRadius = sectionRadius ?? 4.0,
       sectionCardElevation = sectionCardElevation ?? 2.0,
       sectionCardPadding = sectionCardPadding ?? 2.0,
       requiredText = requiredText ?? '',
       fieldHintStyle = fieldHintStyle ?? GSFormTheme.textThemeStyle.bodyMedium!,
       fieldTextStyle = fieldTextStyle ?? GSFormTheme.textThemeStyle.displayMedium!,
       errorTextStyle = errorTextStyle ?? GSFormTheme.textThemeStyle.headlineSmall!,
       helpTextStyle = helpTextStyle ?? GSFormTheme.textThemeStyle.headlineMedium!,
       sectionTitleStyle = sectionTitleStyle ?? GSFormTheme.textThemeStyle.displayLarge!,
       fieldBorderColor = fieldBorderColor ?? GSFormColors.white;

  /// Derives a style from the app's [ColorScheme] and [TextTheme].
  factory GSFormStyle.fromTheme(ThemeData theme, {bool multiSection = false}) {
    final c = theme.colorScheme;
    final t = theme.textTheme;
    return GSFormStyle(
      titleStyle: t.labelLarge?.copyWith(color: c.onSurface),
      fieldTextStyle: t.bodyLarge?.copyWith(color: c.onSurface),
      fieldHintStyle: t.bodyLarge?.copyWith(color: c.onSurfaceVariant),
      errorTextStyle: t.bodySmall?.copyWith(color: c.error),
      helpTextStyle: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
      sectionTitleStyle: t.titleMedium?.copyWith(color: c.onSurface),
      backgroundFieldColor: c.surfaceContainerHighest,
      backgroundFieldColorDisable: c.onSurface.withValues(alpha: 0.12),
      backgroundSectionColor: multiSection ? c.surfaceContainerLow : Colors.transparent,
      fieldBorderColor: c.outlineVariant,
      errorColor: c.error,
      successColor: GSFormColors.green,
      sectionCardElevation: multiSection ? 1.0 : 0.0,
      sectionCardPadding: multiSection ? 8.0 : 0.0,
      fieldRadius: 8,
      sectionRadius: 8,
    );
  }

  @override
  GSFormStyle copyWith({
    TextStyle? titleStyle,
    Color? backgroundFieldColor,
    Color? backgroundSectionColor,
    Color? fieldBorderColor,
    Color? backgroundFieldColorDisable,
    double? fieldRadius,
    double? sectionRadius,
    double? sectionCardElevation,
    double? sectionCardPadding,
    TextStyle? fieldHintStyle,
    TextStyle? fieldTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? helpTextStyle,
    String? requiredText,
    TextStyle? sectionTitleStyle,
    Color? errorColor,
    Color? successColor,
    GSFormLabels? labels,
  }) {
    return GSFormStyle(
      titleStyle: titleStyle ?? titleTextStyle,
      backgroundFieldColor: backgroundFieldColor ?? this.backgroundFieldColor,
      backgroundSectionColor: backgroundSectionColor ?? this.backgroundSectionColor,
      fieldBorderColor: fieldBorderColor ?? this.fieldBorderColor,
      backgroundFieldColorDisable: backgroundFieldColorDisable ?? this.backgroundFieldColorDisable,
      fieldRadius: fieldRadius ?? this.fieldRadius,
      sectionRadius: sectionRadius ?? this.sectionRadius,
      sectionCardElevation: sectionCardElevation ?? this.sectionCardElevation,
      sectionCardPadding: sectionCardPadding ?? this.sectionCardPadding,
      fieldHintStyle: fieldHintStyle ?? this.fieldHintStyle,
      fieldTextStyle: fieldTextStyle ?? this.fieldTextStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      helpTextStyle: helpTextStyle ?? this.helpTextStyle,
      requiredText: requiredText ?? this.requiredText,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      labels: labels ?? this.labels,
    );
  }

  @override
  GSFormStyle lerp(covariant GSFormStyle? other, double t) {
    if (other == null) return this;
    return GSFormStyle(
      titleStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      backgroundFieldColor: Color.lerp(backgroundFieldColor, other.backgroundFieldColor, t),
      backgroundSectionColor: Color.lerp(backgroundSectionColor, other.backgroundSectionColor, t),
      fieldBorderColor: Color.lerp(fieldBorderColor, other.fieldBorderColor, t),
      backgroundFieldColorDisable: Color.lerp(backgroundFieldColorDisable, other.backgroundFieldColorDisable, t),
      fieldRadius: lerpDouble(fieldRadius, other.fieldRadius, t),
      sectionRadius: lerpDouble(sectionRadius, other.sectionRadius, t),
      sectionCardElevation: lerpDouble(sectionCardElevation, other.sectionCardElevation, t),
      sectionCardPadding: lerpDouble(sectionCardPadding, other.sectionCardPadding, t),
      fieldHintStyle: TextStyle.lerp(fieldHintStyle, other.fieldHintStyle, t),
      fieldTextStyle: TextStyle.lerp(fieldTextStyle, other.fieldTextStyle, t),
      errorTextStyle: TextStyle.lerp(errorTextStyle, other.errorTextStyle, t),
      helpTextStyle: TextStyle.lerp(helpTextStyle, other.helpTextStyle, t),
      requiredText: t < 0.5 ? requiredText : other.requiredText,
      sectionTitleStyle: TextStyle.lerp(sectionTitleStyle, other.sectionTitleStyle, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      successColor: Color.lerp(successColor, other.successColor, t),
      labels: t < 0.5 ? labels : other.labels,
    );
  }

  static GSFormStyle singleSectionFormDefaultStyle = GSFormStyle(
    backgroundFieldColor: GSFormColors.white,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    titleStyle: GSFormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: GSFormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: GSFormTheme.textThemeStyle.bodyMedium!,
    errorTextStyle: GSFormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: GSFormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: GSFormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static GSFormStyle singleSectionFormDefaultDarkStyle = GSFormStyle(
    backgroundFieldColor: GSFormColors.black,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    sectionTitleStyle: GSFormTheme.textThemeDarkStyle.displayLarge,
    titleStyle: GSFormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: GSFormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: GSFormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: GSFormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: GSFormTheme.textThemeDarkStyle.headlineMedium,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static GSFormStyle multiSectionFormDefaultStyle = GSFormStyle(
    backgroundFieldColor: GSFormColors.colorBackground,
    sectionCardElevation: 2.0,
    backgroundSectionColor: GSFormColors.white,
    sectionCardPadding: 8.0,
    titleStyle: GSFormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: GSFormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: GSFormTheme.textThemeStyle.bodyMedium,
    errorTextStyle: GSFormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: GSFormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: GSFormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static GSFormStyle multiSectionFormDefaultDarkStyle = GSFormStyle(
    backgroundFieldColor: GSFormColors.colorBackgroundDark,
    backgroundSectionColor: GSFormColors.black,
    titleStyle: GSFormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: GSFormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: GSFormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: GSFormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: GSFormTheme.textThemeDarkStyle.headlineMedium,
    sectionTitleStyle: GSFormTheme.textThemeDarkStyle.displayLarge,
    sectionRadius: 8,
    sectionCardElevation: 2.0,
    sectionCardPadding: 8.0,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );
}
