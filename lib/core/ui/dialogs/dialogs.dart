import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static showSnackBar({
    required String message,
    required BuildContext context,
    AnimatedSnackBarType typeSnackBar = AnimatedSnackBarType.success,
  }) {
    return AnimatedSnackBar(
      builder: (context) {
        final isSuccess = typeSnackBar == AnimatedSnackBarType.success;
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              minWidth: 200,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isSuccess
                  ? Colors.green.shade700.withOpacity(0.3)
                  : Colors.red.shade700.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isSuccess ? Colors.green : Colors.red).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
              // Glassmorphism effect (blur not natively supported in Flutter, so using opacity)
              backgroundBlendMode: BlendMode.overlay,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing icon
                AnimatedScale(
                  scale: 1.1,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: Icon(
                    isSuccess ? Icons.star : Icons.warning_rounded,
                    color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Message with shadow
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Close button
                // IconButton(
                // icon:
                // const Icon(
                //   Icons.close,
                //   color: Colors.white70,
                //   size: 20,
                // ),
                // onPressed: () => AnimatedSnackBar.remove(true),
                // ),
              ],
            ),
          ),
        );
      },
      duration: const Duration(seconds: 4),
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
      animationCurve: Curves.bounceOut,
      animationDuration: const Duration(milliseconds: 600),
    ).show(context);
  }

  static showErrorSnackBar({
    required String message,
    required BuildContext context,
    AnimatedSnackBarType typeSnackBar = AnimatedSnackBarType.error,
  }) {
    return showSnackBar(
      message: message,
      context: context,
      typeSnackBar: typeSnackBar,
    );
  }
}
