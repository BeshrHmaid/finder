import 'package:cached_network_image/cached_network_image.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_string/app_strings.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  // Text editing controllers for form fields
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@example.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "+1 (555) 123-4567");
  final TextEditingController _locationController =
      TextEditingController(text: "New York, USA");
  final TextEditingController _bioController = TextEditingController(
      text:
          "I'm looking for a peaceful home in the suburbs with a beautiful garden and access to good schools.");

  // Properties preferences
  bool _preferHouses = true;
  bool _preferApartments = false;
  double _minPrice = 200000;
  double _maxPrice = 500000;
  int _minBedrooms = 2;
  int _maxBedrooms = 4;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Image picker placeholder
  // String _profileImageUrl = "https://via.placeholder.com/150";
  bool _isUploading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Method to simulate image picking
  void _pickImage() {
    setState(() {
      _isUploading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
        // Keep the same image for this example
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated')),
      );
    });
  }

  // Method to save profile information
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        },
      );

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(); // Close loading dialog

        // Navigate back to profile screen
        Navigator.of(context).pop();

        // Show success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Profile updated successfully'),
        //     backgroundColor: AppColors.success,
        //   ),
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
            color: AppColors.white,
            tooltip: 'Save Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    )),
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Profile Image
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: AppStrings.dummyProfileImageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: _isUploading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : null,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child:
                                  const Icon(Icons.error, color: Colors.white),
                            ),
                          ),
                        ),

                        // Edit Image Button
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Change Profile Picture',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Personal Information Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Personal Information',
                  style: AppTextStyle.getBoldStyle(
                      color: AppColors.black14, fontSize: AppFontSize.size_18),
                ),
              ),

              // Full Name
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),

              // Email
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),

              // Phone
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),

              // Location
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon:
                        Icon(Icons.location_on, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                  ),
                ),
              ),

              // Bio
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'About Me',
                    hintText: 'Tell us about your home preferences...',
                    prefixIcon: Icon(Icons.edit_note, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ),

              // Property Preferences Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Property Preferences',
                  style: AppTextStyle.getBoldStyle(
                      color: AppColors.black14, fontSize: AppFontSize.size_18),
                ),
              ),

              // Property Types
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Types',
                      style: AppTextStyle.getMediumStyle(
                          color: AppColors.black14,
                          fontSize: AppFontSize.size_16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPropertyTypeSelector(
                            isSelected: _preferHouses,
                            icon: Icons.home,
                            label: 'Houses',
                            onTap: () {
                              setState(() {
                                _preferHouses = !_preferHouses;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPropertyTypeSelector(
                            isSelected: _preferApartments,
                            icon: Icons.apartment,
                            label: 'Apartments',
                            onTap: () {
                              setState(() {
                                _preferApartments = !_preferApartments;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price Range
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Range',
                      style: AppTextStyle.getMediumStyle(
                          color: AppColors.black14,
                          fontSize: AppFontSize.size_16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_minPrice.toInt()}',
                          style: const TextStyle(
                            color: AppColors.black14,
                          ),
                        ),
                        Text(
                          '\$${_maxPrice.toInt()}',
                          style: const TextStyle(
                            color: AppColors.black14,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 100000,
                      max: 1000000,
                      divisions: 18,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withOpacity(0.2),
                      labels: RangeLabels(
                        '\$${_minPrice.toInt()}',
                        '\$${_maxPrice.toInt()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Bedrooms Range
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bedrooms',
                      style: AppTextStyle.getMediumStyle(
                          color: AppColors.black14,
                          fontSize: AppFontSize.size_16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_minBedrooms.toInt()} Bedrooms',
                          style: const TextStyle(
                            color: AppColors.black14,
                          ),
                        ),
                        Text(
                          '${_maxBedrooms.toInt()} Bedrooms',
                          style: const TextStyle(
                            color: AppColors.black14,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(
                          _minBedrooms.toDouble(), _maxBedrooms.toDouble()),
                      min: 1,
                      max: 6,
                      divisions: 5,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withOpacity(0.2),
                      labels: RangeLabels(
                        '${_minBedrooms.toInt()}',
                        '${_maxBedrooms.toInt()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minBedrooms = values.start.toInt();
                          _maxBedrooms = values.end.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  onPressed: _saveProfile,
                  text: 'Save Profile',
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build property type selectors
  Widget _buildPropertyTypeSelector({
    required bool isSelected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey7F,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.black14,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.black14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
