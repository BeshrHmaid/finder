import 'package:flutter/material.dart';

class AppDialog {
  AppDialog({
    this.cancel,
    this.confirm,
    this.isHaveCancel,
    this.body,
    this.function,
    this.height,
    this.buildContext,
    this.btnWidth,
  });
  final bool? isHaveCancel;
//  final bool? isHaveConfirm;
  String? cancel = "Cancel";
  String? confirm = "Ok";
  final Widget? body;
  final Function? function;
  final double? height;
  final BuildContext? buildContext;
  double? btnWidth;
}

class AppCustomAlertDialog {
  static Future dialog(
      {required Widget widget,
      required BuildContext context,
      Color? backgroundColor,
      EdgeInsets? paddingDialog}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetAnimationCurve: Curves.linear,
            alignment: Alignment.center,
            elevation: 3.0,
            //clipBehavior: Clip.antiAlias,
            backgroundColor: backgroundColor,
            insetPadding: paddingDialog ?? EdgeInsets.zero,
            child: widget,
          );
        });
  }

  static Future alertDialog(
      {required BuildContext context, required Widget widget}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  const EdgeInsets.only(top: 8, bottom: 0, left: 0, right: 0),
              content: widget);
        });
  }
}
