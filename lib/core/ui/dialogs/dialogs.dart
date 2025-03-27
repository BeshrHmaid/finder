import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static showSnackBar(
      {required String message,
      required BuildContext context,
      AnimatedSnackBarType typeSnackBar = AnimatedSnackBarType.success}) {
    return AnimatedSnackBar.material(message, type: typeSnackBar).show(context);
  }

  static showErrorSnackBar(
      {required String message,
      required BuildContext context,
      AnimatedSnackBarType typeSnackBar = AnimatedSnackBarType.error}) {
    return AnimatedSnackBar.material(message, type: typeSnackBar).show(context);
  }
}
