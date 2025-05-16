import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PersonalCardInfo extends StatelessWidget {
  const PersonalCardInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppPaddingSize.padding_16),
        child: Container(
          height: MediaQuery.sizeOf(context).height * .15,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${AppLocalizations.of(context)!.username} : '),
                      const Text('BeshrHmaid'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('${AppLocalizations.of(context)!.joined_at} : '),
                      const Text('10 Mar 2025'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          '${AppLocalizations.of(context)!.profile_status} : '),
                      const Text('Premuim'),
                    ],
                  ),
                ],
              ),
              //profile image
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.iconsProfile,
                    height: 96,
                    width: 96,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
