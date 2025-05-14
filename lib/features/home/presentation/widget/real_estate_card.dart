import 'package:cached_network_image/cached_network_image.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RealEstateCard extends StatelessWidget {
  const RealEstateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Adds shadow/elevation to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with CachedNetworkImage
          Stack(
            children: [
              Container(
                height: 200, // Height of the image
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg',
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
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
                      label: Text(AppLocalizations.of(context)!.newww,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red, // Red color for "New" tag
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(AppLocalizations.of(context)!.for_sale_chip,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor:
                          Colors.green, // Green color for "For Sale" tag
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
                // Property title (e.g., 1600 m² Building)
                Text(
                  '1600 ${AppLocalizations.of(context)!.square_meter} ${AppLocalizations.of(context)!.building}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    const Text('Rural Damascus-Kassoua',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                // Time ago text (e.g., 8 hours ago)
                const Text('Posted 8 hours ago',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                // Views count and contact icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.visibility,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('9 ${AppLocalizations.of(context)!.views}',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.contact,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Price
                Text('10.4 ${AppLocalizations.of(context)!.million_ls}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
