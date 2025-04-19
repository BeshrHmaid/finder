import 'package:cached_network_image/cached_network_image.dart';
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
              const Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    Chip(
                      label: Text('New', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red, // Red color for "New" tag
                    ),
                    SizedBox(width: 8),
                    Chip(
                      label: Text('For Sale',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor:
                          Colors.green, // Green color for "For Sale" tag
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Text information
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property title (e.g., 1600 m² Building)
                Text(
                  '1600 m² Building',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text('Rural Damascus-Kassoua',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 8),
                // Time ago text (e.g., 8 hours ago)
                Text('Posted 8 hours ago',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 8),
                // Views count and contact icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('9 views', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text('Contact',
                            style:
                                TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Price
                Text('10.4 Million L.S',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
