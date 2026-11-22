import 'dart:io';

import 'package:flutter/widgets.dart';

/// Mobile/desktop: picked files are local paths; URLs still load from the network.
Widget gsFileImage(String path, {BoxFit? fit, double? width, double? height}) => path.startsWith('http')
    ? Image.network(path, fit: fit, width: width, height: height)
    : Image.file(File(path), fit: fit, width: width, height: height);
