import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetailsPage extends StatelessWidget {
  final HouseModel houseModel;
  const HouseDetailsPage({super.key, required this.houseModel});

  @override
  Widget build(BuildContext context) {
    final List<String>? imageUrls = houseModel.photos?.isNotEmpty ?? false
        ? houseModel.photos?.map((url) => '${baseUrl}$url').toList()
        : ['${baseUrl}default_image.jpg'];

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Text(
            houseModel.title ?? 'No title',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: imageUrls!.length > 1,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 16 / 9,
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
                            const Icon(Icons.error, size: 50),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Chip(
                    label: Text(
                      houseModel.listingType ?? 'Not known',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            // Details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '${houseModel.price} ${AppLocalizations.of(context)!.million_ls}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          houseModel.location ?? 'No location',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    houseModel.description ?? 'No Description',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Owner Info
                  const Text(
                    'Owner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        houseModel.ownerId?.username ?? 'Unknown',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
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
                                    'Error launching phone url',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          houseModel.ownerId?.phoneNumber ?? 'No phone number',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Location Coordinates (Optional)

                  const SizedBox(height: 24),
                  // Contact Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
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
                                  'Error launching phone url',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Contact Owner',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
