import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';
import 'package:finder/features/home/integration/integration.dart';
import 'package:finder/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:finder/features/home/presentation/widget/filter_options.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:finder/features/home/presentation/widget/real_estate_card.dart';
import 'package:finder/features/home/presentation/widget/search_news_integration.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _filterKey1 = GlobalKey();
    final GlobalKey _filterKey2 = GlobalKey();
    final GlobalKey _filterKey3 = GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppFontSize.size_12, vertical: AppFontSize.size_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeViewHeader(),
          const SizedBox(height: AppPaddingSize.padding_14),
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
          const SizedBox(height: AppPaddingSize.padding_14),
          FilterOptions(
              filterKey1: _filterKey1,
              filterKey2: _filterKey2,
              filterKey3: _filterKey3),
          const SizedBox(height: AppPaddingSize.padding_14),
          Expanded(
            child: GetModel(
              useCaseCallBack: () {
                return GetHousesUseCase(homeRepository: HomeRepository())
                    .call(params: GetHouseParams());
              },
              modelBuilder: (ListHouseModel houses) {
                return ListView.separated(
                    itemBuilder: (context, index) => RealEstateCard(
                          houseModel: houses.data[index],
                        ),
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemCount: houses.data.length);
              },
            ),
          )
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _FilterBottomSheet();
      },
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  __FilterBottomSheetState createState() => __FilterBottomSheetState();
}

class __FilterBottomSheetState extends State<_FilterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _city;
  String? _listingType = 'for-buy';
  final _minPriceController = TextEditingController();

  final List<String> _cities = [
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Ras Al Khaimah',
  ];

  @override
  void dispose() {
    _minPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Title
                  Text(
                    AppLocalizations.of(context)!.filter,
                    style: AppTextStyle.getMediumStyle(
                        color: AppColors.black, fontSize: AppFontSize.size_20),
                  ),
                  const SizedBox(height: 16),
                  // City Dropdown
                  _buildDropdown(
                    label: AppLocalizations.of(context)!.city,
                    hint: AppLocalizations.of(context)!.select_city,
                    value: _city,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a city' : null,
                  ),
                  const SizedBox(height: 16),
                  // Listing Type Toggle
                  _buildToggleButtons(context),
                  const SizedBox(height: 16),
                  // Minimum Price
                  TextFormField(
                    controller: _minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Price',
                      hintText: '800000',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a minimum price';
                      }
                      if (num.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Search Button
                  SizedBox(
                    width: 200,
                    child: CreateModel(
                      child: CustomButton(
                          text: AppLocalizations.of(context)!.search),
                      withValidation: true,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<HomeCubit>().updateSearchParams(
                                q: _city ?? '',
                                minPrice: num.parse(_minPriceController.text),
                                listingType: _listingType,
                              );
                          return true;
                        }
                        return false;
                      },
                      useCaseCallBack: (x) {
                        return SearchNewsUseCase(repos: SerachNewsRepository())
                            .call(
                                params: context.read<HomeCubit>().searchParams);
                      },
                      onSuccess: (ListHouseModel houses) {
                        Navigator.pop(context);
                        // The GetModel widget in HomeView will handle UI update
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getMediumStyle(
              color: AppColors.black, fontSize: AppFontSize.size_16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Type',
          style: AppTextStyle.getMediumStyle(
              color: AppColors.black, fontSize: AppFontSize.size_16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _listingType = 'for-buy';
                });
              },
              child: Text(
                AppLocalizations.of(context)!.for_sale,
                style: AppTextStyle.getMediumStyle(
                    color: _listingType == 'for-buy'
                        ? AppColors.white
                        : AppColors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _listingType == 'for-buy'
                    ? AppColors.primary
                    : AppColors.white,
                minimumSize: const Size(140, 50),
              ),
            ),
            const SizedBox(width: AppPaddingSize.padding_24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _listingType = 'for-rent';
                });
              },
              child: Text(
                AppLocalizations.of(context)!.for_rent,
                style: AppTextStyle.getMediumStyle(
                    color: _listingType == 'for-rent'
                        ? AppColors.white
                        : AppColors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _listingType == 'for-rent'
                    ? AppColors.primary
                    : AppColors.white,
                minimumSize: const Size(140, 50),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
