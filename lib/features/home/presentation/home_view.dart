import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:finder/features/home/presentation/widget/filter_options.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:finder/features/home/presentation/widget/real_estate_card.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _filterKey1 = GlobalKey(); // For first filter
    final GlobalKey _filterKey2 = GlobalKey(); // For second filter
    final GlobalKey _filterKey3 = GlobalKey(); // For third filter

    // return
    // BlocBuilder<HomeCubit, HomeState>(
    //   builder: (context, state) {
    //     final choiseIndex = state is HomeUpdated ? state.choiseIndex : 0;
    //     print('the current index is $choiseIndex');

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
                  child: GestureDetector(
                    onTap: () {
                      //on pressed show the scaffold filtering widget
                      _showFilterBottomSheet(context);
                    },
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
    //   },
    // );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // City Dropdown
                    _buildDropdown(AppLocalizations.of(context)!.city,
                        AppLocalizations.of(context)!.select_city),
                    const SizedBox(height: 16),
                    // Sale/Rent Toggle
                    _buildToggleButtons(context),
                    const SizedBox(height: 16),
                    // Property Type Dropdown
                    _buildDropdown(AppLocalizations.of(context)!.property_type,
                        AppLocalizations.of(context)!.select_type),
                    const SizedBox(height: 16),
                    // Price Range Fields
                    _buildPriceRange(context),
                    const SizedBox(height: 16),
                    // Area Range Fields
                    _buildAreaRange(context),
                    const SizedBox(height: 16),
                    // Search Button
                    _buildSearchButton(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyle.getMediumStyle(
                color: AppColors.black, fontSize: AppFontSize.size_16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          hint: Text(hint),
          items:
              <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {},
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<HomeCubit>().updateChoiceIndex(0);
          },
          child: Text(AppLocalizations.of(context)!.for_rent,
              style: AppTextStyle.getMediumStyle(
                  color: context.read<HomeCubit>().choiseIndex == 0
                      ? AppColors.white
                      : AppColors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.read<HomeCubit>().choiseIndex == 0
                ? AppColors.primary
                : AppColors.white,
            minimumSize: const Size(140, 50),
          ),
        ),
        const SizedBox(
          width: AppPaddingSize.padding_24,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<HomeCubit>().updateChoiceIndex(1);
          },
          child: Text(AppLocalizations.of(context)!.for_sale,
              style: AppTextStyle.getMediumStyle(
                  color: context.read<HomeCubit>().choiseIndex == 1
                      ? AppColors.white
                      : AppColors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.read<HomeCubit>().choiseIndex == 1
                ? AppColors.primary
                : AppColors.white,
            minimumSize: const Size(140, 50),
          ),
        )
      ],
    );
  }

  Widget _buildPriceRange(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.price_range,
            style: AppTextStyle.getMediumStyle(
                color: AppColors.black, fontSize: AppFontSize.size_16)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRangeInput(AppLocalizations.of(context)!.from, '700,000'),
            const SizedBox(width: 8),
            _buildRangeInput(AppLocalizations.of(context)!.to, '1,000,000'),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaRange(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.area_range,
            style: AppTextStyle.getMediumStyle(
                color: AppColors.black, fontSize: AppFontSize.size_16)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRangeInput(AppLocalizations.of(context)!.from, '10'),
            const SizedBox(width: 8),
            _buildRangeInput(AppLocalizations.of(context)!.to, '300'),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeInput(String label, String hint) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTextStyle.getMediumStyle(
              color: AppColors.black, fontSize: AppFontSize.size_16),
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return CustomButton(text: AppLocalizations.of(context)!.search);
  }
}
