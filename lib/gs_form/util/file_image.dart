import 'package:flutter/widgets.dart';

/// Web: picked files are blob/http URLs.
Widget gsFileImage(String path, {BoxFit? fit, double? width, double? height}) =>
    Image.network(path, fit: fit, width: width, height: height);
