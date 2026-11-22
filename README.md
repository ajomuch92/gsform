<!-- >  **Warning**: under cunstruction  -->
</br>
</br>
</br>
</br>
<p align="center">
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/gsform_logo.png?raw=true" width="300" height="100">

</br>

</p>

This package helps to create forms in Flutter by removing the boilerplate needed to build a form, validate fields, react to changes and collect final user input.

Also included are common ready-made form input fields for GSForm. This gives you a convenient way of
adding common ready-made input fields instead of creating your own FormBuilderField from scratch.
<!--* Project status: working -->

<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/header.jpg?raw=true">

See real examples:

* <https://github.com/ajomuch92/gsform_plus/tree/main/example>

> **gsform_plus** is a maintained continuation of [gsform](https://pub.dev/packages/gsform) by Golrang System.
> Coming from `gsform`? See [Migrating from gsform](#migrating-from-gsform).

## Table of contents

<!-- Use for instance <https://github.com/ekalinin/github-markdown-toc>: -->

>   * [Installation](#installation)
>   * [Working with the form](#working-with-the-form)
>   	* [Controller](#controller)
>   	* [Validation](#validation)
>   	* [Reacting to changes](#reacting-to-changes)
>   	* [Conditional fields](#conditional-fields)
>   	* [Async validation](#async-validation)
>   	* [Multi-step forms](#multi-step-forms)
>   	* [Responsive layout](#responsive-layout)
>   	* [Theming and translations](#theming-and-translations)
>   	* [More fields](#more-fields)
>   * [Theme](#theme)
>   	* [Style](#style)
>   	* [Dark Support](#dark-support)
>   	* [Direction](#direction)
>   	* [Required Marker](#required-marker)
<!-- >   * [Features](#features) -->
>   * [Fields](#fields)
>   * [Attributes](#attributes)
>       * [Text](#text)
>   	* [TextPlain](#textplain)
>   	* [Number](#number)
>   	* [Spinner](#spinner)
>   	* [DatePicker](#datepicker)
>   	* [DateRangedPicker](#daterangedpicker)
>   	* [TimePicker](#timepicker)
>   	* [Mobile](#mobile)
>   	* [Email](#email)
>   	* [Password](#password)
>   	* [Price](#price)
>   	* [Masked](#masked)
>   	* [PinCode](#pincode)
>   	* [Toggle](#toggle)
>   	* [Slider](#slider)
>   	* [Autocomplete](#autocomplete)
>   	* [Custom](#custom)
<!-- >   	* [BankCard](#bankcard) -->
>
>
>
<!-- >     * [Content](#content) -->
<!-- >     * [Requirements](#requirements) -->
<!-- >     * [Limitations](#limitations) -->
<!-- >     * [Build](#build) -->
<!-- >     * [Deploy (how to install build product)](#deploy-how-to-install-build-product) -->
<!-- >   * [Resources (Documentation and other links)](#resources-documentation-and-other-links) -->
<!-- >   * [Contributing / Reporting issues](#contributing--reporting-issues) -->
> * [License](#license)
>   * [Credits](#credits)

## Installation

Run this command:

With Flutter:
</br>

```
flutter pub add gsform_plus
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  gsform_plus: ^1.1.0
```

Then import everything from one place:

```dart
import 'package:gsform_plus/gsform_plus.dart';
```

Requires Flutter 3.32 or newer.

### Platform setup

Only needed if you use the image picker or QR scanner fields.

* **iOS**: add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `ios/Runner/Info.plist`.
* **Android**: no extra setup for `image_picker`. For the QR scanner see the
  [mobile_scanner setup](https://pub.dev/packages/mobile_scanner#platform-specific-setup).

## Migrating from gsform

1.0.0 removes dependencies that were heavy, unmaintained or easy to replace with Flutter itself. Breaking changes:

* Package and import renamed: `package:gsform/...` → `package:gsform_plus/gsform_plus.dart`.
* Jalali (Persian) calendar removed. Drop `calendarType:` from `GSField.datePicker` / `GSField.dateRangePicker`;
  dates use Material's picker and are formatted with the app locale.
* Image cropper removed: the `showCropper` option is gone.
* `cameraPopupIcon` / `galleryPopupIcon` now take a `Widget` (pass `SvgPicture.asset(...)` yourself if you used SVGs).
* `GSField.imagePicker(maximumSizePerImageInBytes:)` renamed to `maximumSizePerImageInKB` (it always compared kilobytes).
* QR scanner now uses `mobile_scanner` (the old `qr_code_scanner` is discontinued).
* The time field shows the time in the device's format (e.g. `3:05 PM`) and has no default hint.

## Working with the form

Runs on Android, iOS, web, macOS, Windows and Linux (the QR scanner needs a camera-capable platform).

### Controller

`GSFormController` reads and writes values from outside the widget tree, validates, resets and enables/disables fields.

```dart
final controller = GSFormController(initialValues: {'name': 'Ana'});

GSForm.singleSection(context, controller: controller, fields: [
  GSField.text(tag: 'name', title: 'Name'),
  GSField.email(tag: 'email', title: 'Email'),
]);

controller.values;                    // {'name': 'Ana', 'email': ''}
controller.setValue('email', 'a@b.co');
controller.setValues({'name': 'Luis', 'email': 'l@b.co'});
controller.setEnabled('email', false); // disabled fields skip validation
controller.isValid();                 // validates and scrolls to the first invalid field
controller.reset();                   // back to initialValues / each field's initial value
controller.addListener(() => print(controller.values)); // fires on every change
```

`setValue` takes the same type the field returns (`String` for text fields, `DateTime`, `DateTimeRange`,
`TimeOfDay`, `bool`, `double`/`RangeValues`, image path(s)). Spinner and autocomplete also accept an item `id`;
radio and checklist accept the item's `data`. `null` clears a field.

Without a controller, keep the `GSForm` instance and call `form.isValid()` / `form.onSubmit()` as before.

### Validation

Besides `required` and `validateRegEx`, every field takes a `validator` that returns an error message (or `null`):

```dart
GSField.password(
  tag: 'confirm',
  title: 'Confirm password',
  validator: (value) => value == controller.getValue('password') ? null : 'Passwords differ',
)
```

`isValid()` scrolls to the first invalid field (pass `revealError: false` to skip that). A field showing an error is
re-validated as the user fixes it; set `autovalidateMode: AutovalidateMode.onUserInteraction` on the form to validate
every field while typing.

### Reacting to changes

```dart
GSForm.singleSection(
  context,
  onChanged: (tag, value) => print('$tag changed to $value'), // any field
  fields: [
    GSField.text(tag: 'name', onChanged: (value) => print(value)), // one field
  ],
);
```

`onChanged` fires on user edits, not on `controller.setValue`.

### Conditional fields

`visibleWhen` receives the current values (by tag) and decides whether the field is part of the form:

```dart
GSField.toggle(tag: 'business', hint: 'Business account'),
GSField.text(
  tag: 'company',
  title: 'Company name',
  required: true,
  visibleWhen: (values) => values['business'] == true,
),
```

Hidden fields are not validated, are left out of `onSubmit()` / `controller.values`, and start again from their
initial value when shown.

### Async validation

For checks that need a server, add an `asyncValidator`. It runs after the sync checks pass, when you call
`isValidAsync()` (on the form or the controller) and on the stepper buttons; a small spinner shows while it runs.

```dart
GSField.text(
  tag: 'username',
  asyncValidator: (value) async => await api.isTaken(value) ? 'Username taken' : null,
)

if (await controller.isValidAsync()) save(controller.values);
```

`isValid()` stays synchronous and ignores async validators.

### Multi-step forms

`GSForm.stepper` shows one section per step with Back/Next buttons and a progress bar. Next validates only the
current step; steps keep their values while hidden; the last step calls `onComplete` with every value.

```dart
GSForm.stepper(
  context,
  onComplete: (values) => save(values),
  onStepChanged: (step) => debugPrint('step $step'),
  sections: [
    GSSection(sectionTitle: 'Account', fields: [GSField.email(tag: 'email', required: true)]),
    GSSection(sectionTitle: 'Profile', fields: [GSField.text(tag: 'name')]),
  ],
)
```

Button texts come from `GSFormStyle.labels` (`next`, `back`, `submit`).

### Responsive layout

Each row holds up to 12 weight units; a field that does not fit starts a new row. Use `compactWeight` for narrow
layouts (sections under `GSFormStyle.compactBreakpoint`, 600 by default):

```dart
GSField.text(tag: 'first', weight: 6, compactWeight: 12), // side by side on tablets, stacked on phones
GSField.text(tag: 'last', weight: 6, compactWeight: 12),
```

### Theming and translations

Register a style once for the whole app, or derive one from your `ThemeData`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [GSFormStyle.fromTheme(ThemeData.light())],
  ),
);
```

A `style:` passed to `GSForm` still wins. `GSFormStyle` also carries `errorColor`, `successColor` and the built-in texts
(`labels`): English by default, `GSFormLabels.es` for Spanish, or your own `GSFormLabels(...)`.

### More fields

```dart
GSField.masked(tag: 'phone', mask: '(###) ###-####')  // # digit, A letter, * either
GSField.pinCode(tag: 'otp', length: 6)                 // one box per digit, SMS autofill
GSField.toggle(tag: 'terms', hint: 'I accept the terms', required: true) // must be on
GSField.slider(tag: 'age', min: 18, max: 99, divisions: 81)
GSField.slider(tag: 'price', min: 0, max: 1000, isRange: true) // RangeValues
GSField.autocomplete(tag: 'city', items: [SpinnerDataModel(name: 'Lima', id: 1)])
GSField.custom(
  tag: 'rating',
  builder: (context, value, onChanged) => Slider(value: value ?? 0.0, onChanged: onChanged),
)
```

`GSMaskFormatter` is exported too, if you need a mask in your own `TextField`.

## Style

<table>
  <tr>
    <td>

```dart
GSFormStyle(
	backgroundFieldColor: COLOR,
	backgroundSectionColor: COLOR,
	sectionCardElevation: 0,
	titleStyle: TextStyle,
	fieldHintStyle: TextStyle,
	fieldTextStyle: TextStyle,
	sectionRadius: 10.0,
	errorTextStyle: TextStyle,
	fieldRadius: double,
	helpTextStyle:TextStyle ,
	sectionCardPadding: 8.0,
	requiredText: '(required)',
	errorColor: COLOR,
	successColor: COLOR,
	labels: GSFormLabels.es, // built-in texts: From/To, Camera/Gallery, QR scanner title, Next/Back/Submit
	compactBreakpoint: 600, // below this section width, fields use compactWeight
)

// Or derive everything from your app theme:
GSFormStyle.fromTheme(Theme.of(context))

```

<td><img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/style.png?raw=true" alt="alternatetext" width="250" height="450">
	  </td>
  </tr>
 </table>

## Dark Support
When no style is given (neither `style:` nor a `GSFormStyle` theme extension), GSForm picks its built-in light or dark
style from the app's brightness. With a custom style, handle dark mode yourself, e.g. with `GSFormStyle.fromTheme`.

<p align="center">
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/darksupport.png?raw=true" alt="alternatetext"  height="450">
</br>
</p>

## Direction
Some languages of the world (Arabic, Hebrew etc.) are RTL, meaning they are read right-to-left, instead of left-to-right. GSForm Support RTL Direction !

## Required Marker
Required fields show `GSFormStyle.requiredText` next to their title (empty by default), e.g. `requiredText: '*'` or
`requiredText: '(required)'`. It is drawn in `errorColor`.

## Fields

<table>
<tr>
<td> Row </td> <td> Field </td> <td> Sample Code </td> <td> Preview </td>
</tr>

<tr style="width:100%;">
<td> 1 </td>
<td>
<a href="#text">Text</a>
</td>
<td>

```dart
GSField.text(
	tag: 'postalCode',
	title: 'title',
	minLine: 1,
	maxLine: 1,
	weight: 12,
	required: true,
	maxLength: 100,
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	validateRegEx: regX,
	postfixWidget: widget,
	prefixWidget: widget,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/text.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 2 </td>
<td>
<a href="#textplain">Text Plain</a>
</td>
<td>

```dart
 GSField.textPlain(
	tag: 'textualAddress',
	title: 'title',
	weight: 12,
	required: true,
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	maxLength: 100,
	maxLine: 2,
	minLine: 1,
	postfixWidget: widget,
	prefixWidget: widget,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/text_plain.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 3 </td>
<td>
<a href="#number">Number</a>
</td>
<td>

```dart
   GSField.number(
	tag: '',
	title: 'title',
	weight: 12,
	maxLength: 11,
	required: true,
	errorMessage: 'Error Message',
	helpMessage: 'less than 100',
),
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/number.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr id="my-row">
<td> 4 </td>
<td>
<a href="#spinner">Spinner</a>
</td>
<td>

```dart
  GSField.spinner(
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	tag: 'tag',
	required: true,
	weight: 12,
	title: 'title',
	items: [
	SpinnerDataModel(
	name: '',
	id: 1,),
	],
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/spinner.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 5 </td>
<td>
<a href="#datepicker">Date Picker</a>
</td>
<td>

```dart
 GSField.datePicker(
	tag: 'tag',
	title: 'title',
	weight: 12,
	isPastAvailable: false,
	required: true,
	postfixWidget: widget,
	displayDateType: GSDateFormatType.numeric,
	initialDate: GSDate(year: 2026, month: 1, day: 1),
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	prefixWidget: widget,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/date.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 6 </td>
<td>
<a href="#daterangedpicker">Date Ranged Picker</a>
</td>
<td>

```dart
GSField.dateRangePicker(
	tag: 'tag',
	title: 'title',
	weight: 12,
	required: true,
	postfixWidget: widget,
	displayDateType: GSDateFormatType.numeric,
	isPastAvailable: false,
	availableFrom: GSDate(year: 2026, month: 1, day: 1),
	availableTo: GSDate(year: 2026, month: 12, day: 31),
	from: 'From : ',
	to: 'To : ',
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	prefixWidget: widget,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/range_date.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 7 </td>
<td>
<a href="#timepicker">Time Picker</a>
</td>
<td>

```dart
GSField.time(
	tag: 'tag',
	prefixWidget: widget,
	postfixWidget: widget,
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	required: true,
	initialTime: TimeOfDay,
	weight: 12
	)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/time.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 8 </td>
<td>
<a href="#mobile">Mobile</a>
</td>
<td>

```dart
GSField.mobile(
	tag: 'tag',
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	title: 'title',
	maxLength: 11,
	postfixWidget: widget,
	prefixWidget: widget,
	validateRegEx: regex,
	weight: 12,
	required: true,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/mobile.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 9 </td>
<td>
<a href="#email">Email</a>
</td>
<td>

```dart
GSField.email(
	tag: 'tag',
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	title: 'title',
	maxLength: 11,
	postfixWidget: widget,
	prefixWidget: widget,
	validateRegEx: regex,
	weight: 12,
	required: true,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/email.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 10 </td>
<td>
<a href="#password">Password</a>
</td>
<td>

```dart
GSField.password(
	tag: 'tag',
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	title: 'title',
	maxLength: 11,
	prefixWidget: widget,
	weight: 12,
	required: true,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/password.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 11 </td>
<td>
<a href="#price">Price</a>
</td>
<td>

```dart
GSField.price(
	tag: 'tag',
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
	title: 'title',
	maxLength: 11,
	prefixWidget: widget,
	currencyName: "\$" ,
	weight: 12,
	required: true,
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/price.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

<tr>
<td> 12 </td>
<td>
Bank Card
</td>
<td>

```dart
GSField.bankCard(
	tag: 'tag',
	postfixWidget: widget,
	prefixWidget: widget,
	title: 'title',
	weight: 12,
	required: true,
	errorMessage: 'error message',
	hint: 'hint message',
	helpMessage: 'help message',
)
```

</td>
<td>
<img src="https://github.com/ajomuch92/gsform_plus/blob/main/screenshot/card.png?raw=true" alt="alternatetext" width="150" height="270">
</td>
</tr>

</table>

## Attributes

Some features are common to all fields, which are introduced in the table below. The specific
features of each field will be explained in detail below.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>title</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>title of component</td>
  </tr>
  <tr>
    <td>tag</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>this is the id of component for receiving data</td>
  </tr>
  <tr>
    <td>errorMessage</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>message shown below the field when it is invalid</td>
  </tr>
    <tr>
    <td>helpMessage</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this is the help message that shown in component</td>
  </tr>
   <tr>
    <td>prefixWidget</td>
    <td><code> Widget </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this is the prefixWidget and  you can pass widget to show</td>
  </tr>
   <tr>
    <td>postfixWidget</td>
    <td><code> Widget </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this is the postfixWidget and  you can pass widget to show</td>
  </tr>
  <tr>
    <td>required</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this boolean show the component status for validation</td>
  </tr>
  <tr>
    <td>showTitle</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this boolean is for make title above of component visible or inVisible</td>
  </tr>
    <tr>
    <td>status</td>
    <td><code> GSFieldStatusEnum </code></td>
    <td><code>  normal, success, error, disabled </code></td>
    <td><code> false </code></td>
    <td>initial status of the field; <code>disabled</code> makes it read-only and skips validation</td>
  </tr>
     <tr>
    <td>validateRegEx</td>
    <td><code> RegExp </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this regx for custom regx that can entered by user</td>
  </tr>
    <tr>
    <td>weight</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>you can set weight for widget and max is 12 in each line</td>
  </tr>
  <tr>
    <td>validator</td>
    <td><code> String? Function(dynamic value) </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>runs after <code>required</code>/<code>validateRegEx</code>; return an error message to show, or <code>null</code> when valid</td>
  </tr>
  <tr>
    <td>onChanged</td>
    <td><code> ValueChanged&lt;dynamic&gt; </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>called with the new value when the user changes the field</td>
  </tr>
  <tr>
    <td>asyncValidator</td>
    <td><code> Future&lt;String?&gt; Function(dynamic value) </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>async check (e.g. against a server) run by <code>isValidAsync()</code> and the stepper after the sync checks pass</td>
  </tr>
  <tr>
    <td>visibleWhen</td>
    <td><code> bool Function(Map&lt;String, dynamic&gt; values) </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>the field is only part of the form while this returns true; hidden fields are not validated or submitted</td>
  </tr>
  <tr>
    <td>compactWeight</td>
    <td><code> int </code></td>
    <td> 1 - 12 </td>
    <td><code> false </code></td>
    <td>weight used when the section is narrower than <code>GSFormStyle.compactBreakpoint</code></td>
  </tr>
</table>

Form-level options (on <code>GSForm.singleSection</code> / <code>GSForm.multiSection</code> / <code>GSForm.stepper</code>):

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>controller</td>
    <td><code> GSFormController </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>read/write values, validate, reset and enable/disable fields from outside the tree</td>
  </tr>
  <tr>
    <td>autovalidateMode</td>
    <td><code> AutovalidateMode </code></td>
    <td> disabled, onUserInteraction, always </td>
    <td><code> false </code></td>
    <td>validate fields while the user edits them (default <code>disabled</code>)</td>
  </tr>
  <tr>
    <td>onChanged</td>
    <td><code> void Function(String tag, dynamic value) </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>called when any field changes</td>
  </tr>
  <tr>
    <td>style</td>
    <td><code> GSFormStyle </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>overrides the theme extension and the built-in light/dark styles</td>
  </tr>
  <tr>
    <td>onComplete</td>
    <td><code> ValueChanged&lt;Map&lt;String, dynamic&gt;&gt; </code></td>
    <td> - </td>
    <td><code> stepper only, true </code></td>
    <td>called with every value when the last step is submitted and valid</td>
  </tr>
  <tr>
    <td>onStepChanged</td>
    <td><code> ValueChanged&lt;int&gt; </code></td>
    <td> - </td>
    <td><code> stepper only, false </code></td>
    <td>called with the new step index</td>
  </tr>
</table>

## Text

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
</table>

## TextPlain

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
   <tr>
    <td>minLine</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>minimum line of text</td>
  </tr>
  <tr>
    <td>maxLine</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum line of text</td>
  </tr>
  <tr>
    <td>showCounter</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this boolean make counter of textField visible or invisible </td>
  </tr>
</table>

## Number

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
</table>

## Spinner

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>items</td>
	  <td><code> List[SpinnerDataModel] </code></br></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>List of data that fill spinner</td>
  </tr>
</table>

## Mobile

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
</table>

## Email

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
</table>

## Password

<table>
 <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
 <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
</table>

## Price

<table>
 <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
 <tr>
    <td>maxLenght</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>maximum lenght of text</td>
  </tr>
  <tr>
    <td>currencyName</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>the Currency text for example $ </td>
  </tr>
</table>

## DatePicker

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>initialDate</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>initialDate of calendar</td>
  </tr>
  <tr>
    <td>availableFrom</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>available date from</td>
  </tr>
  <tr>
    <td>availableTo</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>available date to</td>
  </tr>
  <tr>
    <td>isPastAvailable</td>
    <td><code> boolean </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this boolean show is past available or not</td>
  </tr>
   <tr>
    <td>displayDateType</td>
    <td><code> GSDateFormatType </code></td>
    <td> <code> numeric, // 7/21/2026 </code></br> <code> fullText, // Tuesday, July 21, 2026 </code></br> <code> mediumText, // Tue, Jul 21 </code></br> <code> shortText, // Jul 21, 2026 </code></br> </td>
    <td><code> false </code></td>
    <td>you can pass ENUM type for calendar date type</td>
  </tr>
</table>

## DateRangedPicker

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>displayDateType</td>
    <td><code> GSDateFormatType </code></td>
    <td> <code> numeric, // 7/21/2026 </code></br> <code> fullText, // Tuesday, July 21, 2026 </code></br> <code> mediumText, // Tue, Jul 21 </code></br> <code> shortText, // Jul 21, 2026 </code></br> </td>
    <td><code> false </code></td>
    <td>you can choose type of display type</td>
  </tr>
  <tr>
    <td>initialDate</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>initial date  of calendar</td>
  </tr>
  <tr>
    <td>availableFrom</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>available date from</td>
  </tr>
  <tr>
    <td>availableTo</td>
    <td><code> GSDate </code></td>
    <td>  year,month,day </td>
    <td><code> false </code></td>
    <td>available date to</td>
  </tr>
  <tr>
    <td>isPastAvailable</td>
    <td><code> boolean </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>this boolean show is past available or not</td>
  </tr>
  <tr>
    <td>from</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>label before the start date; defaults to <code>GSFormStyle.labels.from</code></td>
  </tr>

  <tr>
    <td>to</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>label before the end date; defaults to <code>GSFormStyle.labels.to</code></td>
  </tr>
</table>

## TimePicker

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>initialTime</td>
    <td><code> TimeOfDay </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial time of calendar</td>
  </tr>
</table>

## Masked

Value: the text as shown, literals included (e.g. `(555) 123-4567`). `required` needs the mask complete unless `validateRegEx` is set.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>mask</td>
    <td><code> String </code></td>
    <td> <code>#</code> digit, <code>A</code> letter, <code>*</code> either; anything else is a literal </td>
    <td><code> true </code></td>
    <td>e.g. <code>(###) ###-####</code>, <code>AA-####</code>. Literals must not be digits or letters</td>
  </tr>
  <tr>
    <td>hint</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>placeholder; defaults to the mask</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial value (raw or already masked)</td>
  </tr>
  <tr>
    <td>keyboardType</td>
    <td><code> TextInputType </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>keyboard to show</td>
  </tr>
  <tr>
    <td>readOnly</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>disable editing</td>
  </tr>
</table>

## PinCode

Value: the entered digits as a `String`. Supports paste and SMS one-time-code autofill.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>length</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>number of digits (default 6); <code>required</code> needs all of them</td>
  </tr>
  <tr>
    <td>obscure</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>show dots instead of digits</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial value</td>
  </tr>
</table>

## Toggle

Value: `bool`. With `required: true` it must be on (e.g. accepting terms).

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>hint</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>label next to the switch</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial state (default off)</td>
  </tr>
</table>

## Slider

Value: `double`, or `RangeValues` when `isRange` is true. Always valid.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>min</td>
    <td><code> double </code></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>lowest value</td>
  </tr>
  <tr>
    <td>max</td>
    <td><code> double </code></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>highest value</td>
  </tr>
  <tr>
    <td>divisions</td>
    <td><code> int </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>number of discrete steps; also shows a value label while dragging</td>
  </tr>
  <tr>
    <td>isRange</td>
    <td><code> bool </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>pick a range instead of a single value</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> double / RangeValues </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial value (defaults to <code>min</code> / the full range)</td>
  </tr>
</table>

## Autocomplete

Value: the picked `SpinnerDataModel`. Typing alone is not a value; the user has to choose a suggestion.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>items</td>
    <td><code> List&lt;SpinnerDataModel&gt; </code></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>suggestions, matched by name (case-insensitive, contains)</td>
  </tr>
  <tr>
    <td>hint</td>
    <td><code> String </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>placeholder</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> SpinnerDataModel </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial selection</td>
  </tr>
</table>

## Custom

Value: whatever your builder reports. `required` fails on `null`, empty strings and empty collections.

<table>
  <tr>
    <td>Attribute</td>
    <td>Type</td>
    <td>Values</td>
    <td>Required</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>builder</td>
    <td><code> Widget Function(BuildContext, dynamic value, ValueChanged&lt;dynamic&gt; onChanged) </code></td>
    <td> - </td>
    <td><code> true </code></td>
    <td>builds the input; call <code>onChanged</code> with the new value</td>
  </tr>
  <tr>
    <td>value</td>
    <td><code> dynamic </code></td>
    <td> - </td>
    <td><code> false </code></td>
    <td>initial value</td>
  </tr>
</table>


<!-- 

### Deploy (how to install build product)

Direct to MP package if any. Otherwise provide steps to deploy on Nuxeo Platform:

> Copy the built artifacts into `$NUXEO_HOME/templates/custom/bundles/` and activate the `custom` template.

## Resources (Documentation and other links)

## Contributing / Reporting issues

Link to JIRA component (or project if there is no component for that project). Samples:

* [Link to component](https://jira.nuxeo.com/issues/?jql=project%20%3D%20NXP%20AND%20component%20%3D%20Elasticsearch%20AND%20Status%20!%3D%20%22Resolved%22%20ORDER%20BY%20updated%20DESC%2C%20priority%20DESC%2C%20created%20ASC)
* [Link to project](https://jira.nuxeo.com/secure/CreateIssue!default.jspa?project=NXP)
 -->
 

## Credits

Originally created by [Golrang System](https://github.com/golrangsystem/gsform) and published as
[gsform](https://pub.dev/packages/gsform) under the Apache License 2.0. This package is a modified,
maintained continuation; see [CHANGELOG.md](CHANGELOG.md) for what changed.

## Contributors
<a href="https://github.com/ajomuch92/gsform_plus/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ajomuch92/gsform_plus" />
</a>

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)


