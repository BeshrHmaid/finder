import 'package:flutter/material.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';

import '../../constant/app_colors/app_colors.dart';
import '../../constant/text_styles/app_text_style.dart';
import '../../constant/text_styles/font_size.dart';

class ActionAlertDialog extends StatelessWidget {
  final String? message;
  final String dialogTitle;
  final Widget? imageWidget;
  final String? cancelText;
  final String? confirmText;
  final Widget? secondaryWidget;
  final VoidCallback? onCancel;
  final Function? onWillPopScope;
  final VoidCallback? onConfirm;
  final Function? hideDialog;
  final bool? isExistOr;
  final double? padding;
  final Color? color;
  final Color? confirmFillColor;
  final TextStyle? titleStyle;
  final TextStyle? buttonStyle;

  static Future<void> show(
    BuildContext context, {
    String? message,
    required String dialogTitle,
    Widget? imageWidget,
    String? cancelText,
    TextStyle? titleStyle,
    String? confirmText,
    TextStyle? buttonStyle,
    VoidCallback? onCancel,
    final VoidCallback? onWillPopScope,
    VoidCallback? onConfirm,
    Alignment? alignment,
    Color? color,
    Color? confirmFillColor,
    Function? hideDialog,
    final Widget? secondaryWidget,
    bool isExistOr = false,
    double? padding,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (hideDialog != null) hideDialog();
        return WillPopScope(
          onWillPop: () async {
            if (onWillPopScope != null) onWillPopScope();
            return true;
          },
          child: Dialog(
            alignment: alignment,
            backgroundColor: color ?? Colors.white,
            insetPadding: EdgeInsets.all(padding ?? 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ActionAlertDialog(
              message: message,
              onCancel: onCancel,
              onConfirm: onConfirm,
              cancelText: cancelText,
              confirmText: confirmText,
              dialogTitle: dialogTitle,
              imageWidget: imageWidget,
              isExistOr: isExistOr,
              titleStyle: titleStyle,
              buttonStyle: buttonStyle,
              secondaryWidget: secondaryWidget,
              color: color,
              confirmFillColor: confirmFillColor,
            ),
          ),
        );
      },
    );
  }

  const ActionAlertDialog({
    super.key,
    required this.message,
    required this.dialogTitle,
    this.onWillPopScope,
    this.onCancel,
    this.titleStyle,
    this.buttonStyle,
    required this.onConfirm,
    required this.cancelText,
    required this.confirmText,
    this.imageWidget,
    this.secondaryWidget,
    this.hideDialog,
    this.isExistOr,
    this.padding,
    this.color,
    this.confirmFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: AppPaddingSize.padding_12,
            horizontal: padding ?? AppPaddingSize.padding_12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                if (imageWidget != null) imageWidget!,
                const Spacer(),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close)),
                ),
              ],
            ),
            if (dialogTitle.isNotEmpty)
              const SizedBox(height: AppPaddingSize.padding_25),
            if (dialogTitle.isNotEmpty)
              Text(
                dialogTitle,
                textAlign: TextAlign.center,
                style: titleStyle ??
                    AppTextStyle.getMediumStyle(
                        color: AppColors.black14,
                        fontSize: AppFontSize.size_14),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getMediumStyle(
                      color: AppColors.black14, fontSize: AppFontSize.size_12),
                ),
              ),
            const SizedBox(height: AppPaddingSize.padding_25),
            if (secondaryWidget != null) secondaryWidget!,
            if (secondaryWidget == null) const SizedBox(height: 8),
            Row(
              children: [
                if (cancelText != null)
                  Expanded(
                      child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor: WidgetStatePropertyAll(
                          confirmFillColor ?? Colors.white,
                        ),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            side: BorderSide(color: AppColors.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)))),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        cancelText!,
                        textAlign: TextAlign.center,
                        style: buttonStyle ??
                            AppTextStyle.getMediumStyle(
                                color: AppColors.black14,
                                fontSize: AppFontSize.size_14),
                      ),
                    ),
                  )),
                const SizedBox(width: AppPaddingSize.padding_12),
                if (confirmText != null)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                            confirmFillColor ?? AppColors.primary,
                          ),
                          shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  side: BorderSide(color: AppColors.grey9A),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                        ),
                        onPressed: onConfirm,
                        child: Text(
                          confirmText!,
                          style: buttonStyle ??
                              AppTextStyle.getMediumStyle(
                                  color: AppColors.white,
                                  fontSize: AppFontSize.size_14),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppPaddingSize.padding_30),
          ],
        ),
      ),
    );
  }
}
