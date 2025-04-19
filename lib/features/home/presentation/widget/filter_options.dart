import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterOptions extends StatelessWidget {
  const FilterOptions({
    super.key,
    required GlobalKey<State<StatefulWidget>> filterKey1,
    required GlobalKey<State<StatefulWidget>> filterKey2,
    required GlobalKey<State<StatefulWidget>> filterKey3,
  })  : _filterKey1 = filterKey1,
        _filterKey2 = filterKey2,
        _filterKey3 = filterKey3;

  final GlobalKey<State<StatefulWidget>> _filterKey1;
  final GlobalKey<State<StatefulWidget>> _filterKey2;
  final GlobalKey<State<StatefulWidget>> _filterKey3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First filter (latest filter)
        GestureDetector(
          key: _filterKey1,
          onTap: () {
            // Get the position of the GestureDetector widget
            final RenderBox renderBox =
                _filterKey1.currentContext!.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            // Show the drop-down list with elevation 3 under the GestureDetector
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                position.dx,
                position.dy + size.height,
                MediaQuery.of(context).size.width - position.dx - size.width,
                0,
              ),
              items: [
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text('Option 1'),
                ),
                const PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text('Option 2'),
                ),
              ],
              elevation: 3,
            ).then((value) {
              // Handle selected option for the first filter
              if (value != null) {
                print('Selected: $value');
              }
            });
          },
          child: Row(
            children: [
              SvgPicture.asset(Assets.iconsArrowUpArrowDown,
                  color: AppColors.primary),
              const SizedBox(
                width: 6,
              ),
              Text(AppLocalizations.of(context)!.latest)
            ],
          ),
        ),
        // Second filter (all cities filter)
        GestureDetector(
          key: _filterKey2,
          onTap: () {
            // Get the position of the GestureDetector widget
            final RenderBox renderBox =
                _filterKey2.currentContext!.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            // Show the drop-down list with elevation 3 under the GestureDetector
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                position.dx,
                position.dy + size.height,
                MediaQuery.of(context).size.width - position.dx - size.width,
                0,
              ),
              items: [
                const PopupMenuItem<String>(
                  value: 'City 1',
                  child: Text('City 1'),
                ),
                const PopupMenuItem<String>(
                  value: 'City 2',
                  child: Text('City 2'),
                ),
              ],
              elevation: 3,
            ).then((value) {
              // Handle selected option for the second filter
              if (value != null) {
                print('Selected: $value');
              }
            });
          },
          child: Row(
            children: [
              SvgPicture.asset(Assets.iconsPinLocation,
                  color: AppColors.primary),
              const SizedBox(
                width: 6,
              ),
              Text(AppLocalizations.of(context)!.all_cities)
            ],
          ),
        ),
        // Third filter (all filter)
        GestureDetector(
          key: _filterKey3,
          onTap: () {
            // Get the position of the GestureDetector widget
            final RenderBox renderBox =
                _filterKey3.currentContext!.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            // Show the drop-down list with elevation 3 under the GestureDetector
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                position.dx,
                position.dy + size.height,
                MediaQuery.of(context).size.width - position.dx - size.width,
                0,
              ),
              items: [
                const PopupMenuItem<String>(
                  value: 'Option A',
                  child: Text('Option A'),
                ),
                const PopupMenuItem<String>(
                  value: 'Option B',
                  child: Text('Option B'),
                ),
              ],
              elevation: 3,
            ).then((value) {
              // Handle selected option for the third filter
              if (value != null) {
                print('Selected: $value');
              }
            });
          },
          child: Row(
            children: [
              SvgPicture.asset(Assets.iconsArrowDown, color: AppColors.primary),
              const SizedBox(
                width: 6,
              ),
              Text(AppLocalizations.of(context)!.all)
            ],
          ),
        ),
      ],
    );
  }
}
