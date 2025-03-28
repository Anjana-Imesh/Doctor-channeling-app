/* import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';

Color strengthenColor(Color color, double factor) {
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();
  return Color.fromARGB(color.alpha, r, g, b);
}


Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

Future<File?> selectImage() async {
  final imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}
 */

import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';

Color strengthenColor(Color color, double factor) {
  // Convert color components to int
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();
  return Color.fromARGB(color.a.toInt(), r, g, b); // Ensure alpha is an int
}
/*
String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}
*/

String rgbToHex(Color color) {
  // Cast color components to int before using toRadixString
  return '${color.r.toInt().toRadixString(16).padLeft(2, '0')}'
         '${color.g.toInt().toRadixString(16).padLeft(2, '0')}'
         '${color.b.toInt().toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

Future<File?> selectImage() async {
  final imagePicker = ImagePicker();
  // Ensures proper handling of `pickImage` nullability
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}
