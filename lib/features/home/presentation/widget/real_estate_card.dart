import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class RealEstateCard extends StatelessWidget {
  const RealEstateCard({super.key, required this.houseModel});
  final HouseModel houseModel;

  @override
  Widget build(BuildContext context) {
    // Parse photos into a list (assuming photos is a comma-separated string)
    final List<String>? imageUrls = houseModel.photos?.isNotEmpty ?? false
        ? houseModel.photos?.map((url) => '${baseUrl}$url').toList()
        : [
            'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'
          ];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel section
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay:
                          imageUrls!.length > 1, // Auto-play if multiple images
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                    items: imageUrls.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl.trim(),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Status tags at top-right
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        AppLocalizations.of(context)!.newww,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        '${houseModel.listingType}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Text information
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${houseModel.location}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Views count and contact icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        // Uncomment if you want to show views
                        // Icon(Icons.visibility, size: 16, color: Colors.grey),
                        // SizedBox(width: 4),
                        // Text(
                        //   '9 ${AppLocalizations.of(context)!.views}',
                        //   style: const TextStyle(fontSize: 12),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () async {
                            final phoneNumber = houseModel.ownerId?.phoneNumber;
                            if (phoneNumber != null) {
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: phoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not launch phone app',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.contact,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Price
                Text(
                  '${houseModel.price} ${AppLocalizations.of(context)!.million_ls}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
