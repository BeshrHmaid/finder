import 'package:flutter/material.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';

class BackWidget extends StatelessWidget {
  final Widget? titleWidget;
  final Widget? endWidget;
  final VoidCallback? onBack;
  final String? title;
  final bool existBack;
  const BackWidget(
      {super.key,
      this.titleWidget,
      this.title,
      this.onBack,
      this.endWidget,
      this.existBack = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (existBack)
          InkWell(
              onTap: onBack != null
                  ? onBack!
                  : () => Navigator.pop(
                        context,
                      ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              )),
        const Spacer(),
        titleWidget != null
            ? titleWidget!
            : Expanded(
                child: Text(
                  title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getMediumStyle(
                      color: Theme.of(context).colorScheme.themedBlack,
                      fontSize: AppFontSize.size_26),
                ),
              ),
        const Spacer(),
        if (endWidget != null) endWidget!,
      ],
    );
  }
}
