## 1.1.0

### Added

* `GSFormController`: `values`, `getValue`, `setValue`, `setValues`, `reset`, `isValid`, `setEnabled`, `initialValues`, and change notifications.
* `validator` on every field: return an error message to show, or `null`. Works for cross-field checks via the controller.
* `onChanged` on every field and on `GSForm` (`(tag, value)`).
* `autovalidateMode` on `GSForm`. Fields showing an error are re-validated as the user edits them.
* `isValid()` scrolls to the first invalid field and focuses it (`revealError: false` to opt out).
* New fields: `GSField.masked`, `GSField.pinCode`, `GSField.toggle`, `GSField.slider` (single and range), `GSField.autocomplete` and `GSField.custom`.
* `GSFormStyle` is a `ThemeExtension` (register it in `ThemeData.extensions`), plus `GSFormStyle.fromTheme(theme)`, `errorColor`, `successColor` and translatable `labels` (`GSFormLabels`, `GSFormLabels.es`).
* `GSMaskFormatter` exported.
* Web support for the image fields: they used `dart:io` and failed at runtime on web; pub.dev should now list web.

### Changed

* Default text sizes raised to readable values (error/help text was 7px). Fields are a bit taller.
* Field title is exposed to screen readers; error messages are announced.
* `GSFieldCallBack` gained `setValue` and `reset`; custom implementations must add them.
* The date range picker defaults its labels to `GSFormStyle.labels` instead of hard-coded `From` / `To`.
* The bank card field uses `GSMaskFormatter`; `CardNumberFormatter` was removed.

### Fixed

* The spinner ignored its `value` parameter.
* Pre-selected checklist items were missing from the value.
* Validating a disabled field re-enabled it; disabled fields now count as valid.
* The price field lost its text on parent rebuild when it had an initial value.

## 1.0.0

First release as **gsform_plus**, a maintained continuation of [gsform](https://pub.dev/packages/gsform) 0.3.7.

### Breaking

* Package renamed to `gsform_plus`. Import `package:gsform_plus/gsform_plus.dart`.
* Requires Flutter 3.32 / Dart 3.8.
* Removed the Jalali calendar and `persian_datetime_picker`. `calendarType` is gone; dates use Material pickers and the app locale.
* Removed `image_cropper` and the `showCropper` option.
* Replaced the discontinued `qr_code_scanner` with `mobile_scanner`.
* `cameraPopupIcon` / `galleryPopupIcon` are now `Widget?` instead of SVG asset paths.
* `GSField.imagePicker(maximumSizePerImageInBytes:)` renamed to `maximumSizePerImageInKB`.
* Removed direct dependencies `intl`, `flutter_svg`, `figma_squircle_updated` and the unused `path_provider`.

### Fixed

* `validateRegEx` was accepted by every field but never applied.
* `availableFrom` on date and date-range pickers was overwritten by `availableTo`.
* Price field crashed when the text was cleared or a non-digit was typed; thousands separator no longer depends on locale (getValue returned wrong numbers in locales that use `.`).
* Email field reset the typed text on every rebuild; email regex now accepts hyphenated domains and subdomains and rejects trailing garbage.
* Time field crashed when an empty field was rebuilt.
* Date range field lost the selection on rebuild and returned the same text for start and end.
* Date fields showed a pre-set date with the hint style, and cancelling the picker restyled the chosen date as hint.
* Past-blocked date pickers could not go back to earlier future dates after a pick.
* Required spinner with a hint always passed validation; picking an item left several items marked selected.
* Image cropper results were discarded (the original file was kept); multi-image size check was inverted.
* Multi-image and QR fields lost their values on parent rebuild.
* QR scanner popped once per detected frame, closing the form screen too.
* `GSField` crashed when used outside a `GSSection`; `GSForm.isValid()` crashed before fields were built.
* Image picker crashed with a null `title`; hard-coded Persian labels removed.

### Other

* Removed the generated `doc/` folder that was declared as package assets (≈11 MB shipped into every app).
* Added tests and enabled `flutter_lints`.

## 0.0.1

* initial GSForm .

## 0.0.2

* Add some Examples
* Complete readme

## 0.0.3

* Fixed some bugs

## 0.0.4

* Fixed some bugs
* Add Radio group as field of GSForm
* Improved styles

## 0.0.5

* Fixed some bugs
* Improved styles

## 0.0.6

* Fixed some bugs
* Update readme
* Add icon widget to file picker

## 0.0.7

* Add search field for radio group

## 0.0.8

* Improved styles
* Improved design

## 0.0.9

* Add CheckBoxList
* Fix RadioGroup initial selected data

## 0.1.0

* Add set value for text fields
* Improved form fields
* Fixed some bugs

## 0.1.1

* Improved form fields
* Fixed some bugs

## 0.1.2

* Improved form fields
* Add Disable Status to fields status

## 0.1.3

* Improved form fields
* Fix some bug
* Change Radio group returned value type
* Set initial value for spinner

## 0.1.4

* Add required all to gsCheckListField
* Fix improve fields

## 0.1.5

* Fix maxLine Scrollable in GSTextPlainField

## 0.1.6

* Add MultiImagePickerField
* Add Ability to Check image size and image count in MultiImagePickerField and ImagePickerField
* Show counter in NumberField
* Improve some fields
* Fix some bug

## 0.1.7

* Fix bug in TimePicker

## 0.1.8

* Add call back to spinner field

## 0.1.9

* Fix text aline in number field

## 0.1.9

* Fix bugs

## 0.2.1

* Fix bugs
* Upgrade some library dependency

## 0.2.3

* Add web support

## 0.2.4

* Update dependency

## 0.2.5

* Fix dependency

## 0.2.6

* Fix dependency intl

## 0.2.7

* Create document

## 0.2.8

* Fix bug
* Update dependencies

## 0.2.9

* Bug fixing
* Improve some fields

## 0.3.0

* Bug fixing
* Improve some fields

## 0.3.1

* Improve some fields

## 0.3.2

* Fix default value bugs

## 0.3.3

* Fix bugs
* Add readOnly future in Text fields

## 0.3.4

* Fix bugs

## 0.3.5

* Upgrade some dependencies

## 0.3.6

* Upgrade some dependencies
* Fix some bug
* Fix validation of email field 

## 0.3.7
* Update intl to 0.19.0
