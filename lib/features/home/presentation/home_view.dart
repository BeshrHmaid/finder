import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/features/home/presentation/widget/filter_options.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:finder/features/home/presentation/widget/real_estate_card.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _filterKey1 = GlobalKey(); // For first filter
    final GlobalKey _filterKey2 = GlobalKey(); // For second filter
    final GlobalKey _filterKey3 = GlobalKey(); // For third filter

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppFontSize.size_12, vertical: AppFontSize.size_12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeViewHeader(),
            const SizedBox(
              height: AppPaddingSize.padding_14,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Card(
                    elevation: 3,
                    child: CustomTextFormField(
                      borderColor: AppColors.primary,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          Assets.iconsMagnifier,
                          color: AppColors.primary,
                        ),
                      ),
                      hintText: AppLocalizations.of(context)!.search,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: AppColors.primary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.iconsFilter),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: AppPaddingSize.padding_14,
            ),
            FilterOptions(
                filterKey1: _filterKey1,
                filterKey2: _filterKey2,
                filterKey3: _filterKey3),
            const SizedBox(
              height: AppPaddingSize.padding_14,
            ),
            const RealEstateCard(),
            const RealEstateCard(),
            const RealEstateCard(),
            const RealEstateCard(),
          ],
        ),
      ),
    );
  }
}
